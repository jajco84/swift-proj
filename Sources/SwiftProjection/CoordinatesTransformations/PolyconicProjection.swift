import Foundation

/// The type Polyconic projection.
public class PolyconicProjection: MapProjection {
	/* *
     * Maximum difference allowed when comparing real numbers.
     */
	private static var Epsilon: Double = 1E-10
	/* *
     * Maximum number of iterations for iterative computations.
     */
	private static var MaximumIterations: Int = 20
	/* *
     * Difference allowed in iterative computations.
     */
	private static var IterationTolerance: Double = 1E-12
	/* *
     * Meridian distance at the latitude of origin.
     * Used for calculations for the ellipsoid.
     */
	private final var _ml0: Double = 0

	/* *
     * Constructs a new map projection from the supplied parameters.
     *
     * @param parameters The parameter values in standard units
     * @param inverse    Defines if Projection is inverse
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: PolyconicProjection?) {
		super.init(parameters, inverse)
		_ml0 = mlfn(phi: lat_origin, sin(lat_origin), cos(lat_origin))
    }
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		let lam: Double = lonlat[0]
		let phi: Double = lonlat[1]
		var delta_lam: Double = PolyconicProjection.adjust_lon(a: lam - central_meridian)
		var x: Double
		var y: Double
		if abs(phi) <= PolyconicProjection.Epsilon {
			x = delta_lam
			// lam;
			y = -_ml0
		} else {
			let sp: Double = sin(phi)
			let cp: Double = cos(phi)
			let ms: Double = (abs(cp) > PolyconicProjection.Epsilon) ? msfn(s: sp, cp) / sp : 0.0
			/*lam =*/delta_lam *= sp
			/*lam*/x = ms * sin(delta_lam)
			/*lam*/y = (mlfn(phi: phi, sp, cp) - _ml0) + ms * (1.0 - cos(delta_lam))
		}
		x = scale_factor * _semiMajor * x
		// + false_easting;
		y = scale_factor * _semiMajor * y
		return [x, y]
	}
	// +false_northing;
	internal override func metersToRadians(p: [Double]) -> [Double] {
		let x: Double = (p[0]) / (_semiMajor * scale_factor)
		var y: Double = (p[1]) / (_semiMajor * scale_factor)
		var lam: Double
		var phi: Double
		y += _ml0
		if abs(y) <= PolyconicProjection.Epsilon {
			lam = x
			phi = 0.0
		} else {
			let r: Double = y * y + x * x
			phi = y
			for i in 0...PolyconicProjection.MaximumIterations {
				let sp: Double = sin(phi)
				let cp: Double = cos(phi)
				if abs(cp) < PolyconicProjection.IterationTolerance {
					// throwException() /* throw Exception("No Convergence"); */
					return []
				}
				let s2ph: Double = sp * cp
				var mlp: Double = sqrt(1.0 - _es * sp * sp)
				let c: Double = sp * mlp / cp
				let ml: Double = mlfn(phi: phi, sp, cp)
				let mlb: Double = ml * ml + r
				mlp = (1.0 - _es) / (mlp * mlp * mlp)
				let dPhi: Double = (ml + ml + c * mlb - 2.0 * y * (c * ml + 1.0)) / (_es * s2ph * (mlb - 2.0 * y * ml) / c + 2.0 * (y - ml) * (c * mlp - 1.0 / s2ph) - mlp - mlp)
				if abs(dPhi) <= PolyconicProjection.IterationTolerance { break }
				phi += dPhi
				if i == PolyconicProjection.MaximumIterations { return [] }
			}
			let c2: Double = sin(phi)
			lam = asin(x * tan(phi) * sqrt(1.0 - _es * c2 * c2)) / sin(phi)
		}
		return [PolyconicProjection.adjust_lon(a: lam + central_meridian), phi]
	}
	/**
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = PolyconicProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = PolyconicProjection(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
	/**
     * Computes function
     * {@code f(s,c,e²) = c/sqrt(1 - s²*e²)}
     * needed for the true scale
     * latitude (Snyder 14-15), where s and c are the sine and cosine of
     * the true scale latitude, and e² is the eccentricity squared.
     *
     * @param s the s
     * @param c the c
     * @return the Double
     * @throws Exception the exception
     */
	func msfn(s: Double, _ c: Double) -> Double { return c / sqrt(1.0 - (s * s) * _es) }
}
