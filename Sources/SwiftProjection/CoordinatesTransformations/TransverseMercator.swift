import Foundation
/// Summary description for MathTransform.
/// Universal (UTM) and Modified (MTM) Transverses Mercator projections. This
/// is a cylindrical projection, in which the cylinder has been rotated 90°.
/// Instead of being tangent to the equator (or to an other standard latitude),
/// it is tangent to a central meridian. Deformation are more important as we
/// are going futher from the central meridian. The Transverse Mercator
/// projection is appropriate for region wich have a greater extent north-south
/// than east-west.Reference: John P. Snyder (Map Projections - A Working Manual,
/// U.S. Geological Survey Professional Paper 1395, 1987)
public class TransverseMercator: MapProjection {
	/**
     * Maximum number of iterations for iterative computations.
     */
	private static var MAXIMUM_ITERATIONS: Int = 15
	/**
     * Relative iteration precision used in the {@code mlfn} method.
     * This overrides the value in the {@link MapProjection} class.
     */
	private static var ITERATION_TOLERANCE: Double = 1E-11
	/**
     * Maximum difference allowed when comparing real numbers.
     */
	private static var EPSILON: Double = 1E-6
	/**
     * Maximum difference allowed when comparing latitudes.
     */
	private static var EPSILON_LATITUDE: Double = 1E-10
	/**
     * Contants used for the forward and inverse transform for the eliptical
     * case of the Transverse Mercator.
     */
	private static var FC1: Double = 1.00000000000000000000000, FC2: Double = 0.50000000000000000000000, FC3: Double = 0.16666666666666666666666, FC4: Double = 0.08333333333333333333333, FC5: Double = 0.05000000000000000000000, FC6: Double = 0.03333333333333333333333, FC7: Double = 0.02380952380952380952380, FC8: Double = 0.01785714285714285714285
	/**
     * A derived quantity of excentricity, computed by <code>e'Â² = (aÂ²-bÂ²)/bÂ² = es/(1-es)</code>
     * where <var>a</var> is the semi-major axis length and <var>b</bar> is the semi-minor axis
     * length.
     */
	private var _esp: Double = 0
	/**
     * Meridian distance at the {@code latitudeOfOrigin}.
     * Used for calculations for the ellipsoid.
     */
	private var _ml0: Double = 0
	// 1/1
	// 1/2
	// 1/6
	// 1/12
	// 1/20
	// 1/30
	// 1/42
	// 1/56
	/* *
     * * Variables common to all subroutines in this code file
     */
	//   -----------------------------------------------------*/
	/**
     * Creates an instance of an TransverseMercatorProjection projection object.
     *
     * @param parameters List of parameters to initialize the projection.
     * @param inverse    Flag indicating wether is a forward/projection (false) or an inverse projection (true).ItemsDescriptionssemi_majorSemi major radiussemi_minorSemi minor radiusscale_factorcentral meridianlatitude_originfalse_eastingfalse_northing
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: TransverseMercator?) {
		super.init(parameters, inverse)
		_esp = _es / (1.0 - _es)
		_ml0 = mlfn(phi: lat_origin, sin(lat_origin), cos(lat_origin))

		setName(value: "Transverse_Mercator")
		setAuthority(value: "EPSG")
		setAuthorityCode(value: 9807)
	}
	/*
                e = sqrt(_es);
    		    ml0 = _semiMajor*mlfn(lat_origin, sin(lat_origin), cos(lat_origin));
    			esp = _es / (1.0 - _es);
                 */
	/**
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		var x: Double = lonlat[0]
		x = TransverseMercator.adjust_lon(a: x - central_meridian)
		var y: Double = lonlat[1]
		let sinphi: Double = sin(y)
		let cosphi: Double = cos(y)
		var t: Double = (abs(cosphi) > TransverseMercator.EPSILON) ? sinphi / cosphi : 0
		t *= t
		var al: Double = cosphi * x
		let als: Double = al * al
		al /= sqrt(1.0 - _es * sinphi * sinphi)
		let n: Double = _esp * cosphi * cosphi
		/* NOTE: meridinal distance at latitudeOfOrigin is always 0 */
		let aa = (5.0 - t + n * (9.0 + 4.0 * n) + TransverseMercator.FC6 * als * (61.0 + t * (t - 58.0) + n * (270.0 - 330.0 * t) + TransverseMercator.FC8 * als * (1385.0 + t * (t * (543.0 - t) - 3111.0))))
		y = (mlfn(phi: y, sinphi, cosphi) - _ml0 + sinphi * al * x * TransverseMercator.FC2 * (1.0 + TransverseMercator.FC4 * als * aa))
		let bb = (5.0 + t * (t - 18.0) + n * (14.0 - 58.0 * t) + TransverseMercator.FC7 * als * (61.0 + t * (t * (179.0 - t) - 479.0)))
		x = al * (TransverseMercator.FC1 + TransverseMercator.FC3 * als * (1.0 - t + n + TransverseMercator.FC5 * als * bb))
		x = scale_factor * _semiMajor * x
		y = scale_factor * _semiMajor * y
		if lonlat.count == 2 { return [x, y] }
		return [x, y, lonlat[2]]
	}
	// Double lon = Degrees2Radians(lonlat[0]);
	// Double lat = Degrees2Radians(lonlat[1]);
	// Double delta_lon=0.0;	/* Delta longitude (Given longitude - center 	*/
	// Double sin_phi, cos_phi;/* sin and cos value				*/
	// Double al, als;		/* temporary values				*/
	// Double c, t, tq;	/* temporary values				*/
	// Double con, n, ml;	/* cone constant, small m			*/
	// delta_lon = adjust_lon(lon - central_meridian);
	// sincos(lat, out sin_phi, out cos_phi);
	// al  = cos_phi * delta_lon;
	// als = pow(al,2);
	// c = esp * pow(cos_phi,2);
	// tq  = tan(lat);
	// t = pow(tq,2);
	// con = 1.0 - _es * pow(sin_phi,2);
	// n = this._semiMajor / sqrt(con);
	/* *
     * /var mlold = this._semiMajor * mlfn(e0, e1, e2, e3, lat);
     */
	// ml = this._semiMajor * mlfn(lat, sin_phi, cos_phi);
	/* *
     * /var d = ml - mlold;
     */
	// Double x =
	//    scale_factor * n * al * (1.0 + als / 6.0 * (1.0 - t + c + als / 20.0 *
	//    (5.0 - 18.0 * t + pow(t, 2) + 72.0 * c - 58.0 * esp))) + false_easting;
	// Double y = scale_factor * (ml - ml0 + n * tq * (als * (0.5 + als / 24.0 *
	//    (5.0 - t + 9.0 * c + 4.0 * pow(c,2) + als / 30.0 * (61.0 - 58.0 * t
	//    + pow(t,2) + 600.0 * c - 330.0 * esp))))) + false_northing;
	// if(lonlat.Length<3)
	//    return new Double[] { x / _metersPerUnit, y / _metersPerUnit };
	// else
	//    return new Double[] { x / _metersPerUnit, y / _metersPerUnit, lonlat[2] };
	/**
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param p Point in meters
     * @return Transformed point in decimal degrees
     */
	internal override func metersToRadians(p: [Double]) -> [Double] {
		/*scale_factor* */var x: Double = p[0] / (_semiMajor)
		/*scale_factor* */var y: Double = p[1] / (_semiMajor)
		let phi: Double = inv_mlfn(arg: _ml0 + y / scale_factor)
		if abs(phi) >= TransverseMercator.PI / 2 {
			y = y < 0.0 ? -(TransverseMercator.PI / 2) : (TransverseMercator.PI / 2)
			x = 0.0
		} else {
			let sinphi: Double = sin(phi)
			let cosphi: Double = cos(phi)
			var t: Double = (abs(cosphi) > TransverseMercator.EPSILON) ? sinphi / cosphi : 0.0
			let n: Double = _esp * cosphi * cosphi
			var con: Double = 1.0 - _es * sinphi * sinphi
			let d: Double = x * sqrt(con) / scale_factor
			con *= t
			t *= t
			let ds: Double = d * d
			y = phi - (con * ds / (1.0 - _es)) * TransverseMercator.FC2 * (1.0 - ds * TransverseMercator.FC4 * (5.0 + t * (3.0 - 9.0 * n) + n * (1.0 - 4 * n) - ds * TransverseMercator.FC6 * (61.0 + t * (90.0 - 252.0 * n + 45.0 * t) + 46.0 * n - ds * TransverseMercator.FC8 * (1385.0 + t * (3633.0 + t * (4095.0 + 1574.0 * t))))))
			let xxx = (5.0 + t * (28.0 + 24 * t + 8.0 * n) + 6.0 * n - ds * TransverseMercator.FC7 * (61.0 + t * (662.0 + t * (1320.0 + 720.0 * t))))
			let xx = (TransverseMercator.FC1 - ds * TransverseMercator.FC3 * (1.0 + 2.0 * t + n - ds * TransverseMercator.FC5 * xxx))
			x = TransverseMercator.adjust_lon(a: central_meridian + d * xx / cosphi)
		}
		if p.count == 2 { return [x, y] }
		return [x, y, p[2]]
	}
	// Double con,phi;		/* temporary angles				*/
	// Double delta_phi;	/* difference between longitudes		*/
	// long i;			/* counter variable				*/
	// Double sin_phi, cos_phi, tan_phi;	/* sin cos and tangent values	*/
	// Double c, cs, t, ts, n, r, d, ds;	/* temporary variables		*/
	// long max_iter = 6;			/* maximun number of iterations	*/
	// Double x = p[0] * _metersPerUnit - false_easting;
	// Double y = p[1] * _metersPerUnit - false_northing;
	// con = (ml0 + y / scale_factor) / this._semiMajor;
	// phi = con;
	// for (i=0;;i++)
	// {
	//    delta_phi = ((con + en1 * sin(2.0*phi) - en2 * sin(4.0*phi) + en3 * sin(6.0*phi) /*+ en4 * sin(8.0*phi)*/)
	//        / en0) - phi;
	//    phi += delta_phi;
	//    if (abs(delta_phi) <= EPSLN) break;
	//    if (i >= max_iter)
	//        throw new IllegalArgumentException("Latitude failed to converge");
	// }
	// if (abs(phi) < HALF_PI)
	// {
	//    sincos(phi, out sin_phi, out cos_phi);
	//    tan_phi = tan(phi);
	//    c = esp * pow(cos_phi, 2);
	//    cs = pow(c, 2);
	//    t = pow(tan_phi, 2);
	//    ts = pow(t, 2);
	//    con = 1.0 - _es * pow(sin_phi, 2);
	//    n = this._semiMajor / sqrt(con);
	//    r = n * (1.0 - _es) / con;
	//    d = x / (n * scale_factor);
	//    ds = pow(d, 2);
	//    Double lat = phi - (n * tan_phi * ds / r) * (0.5 - ds / 24.0 * (5.0 + 3.0 * t +
	//        10.0 * c - 4.0 * cs - 9.0 * esp - ds / 30.0 * (61.0 + 90.0 * t +
	//        298.0 * c + 45.0 * ts - 252.0 * esp - 3.0 * cs)));
	//    Double lon = adjust_lon(central_meridian + (d * (1.0 - ds / 6.0 * (1.0 + 2.0 * t +
	//        c - ds / 20.0 * (5.0 - 2.0 * c + 28.0 * t - 3.0 * cs + 8.0 * esp +
	//        24.0 * ts))) / cos_phi));
	//    if (p.Length < 3)
	//        return new Double[] { Radians2Degrees(lon), Radians2Degrees(lat) };
	//    else
	//        return new Double[] { Radians2Degrees(lon), Radians2Degrees(lat), p[2] };
	// }
	// else
	// {
	//    if (p.Length < 3)
	//        return new Double[] { Radians2Degrees(HALF_PI * sign(y)), Radians2Degrees(central_meridian) };
	//    else
	//        return new Double[] { Radians2Degrees(HALF_PI * sign(y)), Radians2Degrees(central_meridian), p[2] };
	// }
	/**
     * Returns the inverse of this projection.
     *
     * @return IMathTransform that is the reverse of the current projection.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = TransverseMercator(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse
//		if _inverse == nil { _inverse = TransverseMercator(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
}
