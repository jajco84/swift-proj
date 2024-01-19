import Foundation
/// Implements the Mercator projection.
/// This map projection introduced in 1569 by Gerardus Mercator. It is often described as a cylindrical projection,
/// but it must be derived mathematically. The meridians are equally spaced, parallel vertical lines, and the
/// parallels of latitude are parallel, horizontal straight lines, spaced farther and farther apart as their distance
/// from the Equator increases. This projection is widely used for navigation charts, because any straight line
/// on a Mercator-projection map is a line of constant true bearing that enables a navigator to plot a straight-line
/// course. It is less practical for world maps because the scale is distorted; areas farther away from the equator
/// appear disproportionately large. On a Mercator projection, for example, the landmass of Greenland appears to be
/// greater than that of the continent of South America; in actual area, Greenland is smaller than the Arabian Peninsula.
public class Mercator: MapProjection {
	// double lon_center;		//Center longitude (projection center)
	// double lat_origin;		//center latitude
	// double e,e2;			//eccentricity constants
	private var _k0: Double = 0

	/* *
     * Initializes the MercatorProjection object with the specified parameters.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Indicates whether the projection forward (meters to degrees or degrees to meters).The parameters this projection expects are listed below.ItemsDescriptionscentral_meridianThe longitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the longitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).latitude_of_originThe latitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the latitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).scale_factorThe factor by which the map grid is reduced or enlarged during the projection process, defined by its value at the natural origin.false_eastingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Easting, FE, is the easting value assigned to the abscissa (east).false_northingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Northing, FN, is the northing value assigned to the ordinate.
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter], _ inverse: Mercator?) {
		super.init(parameters, inverse)
		setAuthority(value: "EPSG")
		let scale_factor: ProjectionParameter? = getParameter(name: "scale_factor")
		if scale_factor == nil {
			// This is a two standard parallel Mercator projection (2SP)
			_k0 = cos(lat_origin) / sqrt(1.0 - _es * sin(lat_origin) * sin(lat_origin))
			setAuthorityCode(value: 9805)
			setName(value: "Mercator_2SP")
		} else {
			// This is a one standard parallel Mercator projection (1SP)
			_k0 = scale_factor!.getValue()
			setName(value: "Mercator_1SP")
		}
		_inverse = inverse
		if _inverse != nil {
			inverse!._inverse = self
			_isinverse = !inverse!._isinverse
		}
	}
	/* *
     * Converts coordinates in decimal degrees to projected meters.
     * The parameters this projection expects are listed below.ItemsDescriptionslongitude_of_natural_originThe longitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the longitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).  Sometimes known as ""central meridian""."latitude_of_natural_originThe latitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the latitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).scale_factor_at_natural_originThe factor by which the map grid is reduced or enlarged during the projection process, defined by its value at the natural origin.false_eastingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Easting, FE, is the easting value assigned to the abscissa (east).false_northingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Northing, FN, is the northing value assigned to the ordinate .
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		if lonlat[0].isNaN || lonlat[1].isNaN { return [Double.nan, Double.nan] }
		let dLongitude: Double = lonlat[0]
		let dLatitude: Double = lonlat[1]
		/* Forward equations */
		if abs(abs(dLatitude) - Mercator.HALF_PI) <= Mercator.EPSLN {
			// throwException() /* throw IllegalArgumentException("Transformation cannot be computed at the poles."); */
			return [Double.nan, Double.nan]
		}
		let esinphi: Double = _e * sin(dLatitude)
		let x: Double = _semiMajor * _k0 * (dLongitude - central_meridian)
		let y: Double = _semiMajor * _k0 * log(tan(Double.pi * 0.25 + dLatitude * 0.5) * pow((1 - esinphi) / (1 + esinphi), _e * 0.5))
		if lonlat.count == 2 { return [x, y] }
		return [x, y, lonlat[2]]
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
		/* Inverse equations
                      -----------------*/
        let dX: Double = p[0]
		// * _metersPerUnit - this._falseEasting;
		let dY: Double = p[1]
		// * _metersPerUnit - this._falseNorthing;
		let ts: Double = exp(-dY / (self._semiMajor * _k0))
		// t
		let chi: Double = Mercator.HALF_PI - 2 * atan(ts)
		let e4: Double = pow(_e, 4)
		let e6: Double = pow(_e, 6)
		let e8: Double = pow(_e, 8)
		dLatitude = chi + (_es * 0.5 + 5 * e4 / 24 + e6 / 12 + 13 * e8 / 360) * sin(2 * chi) + (7 * e4 / 48 + 29 * e6 / 240 + 811 * e8 / 11520) * sin(4 * chi) + +(7 * e6 / 120 + 81 * e8 / 1120) * sin(6 * chi) + +(4279 * e8 / 161280) * sin(8 * chi)
		dLongitude = dX / (_semiMajor * _k0) + central_meridian
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
            let transform = Mercator(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = Mercator(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
}
