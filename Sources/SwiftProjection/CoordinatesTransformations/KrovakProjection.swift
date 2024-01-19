import Foundation
/// Implemetns the Krovak Projection.
/// The normal case of the Lambert Conformal conic is for the axis of the cone
/// to be coincident with the minor axis of the ellipsoid, that is the axis of the cone
/// is normal to the ellipsoid at a pole. For the Oblique Conformal Conic the axis
/// of the cone is normal to the ellipsoid at a defined location and its extension
/// cuts the minor axis at a defined angle. This projection is used in the Czech Republic
/// and Slovakia under the name "Krovak" projection.
public class KrovakProjection: MapProjection {
	/* *
     * Maximum number of iterations for iterative computations.
     */
	private static var MaximumIterations: Int = 15
	/* *
     * When to stop the iteration.
     */
	private static var IterationTolerance: Double = 1E-11
	/* *
     * Useful constant - 45° in radians.
     */
	private static var S45: Double = 0.785398163397448
	/* *
     * Azimuth of the centre line passing through the centre of the projection.
     * This is equals to the co-latitude of the cone axis at point of intersection
     * with the ellipsoid.
     */
	private var _azimuth: Double = 0
	/* *
     * Latitude of pseudo standard parallel.
     */
	private var _pseudoStandardParallel: Double = 0
	/* *
     * Useful variables calculated from parameters defined by user.
     */
	private var _sinAzim: Double = 0, _cosAzim: Double = 0, _n: Double = 0, _tanS2: Double = 0, _alfa: Double = 0, _hae: Double = 0, _k1: Double = 0, _ka: Double = 0, _ro0: Double = 0, _rop: Double = 0
	
	/* *
     * Creates an instance of an Albers projection object.
     * The parameters this projection expects are listed below.ParameterDescriptionlatitude_of_originThe latitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.central_meridianThe longitude of the point which is not the natural origin and at which grid coordinate values false easting and false northing are defined.standard_parallel_1For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is nearest the pole.  Scale is true along this parallel.standard_parallel_2For a conic projection with two standard parallels, this is the latitude of intersection of the cone with the ellipsoid that is furthest from the pole.  Scale is true along this parallel.false_eastingThe easting value assigned to the false origin.false_northingThe northing value assigned to the false origin.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Indicates whether the projection forward (meters to degrees or degrees to meters).
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: KrovakProjection?) {
		super.init(parameters, inverse)
		setName(value: "Krovak")
		setAuthority(value: "EPSG")
		setAuthorityCode(value: 9819)
		// PROJCS["S-JTSK (Ferro) / Krovak",
		// GEOGCS["S-JTSK (Ferro)",
		//    DATUM["D_S_JTSK_Ferro",
		//        SPHEROID["Bessel 1841",6377397.155,299.1528128]],
		//    PRIMEM["Ferro",-17.66666666666667],
		//    UNIT["degree",0.0174532925199433]],
		// PROJECTION["Krovak"],
		// PARAMETER["latitude_of_center",49.5],
		// PARAMETER["longitude_of_center",42.5],
		// PARAMETER["azimuth",30.28813972222222],
		// PARAMETER["pseudo_standard_parallel_1",78.5],
		// PARAMETER["scale_factor",0.9999],
		// PARAMETER["false_easting",0],
		// PARAMETER["false_northing",0],
		// UNIT["metre",1]]
		// Check for missing parameters
		_azimuth = KrovakProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "azimuth"))
		_pseudoStandardParallel = KrovakProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "pseudo_standard_parallel_1"))
		// Calculates useful constants.
		_sinAzim = sin(_azimuth)
		_cosAzim = cos(_azimuth)
		_n = sin(_pseudoStandardParallel)
		_tanS2 = tan(_pseudoStandardParallel / 2 + KrovakProjection.S45)
		let sinLat: Double = sin(lat_origin)
		let cosLat: Double = cos(lat_origin)
		let cosL2: Double = cosLat * cosLat
		_alfa = sqrt(1 + ((_es * (cosL2 * cosL2)) / (1 - _es)))
		// parameter B
		_hae = _alfa * _e / 2
		let u0: Double = asin(sinLat / _alfa)
		let esl: Double = _e * sinLat
		let g: Double = pow((1 - esl) / (1 + esl), (_alfa * _e) / 2)
		_k1 = pow(tan(lat_origin / 2 + KrovakProjection.S45), _alfa) * g / tan(u0 / 2 + KrovakProjection.S45)
		_ka = pow(1 / _k1, -1 / _alfa)
		let radius: Double = sqrt(1 - _es) / (1 - (_es * (sinLat * sinLat)))
		_ro0 = scale_factor * radius / tan(_pseudoStandardParallel)
		_rop = _ro0 * pow(_tanS2, _n)
	}
	/* *
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		let lambda: Double = lonlat[0] - central_meridian
		let phi: Double = lonlat[1]
		let esp: Double = _e * sin(phi)
		let gfi: Double = pow(((1.0 - esp) / (1.0 + esp)), _hae)
		let u: Double = 2 * (atan(pow(tan(phi / 2 + KrovakProjection.S45), _alfa) / _k1 * gfi) - KrovakProjection.S45)
		let deltav: Double = -lambda * _alfa
		let cosU: Double = cos(u)
		let s: Double = asin((_cosAzim * sin(u)) + (_sinAzim * cosU * cos(deltav)))
		let d: Double = asin(cosU * sin(deltav) / cos(s))
		let eps: Double = _n * d
		let ro: Double = _rop / pow(tan(s / 2 + KrovakProjection.S45), _n)
		/* x and y are reverted  */let y: Double = -(ro * cos(eps)) * _semiMajor
		let x: Double = -(ro * sin(eps)) * _semiMajor
		return [x, y]
	}
	/* *
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param p Point in meters
     * @return Transformed point in decimal degrees
     */
	internal override func metersToRadians(p: [Double]) -> [Double] {
		let x: Double = p[0] / _semiMajor
		let y: Double = p[1] / _semiMajor
		// x -> southing, y -> westing
		let ro: Double = sqrt(x * x + y * y)
		let eps: Double = atan2(-x, -y)
		let d: Double = eps / _n
		let s: Double = 2 * (atan(pow(_ro0 / ro, 1 / _n) * _tanS2) - KrovakProjection.S45)
		let cs: Double = cos(s)
		let u: Double = asin((_cosAzim * sin(s)) - (_sinAzim * cs * cos(d)))
		let kau: Double = _ka * pow(tan((u / 2.0) + KrovakProjection.S45), 1 / _alfa)
		let deltav: Double = asin((cs * sin(d)) / cos(u))
		let lambda: Double = -deltav / _alfa
		var phi: Double = 0
		for _ in 0...KrovakProjection.MaximumIterations {
			// iteration calculation
			let fi1: Double = phi
			let esf: Double = _e * sin(fi1)
			phi = 2.0 * (atan(kau * pow((1.0 + esf) / (1.0 - esf), _e / 2.0)) - KrovakProjection.S45)
			if abs(fi1 - phi) <= KrovakProjection.IterationTolerance { break }
		}
		return [lambda + central_meridian, phi]
	}
	/* *
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = KrovakProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = KrovakProjection(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
}
