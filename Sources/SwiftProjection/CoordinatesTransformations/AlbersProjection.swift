import Foundation
/// Implements the Albers projection.
/// Implements the Albers projection. The Albers projection is most commonly
/// used to project the United States of America. It gives the northern
/// border with Canada a curved appearance.The Albers Equal Area
/// projection has the property that the area bounded
/// by any pair of parallels and meridians is exactly reproduced between the
/// image of those parallels and meridians in the projected domain, that is,
/// the projection preserves the correct area of the earth though distorts
/// direction, distance and shape somewhat.
public class AlbersProjection: MapProjection {
	private var _c: Double = 0
	private var _ro0: Double = 0
	private var _n: Double = 0

	/**
     * Creates an instance of an Albers projection object.
     * The parameters this projection expects are listed below.ItemsDescriptionslatitude_of_centerThe latitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.longitude_of_centerThe longitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.standard_parallel_1For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is nearest the pole.  Scale is true along this parallel.standard_parallel_2For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is furthest from the pole.  Scale is true along this parallel.false_eastingThe easting value assigned to the false origin.false_northingThe northing value assigned to the false origin.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Indicates whether the projection forward (meters to degrees or degrees to meters).
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: AlbersProjection?) {
		super.init(parameters, inverse)
		setName(value: "Albers_Conic_Equal_Area")
        let lat0: Double = lat_origin
        let lat1: Double = AlbersProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "standard_parallel_1"))
        let lat2: Double = AlbersProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "standard_parallel_2"))
		// if (abs(lat1 + lat2) < 0.000000001)
		//    throwException() /* throw IllegalArgumentException("Equal latitudes for standard parallels on opposite sides of Equator."); */
        let alpha1: Double = alpha(lat: lat1)
        let alpha2: Double = alpha(lat: lat2)
        let m1: Double = cos(lat1) / sqrt(1 - _es * pow(sin(lat1), 2))
        let m2: Double = cos(lat2) / sqrt(1 - _es * pow(sin(lat2), 2))
		_n = (pow(m1, 2) - pow(m2, 2)) / (alpha2 - alpha1)
		_c = pow(m1, 2) + (_n * alpha1)
		_ro0 = rof(a: alpha(lat: lat0))
	}
	/*
                double sin_p0 = Math.sin(lat0);
    			double cos_p0 = Math.cos(lat0);
    			double q0 = qsfnz(e, sin_p0, cos_p0);
    			double sin_p1 = Math.sin(lat1);
    			double cos_p1 = Math.cos(lat1);
    			double m1 = msfnz(e,sin_p1,cos_p1);
    			double q1 = qsfnz(e,sin_p1,cos_p1);
    			double sin_p2 = Math.sin(lat2);
    			double cos_p2 = Math.cos(lat2);
    			double m2 = msfnz(e,sin_p2,cos_p2);
    			double q2 = qsfnz(e,sin_p2,cos_p2);
    			if (Math.abs(lat1 - lat2) > EPSLN)
    				ns0 = (m1 * m1 - m2 * m2)/ (q2 - q1);
    			else
    				ns0 = sin_p1;
    			C = m1 * m1 + ns0 * q1;
    			rh = this._semiMajor * Math.sqrt(C - ns0 * q0)/ns0;
    			*/
	/**
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		var dLongitude: Double = lonlat[0]
		var dLatitude: Double = lonlat[1]
		let a: Double = alpha(lat: dLatitude)
		let ro: Double = rof(a: a)
		let theta: Double = _n * (dLongitude - central_meridian)
		/*_falseEasting +*/dLongitude = ro * sin(theta)
		/*_falseNorthing +*/dLatitude = _ro0 - (ro * cos(theta))
		if lonlat.count == 2 {
			return [dLongitude, dLatitude]
		} else {
			return [dLongitude, dLatitude, lonlat[2]]
		}
	}
	/**
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param p Point in meters
     * @return Transformed point in decimal degrees
     */
	internal override func metersToRadians(p: [Double]) -> [Double] {
		/* _metersPerUnit - _falseEasting*/let theta: Double = atan((p[0]) / (_ro0 - (p[1])))
		/* _metersPerUnit - _falseNorthing*//* _metersPerUnit - _falseEasting*/let ro: Double = sqrt(pow(p[0], 2) + pow(_ro0 - (p[1]), 2))
		/* * _metersPerUnit - _falseNorthing*/let q: Double = (_c - pow(ro, 2) * pow(_n, 2) / pow(self._semiMajor, 2)) / _n
		var _: Double = sin(q / (1 - ((1 - _es) / (2 * _e)) * log((1 - _e) / (1 + _e))))
		var lat: Double = asin(q * 0.5)
		var preLat: Double = Double.greatestFiniteMagnitude
		var iterationCounter: Int = 0
		while abs(lat - preLat) > 0.000001 {
			preLat = lat
			let ssin: Double = sin(lat)
			let e2sin2: Double = _es * pow(ssin, 2)
			let aa = (pow(1 - e2sin2, 2) / (2 * cos(lat)))
			let bb = log((1 - _e * ssin) / (1 + _e * ssin))
			lat += aa * ((q / (1 - _es)) - ssin / (1 - e2sin2) + 1 / (2 * _e) * bb)
			iterationCounter += 1
			if iterationCounter > 25 { return [] }
		}
		let lon: Double = central_meridian + (theta / _n)
		if p.count == 2 {
			return [lon, lat]
		} else {
			return [lon, lat, p[2]]
		}
	}
	/*Radians2Degrees(lon), Radians2Degrees(lat)*//*Radians2Degrees(lon), Radians2Degrees(lat)*/
	/**
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let proj = AlbersProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = proj
            return proj
        }
        return _inverse
//		if _inverse == nil { _inverse = AlbersProjection(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
	// private double ToAuthalic(double lat)
	// {
	//    return Math.atan(Q(lat) / Q(Math.PI * 0.5));
	// }
	// private double Q(double angle)
	// {
	//    double sin = Math.sin(angle);
	//    double esin = e * sin;
	//    return Math.abs(sin / (1 - Math.pow(esin, 2)) - 0.5 * e) * Math.Log((1 - esin) / (1 + esin)));
	// }
	private func alpha(lat: Double) -> Double {
		let ssin: Double = sin(lat)
		let sinsq: Double = pow(ssin, 2)
		return (1 - _es) * (((ssin / (1 - _es * sinsq)) - 1 / (2 * _e) * log((1 - _e * ssin) / (1 + _e * ssin))))
	}
	private func rof(a: Double) -> Double { return _semiMajor * sqrt((_c - _n * a)) / _n }
}
