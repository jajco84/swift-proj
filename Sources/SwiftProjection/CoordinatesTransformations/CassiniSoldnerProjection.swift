import Foundation
/// The type Cassini soldner projection.
public class CassiniSoldnerProjection: MapProjection {
    // ReSharper disable InconsistentNaming
    private static var One6th: Double = 0.16666666666666666666
    // C1
    private static var One120th: Double = 0.00833333333333333333
    // C2
    private static var One24th: Double = 0.04166666666666666666
    // C3
    private static var One3rd: Double = 0.33333333333333333333
    // C4
    private static var One15th: Double = 0.06666666666666666666
    // C5
    // ReSharper restore InconsistentNaming
    private final var _cFactor: Double = 0
    private final var _m0: Double = 0
    private final var _reciprocalSemiMajor: Double = 0
    private final var maxIter: Int = 10
    private final var eps: Double = 1e-11
    
    /**
     * Instantiates a new Cassini soldner projection.
     *
     * @param parameters the parameters
     * @param inverse    the inverse
     * @throws Exception the exception
     */
    public init(_ parameters: [ProjectionParameter], _ inverse: CassiniSoldnerProjection?) {
        super.init(parameters, inverse)
        setAuthority(value: "EPSG")
        setAuthorityCode(value: 9806)
        setName(value: "Cassini_Soldner")
        _cFactor = _es / (1 - _es)
        _m0 = mlfn(phi: lat_origin, sin(lat_origin), cos(lat_origin))
        _reciprocalSemiMajor = 1 / _semiMajor
    }
    public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = CassiniSoldnerProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//        if _inverse == nil { _inverse = CassiniSoldnerProjection(_Parameters.toProjectionParameter(), self) }
//        return _inverse!
    }
    internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
        let lambda: Double = lonlat[0] - central_meridian
        let phi: Double = lonlat[1]
        var sinPhi: Double
        var cosPhi: Double
        // sin and cos value
        sinPhi = sin(phi)
        cosPhi = cos(phi)
        var y: Double = mlfn(phi: phi, sinPhi, cosPhi)
        let n: Double = 1 / sqrt(1 - _es * sinPhi * sinPhi)
        let tn: Double = tan(phi)
        let t: Double = tn * tn
        let a1: Double = lambda * cosPhi
        let a2: Double = a1 * a1
        let c: Double = _cFactor * pow(cosPhi, 2)
        let x: Double = n * a1 * (1 - a2 * t * (CassiniSoldnerProjection.One6th - (8 - t + 8 * c) * a2 * CassiniSoldnerProjection.One120th))
        y -= _m0 - n * tn * a2 * (0.5 + (5.0 - t + 6.0 * c) * a2 * CassiniSoldnerProjection.One24th)
        if lonlat.count == 2 {
            return [_semiMajor * x, _semiMajor * y]
        } else {
            return [_semiMajor * x, _semiMajor * y, lonlat[2]]
        }
    }
    internal override func metersToRadians(p: [Double]) -> [Double] {
        let x: Double = p[0] * _reciprocalSemiMajor
        let y: Double = p[1] * _reciprocalSemiMajor
        let phi1: Double = phi1f(arg: _m0 + y)
        let tn: Double = tan(phi1)
        let t: Double = tn * tn
        var n: Double = sin(phi1)
        var r: Double = 1.0 / (1.0 - _es * n * n)
        n = sqrt(r)
        r *= (1.0 - _es) * n
        let dd: Double = x / n
        let d2: Double = dd * dd
        let phi: Double = phi1 - (n * tn / r) * d2 * (0.5 - (1.0 + 3.0 * t) * d2 * CassiniSoldnerProjection.One24th)
        var lambda: Double = dd * (1.0 + t * d2 * (-CassiniSoldnerProjection.One3rd + (1.0 + 3.0 * t) * d2 * CassiniSoldnerProjection.One15th)) / cos(phi1)
        lambda = CassiniSoldnerProjection.adjust_lon(a: lambda + central_meridian)
        if p.count == 2 { return [lambda, phi] }
        return [lambda, phi, p[2]]
    }
    private func phi1f(arg: Double) -> Double {
        let k: Double = 1.0 / (1.0 - _es)
        var phi: Double = arg
        for _ in 0...maxIter {  // var i : Int = maxIter; i > 0; --i {
            // rarely goes over 2 iterations
            let sinPhi: Double = sin(phi)
            var t: Double = 1.0 - _es * sinPhi * sinPhi
            t = (mlfn(phi: phi, sinPhi, cos(phi)) - arg) * (t * sqrt(t)) * k
            phi -= t
            if abs(t) < eps { return phi }
        }
        return Double.nan  // throwException() /* throw IllegalArgumentException("Convergence error."); */
    }
}
