import Foundation
/// Implemetns the Lambert Conformal Conic 2SP Projection.
/// The Lambert Conformal Conic projection is a standard projection for presenting maps
/// of land areas whose East-West extent is large compared with their North-South extent.
/// This projection is "conformal" in the sense that lines of latitude and longitude,
/// which are perpendicular to one another on the earth's surface, are also perpendicular
/// to one another in the projected domain.
public class LambertConformalConic2SP: MapProjection {
	// Double _falseEasting;
	// Double _falseNorthing;
	// private Double es=0;              /* eccentricity squared         */
	// private Double e=0;               /* eccentricity                 */
	// private Double center_lon=0;      /* center longituted            */
	// private Double center_lat=0;      /* cetner latitude              */
	private var ns: Double = 0
	/* ratio of angle between meridian*/
    private var f0: Double = 0
	/* flattening of ellipsoid      */
    private var rh: Double = 0
	/* height above ellipsoid       */
	
	/* *
     * Creates an instance of an Albers projection object.
     * The parameters this projection expects are listed below.ParameterDescriptionlatitude_of_originThe latitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.central_meridianThe longitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.standard_parallel_1For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is nearest the pole.  Scale is true along this parallel.standard_parallel_2For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is furthest from the pole.  Scale is true along this parallel.false_eastingThe easting value assigned to the false origin.false_northingThe northing value assigned to the false origin.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Indicates whether the projection forward (meters to degrees or degrees to meters).
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: LambertConformalConic2SP?) {
		super.init(parameters, inverse)
		setName(value: "Lambert_Conformal_Conic_2SP")
		setAuthority(value: "EPSG")
		setAuthorityCode(value: 9802)
		// Check for missing parameters
		let lat1: Double = LambertConformalConic2SP.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "standard_parallel_1"))
		let lat2: Double = LambertConformalConic2SP.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "standard_parallel_2"))
		var sin_po: Double
		/* sin value                            */var cos_po: Double
		/* cos value                            */var con: Double
		/* temporary variable                   */var ms1: Double
		/* small m 1                            */var ms2: Double
		/* small m 2                            */var ts0: Double
		/* small t 0                            */var ts1: Double
		/* small t 1                            */var ts2: Double
		/* small t 2                            *//* Standard Parallels cannot be equal and on opposite sides of the equator
                    ------------------------------------------------------------------------*/
		if abs(lat1 + lat2) < LambertConformalConic2SP.EPSLN {
			//  throwException() /* throw IllegalArgumentException("Equal latitudes for St. Parallels on opposite sides of equator."); */
		}
		// Debug.Assert(true,"LambertConformalConic:LambertConformalConic() - Equal Latitiudes for St. Parallels on opposite sides of equator");
		sin_po = sin(lat1)
		cos_po = cos(lat1)
		con = sin_po
		ms1 = LambertConformalConic2SP.msfnz(eccent: _e, sin_po, cos_po)
		ts1 = LambertConformalConic2SP.tsfnz(eccent: _e, lat1, sin_po)
		sin_po = sin(lat2)
		cos_po = cos(lat2)
		ms2 = LambertConformalConic2SP.msfnz(eccent: _e, sin_po, cos_po)
		ts2 = LambertConformalConic2SP.tsfnz(eccent: _e, lat2, sin_po)
		sin_po = sin(lat_origin)
		ts0 = LambertConformalConic2SP.tsfnz(eccent: _e, lat_origin, sin_po)
		if abs(lat1 - lat2) > LambertConformalConic2SP.EPSLN {
			ns = log(ms1 / ms2) / log(ts1 / ts2)
		} else {
			ns = con
		}
		f0 = ms1 / (ns * pow(ts1, ns))
		rh = _semiMajor * f0 * pow(ts0, ns)
	}
	/* *
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		var dLongitude: Double = lonlat[0]
		var dLatitude: Double = lonlat[1]
		var con: Double
		/* temporary angle variable             */var rh1: Double
		/* height above ellipsoid               */var sinphi: Double
		/* sin value                            */var theta: Double
		/* angle                                */var ts: Double
		/* small value t                        */con = abs(abs(dLatitude) - LambertConformalConic2SP.HALF_PI)
		if con > LambertConformalConic2SP.EPSLN {
			sinphi = sin(dLatitude)
			ts = LambertConformalConic2SP.tsfnz(eccent: _e, dLatitude, sinphi)
			rh1 = _semiMajor * f0 * pow(ts, ns)
		} else {
			con = dLatitude * ns
			if con <= 0 {
				//   throwException() /* throw IllegalArgumentException(); */
				return []
			}
			rh1 = 0
		}
		theta = ns * LambertConformalConic2SP.adjust_lon(a: dLongitude - central_meridian)
		dLongitude = rh1 * sin(theta)
		dLatitude = rh - rh1 * cos(theta)
		if lonlat.count == 2 { return [dLongitude, dLatitude] }
		return [dLongitude, dLatitude, lonlat[2]]
	}
	/* *
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param p Point in meters
     * @return Transformed point in decimal degrees
     */
	internal override func metersToRadians(p: [Double]) -> [Double] {
		var dLongitude: Double = Double.nan
		var dLatitude: Double = Double.nan
		var rh1: Double
		/* height above ellipsoid	*/var con: Double
		/* sign variable		*/var ts: Double
		/* small t			*/var theta: Double
		/* angle			*/let dX: Double = p[0]
		let dY: Double = rh - p[1]
		if ns > 0 {
			rh1 = sqrt(dX * dX + dY * dY)
			con = 1.0
		} else {
			rh1 = -sqrt(dX * dX + dY * dY)
			con = -1.0
		}
		theta = 0.0
		if rh1 != 0 { theta = atan2((con * dX), (con * dY)) }
		if (rh1 != 0) || (ns > 0.0) {
			con = 1.0 / ns
			ts = pow((rh1 / (_semiMajor * f0)), con)
			dLatitude = LambertConformalConic2SP.phi2z(eccent: _e, ts)
		} else {
			dLatitude = -LambertConformalConic2SP.HALF_PI
		}
		dLongitude = LambertConformalConic2SP.adjust_lon(a: theta / ns + central_meridian)
		if p.count == 2 { return [dLongitude, dLatitude] }
		return [dLongitude, dLatitude, p[2]]
	}
	/* *
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = LambertConformalConic2SP(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = LambertConformalConic2SP(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
}
