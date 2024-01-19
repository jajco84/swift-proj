import Foundation
/// Implemetns the Oblique Stereographic Projection.
public class ObliqueStereographicProjection: MapProjection {
	private static var ITERATION_TOLERANCE: Double = 1E-14
	private static var MAXIMUM_ITERATIONS: Int = 15
	private static var EPSILON: Double = 1E-6
	private var globalScale: Double = 0
	private var C: Double = 0, K: Double = 0, ratexp: Double = 0
	private var phic0: Double = 0, cosc0: Double = 0, sinc0: Double = 0, R2: Double = 0
	
	/* *
     * Initializes the ObliqueStereographicProjection object with the specified parameters.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Inverse projectionThe parameters this projection expects are listed below.ItemsDescriptionscentral_meridianThe longitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the longitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).latitude_of_originThe latitude of the point from which the values of both the geographical coordinates on the ellipsoid and the grid coordinates on the projection are deemed to increment or decrement for computational purposes. Alternatively it may be considered as the latitude of the point which in the absence of application of false coordinates has grid coordinates of (0,0).scale_factorThe factor by which the map grid is reduced or enlarged during the projection process, defined by its value at the natural origin.false_eastingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Easting, FE, is the easting value assigned to the abscissa (east).false_northingsince the natural origin may be at or near the centre of the projection and under normal coordinate circumstances would thus give rise to negative coordinates over parts of the mapped area, this origin is usually given false coordinates which are large enough to avoid this inconvenience. The False Northing, FN, is the northing value assigned to the ordinate.
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter], _ inverse: ObliqueStereographicProjection?) {
		super.init(parameters, inverse)

		globalScale = scale_factor * _semiMajor
		let sphi: Double = sin(lat_origin)
		var cphi: Double = cos(lat_origin)
		cphi *= cphi
		R2 = 2.0 * sqrt(1 - _es) / (1 - _es * sphi * sphi)
		C = sqrt(1.0 + _es * cphi * cphi / (1.0 - _es))
		phic0 = asin(sphi / C)
		sinc0 = sin(phic0)
		cosc0 = cos(phic0)
		ratexp = 0.5 * C * _e
		K = tan(0.5 * phic0 + ObliqueStereographicProjection.PI / 4) / (pow(tan(0.5 * lat_origin + ObliqueStereographicProjection.PI / 4), C) * srat(esinp: _e * sphi, ratexp))
	}
	/* *
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param p Point in meters
     * @return Transformed point in decimal degrees
     */
	internal override func metersToRadians(p: [Double]) -> [Double] {
		var x: Double = p[0] / self.globalScale
		var y: Double = p[1] / self.globalScale
		let rho: Double = sqrt((x * x) + (y * y))
		if abs(rho) < ObliqueStereographicProjection.EPSILON {
			x = 0.0
			y = phic0
		} else {
			let ce: Double = 2.0 * atan2(rho, R2)
			let sinc: Double = sin(ce)
			let cosc: Double = cos(ce)
			x = atan2(x * sinc, rho * cosc0 * cosc - y * sinc0 * sinc)
			y = (cosc * sinc0) + (y * sinc * cosc0 / rho)
			if abs(y) >= 1.0 {
				y = (y < 0.0) ? -ObliqueStereographicProjection.PI / 2.0 : ObliqueStereographicProjection.PI / 2.0
			} else {
				y = asin(y)
			}
		}
		x /= C
		let num: Double = pow(tan(0.5 * y + ObliqueStereographicProjection.PI / 4.0) / K, 1.0 / C)
		for _ in 0...ObliqueStereographicProjection.MAXIMUM_ITERATIONS {
			let phi: Double = 2.0 * atan(num * srat(esinp: _e * sin(y), -0.5 * _e)) - ObliqueStereographicProjection.PI / 2.0
			if abs(phi - y) < ObliqueStereographicProjection.ITERATION_TOLERANCE { break }
			y = phi  // if (--i < 0) {
			//   return []
			//  throwException() /* throw Exception("Oblique Stereographics doesn't converge"); *///
			// }
		}
		x += central_meridian
		if p.count == 2 { return [x, y] }
		return [x, y, p[2]]
	}
	/* *
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		var x: Double = lonlat[0] - self.central_meridian
		var y: Double = lonlat[1]
		y = 2.0 * atan(K * pow(tan(0.5 * y + ObliqueStereographicProjection.PI / 4), C) * srat(esinp: _e * sin(y), ratexp)) - ObliqueStereographicProjection.PI / 2
		x *= C
		let sinc: Double = sin(y)
		let cosc: Double = cos(y)
		let cosl: Double = cos(x)
		let k: Double = R2 / (1.0 + sinc0 * sinc + cosc0 * cosc * cosl)
		x = k * cosc * sin(x)
		y = k * (cosc0 * sinc - sinc0 * cosc * cosl)
		if lonlat.count == 2 { return [x * self.globalScale, y * self.globalScale] }
		return [x * self.globalScale, y * self.globalScale, lonlat[2]]
	}
	/* *
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = ObliqueStereographicProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = ObliqueStereographicProjection(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
	private func srat(esinp: Double, _ exp: Double) -> Double { return pow((1.0 - esinp) / (1.0 + esinp), exp) }
}
