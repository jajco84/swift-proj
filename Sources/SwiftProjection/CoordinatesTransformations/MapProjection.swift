import Foundation
// Projections inherit from this abstract class to get access to useful mathematical functions.
public class MapProjection: MathTransform, IProjection {
	/* *
     * PI
     */
	internal static var PI: Double = Double.pi
	/* *
     * Half of PI
     */
	internal static var HALF_PI: Double = (PI * 0.5)
	/* *
     * PI * 2
     */
	internal static var TWO_PI: Double = (PI * 2.0)
	/* *
     * EPSLN
     */
	internal static var EPSLN: Double = 1.0e-10
	/* *
     * S2R
     */
	internal static var S2R: Double = 4.848136811095359e-6
	/* *
     * MAX_VAL
     */
	internal static var MAX_VAL: Int = 4
	/* *
     * prjMAXLONG
     */
	internal static var prjMAXLONG: Double = 2_147_483_647
	/* *
     * DBLLONG
     */
	internal static var DBLLONG: Double = 4.61168601e18
	private static var C00: Double = 1.0, C02: Double = 0.25, C04: Double = 0.046875, C06: Double = 0.01953125, C08: Double = 0.01068115234375, C22: Double = 0.75, C44: Double = 0.46875, C46: Double = 0.01302083333333333333, C48: Double = 0.00712076822916666666, C66: Double = 0.36458333333333333333, C68: Double = 0.00569661458333333333, C88: Double = 0.3076171875
	private final var MLFN_TOL: Double = 1E-11
	private final var MAXIMUM_ITERATIONS: Int = 20
	/* *
     * The E.
     */
	// ReSharper disable InconsistentNaming
	internal var _e: Double = 0
	/* *
     * The Es.
     */
	internal var _es: Double = 0
	/* *
     * The Semi major.
     */
	internal var _semiMajor: Double = 0
	/* *
     * The Semi minor.
     */
	internal var _semiMinor: Double = 0
	/* *
     * The Meters per unit.
     */
	internal var _metersPerUnit: Double = 0
	/* *
     * The Scale factor.
     */
	internal var scale_factor: Double = 0
	/* *
     * The Central meridian.
     */
	/* scale factor				*/
    internal var central_meridian: Double = 0
	/* *
     * The Lat origin.
     */
	// ReSharper restore InconsistentNaming
	internal var lat_origin: Double = 0
	/* *
     * The False northing.
     */
	/* center latitude			*/
    internal var false_northing: Double = 0
	/* *
     * The False easting.
     */
	/* y offset in meters			*/
    internal var false_easting: Double = 0
	/* *
     * The En 0.
     */
	/* x offset in meters			*/
    internal var en0: Double = 0,
    /* *
     * The En 1.
     */
		en1: Double = 0,
    /* *
     * The En 2.
     */
		en2: Double = 0,
    /* *
     * The En 3.
     */
		en3: Double = 0,
    /* *
     * The En 4.
     */
		en4: Double = 0
	/* *
     * The Parameters.
     */
	internal var _Parameters: ProjectionParameterSet
	/* *
     * The Inverse.
     */
	internal var _inverse: MathTransform?
	var _isinverse: Bool = false
	/* *
     * Gets or sets the abbreviation of the object.
     */
	private var __Abbreviation: String = String()
	/* *
     * Gets or sets the alias of the object.
     */
	private var __Alias: String = String()
	/* *
     * Gets or sets the authority name for this object, e.g., "EPSG",
     * is this is a standard object with an authority specific
     * identity code. Returns "CUSTOM" if this is a custom object.
     */
	private var __Authority: String = String()
	/* *
     * Gets or sets the authority specific identification code of the object
     */
	private var __AuthorityCode: Int = 0
	/* *
     * Gets or sets the name of the object.
     */
	private var __Name: String = String()
	/* *
     * Gets or sets the provider-supplied remarks for the object.
     */
	private var __Remarks: String = String()

	/* *
     * Creates an instance of this class
     *
     * @param parameters An enumeration of projection parameters
     * @throws Exception the exception
     */
	init(_ parameters: [ProjectionParameter], _ inverse: MapProjection?) {
		_Parameters = ProjectionParameterSet(parameters)
		super.init()
        _inverse = inverse
        if _inverse != nil {
            inverse!._inverse = self
            _isinverse = !inverse!._isinverse
        }
		_semiMajor = _Parameters.getParameterValue(parameterName: "semi_major")
		_semiMinor = _Parameters.getParameterValue(parameterName: "semi_minor")
		// _es = 1.0 - (_semiMinor * _semiMinor) / (_semiMajor * _semiMajor);
		_es = MapProjection.eccentricySquared(equatorialRadius: _semiMajor, _semiMinor)
		_e = sqrt(_es)
		scale_factor = _Parameters.getOptionalParameterValue(name: "scale_factor", 1)
		central_meridian = MapProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "central_meridian", alternateNames: "longitude_of_center"))
		lat_origin = MapProjection.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "latitude_of_origin", alternateNames: "latitude_of_center"))
		_metersPerUnit = _Parameters.getParameterValue(parameterName: "unit")
		false_easting = _Parameters.getOptionalParameterValue(name: "false_easting", 0) * _metersPerUnit
		false_northing = _Parameters.getOptionalParameterValue(name: "false_northing", 0) * _metersPerUnit
		// TODO: Should really convert to the correct linear units??
		//  Compute constants for the mlfn
		var t: Double
		en0 = MapProjection.C00 - _es * (MapProjection.C02 + _es * (MapProjection.C04 + _es * (MapProjection.C06 + _es * MapProjection.C08)))
		en1 = _es * (MapProjection.C22 - _es * (MapProjection.C04 + _es * (MapProjection.C06 + _es * MapProjection.C08)))
		en2 = (_es * _es) * (MapProjection.C44 - _es * (MapProjection.C46 + _es * MapProjection.C48))
		t = _es * _es
		en3 = (t * _es) * (MapProjection.C66 - _es * MapProjection.C68)
		t *= _es
		en4 = t * _es * MapProjection.C88
	}
	/* *
     * Returns a list of projection "cloned" projection parameters
     *
     * @param projectionParameters the projection parameters
     * @return list
     * @throws Exception the exception
     */
	internal class func cloneParametersList(projectionParameters: [ProjectionParameter]) -> [ProjectionParameter] {
		var res: [ProjectionParameter] = [ProjectionParameter]()
		for pp: ProjectionParameter in projectionParameters { res.append(ProjectionParameter(pp.getName(), pp.getValue())) }
		return res
	}
	/* *
     * Returns the cube of a number.
     *
     * @param x the x
     * @return the double
     * @throws Exception the exception
     */
	internal class func cUBE(x: Double) -> Double { return pow(x, 3) }
	/* *
     * Returns the quad of a number.
     *
     * @param x the x
     * @return the double
     * @throws Exception the exception
     */
	internal class func qUAD(x: Double) -> Double { return pow(x, 4) }
	/* *
     * IMOD
     *
     * @param A the a
     * @param B the b
     * @return double
     * @throws Exception the exception
     */
	internal class func iMOD(A: Double, B: Double) -> Double { return (A) - (((A) / (B)) * (B)) }
	/* *
     * Function to return the sign of an argument
     *
     * @param x the x
     * @return the double
     * @throws Exception the exception
     */
	internal class func sign(x: Double) -> Double {
		if x < 0.0 {
			return (-1)
		} else {
			return (1)
		}
	}
	/* *
     * Adjust lon double.
     *
     * @param x the x
     * @return double
     * @throws Exception the exception
     */
	internal class func adjust_lon(a: Double) -> Double {
		var x: Double = a
		for _ in 0...MAX_VAL {
			if abs(x) <= PI {
				break
			} else if abs(x / Double.pi) < 2 {
//				x = x - (sign(x: x) * TWO_PI)
                x -= (sign(x: x) * TWO_PI)
			} else if abs(x / TWO_PI) < prjMAXLONG {
//				x = x - (x / TWO_PI) * TWO_PI
                x -= (x / TWO_PI) * TWO_PI
			} else if abs(x / (prjMAXLONG * TWO_PI)) < prjMAXLONG {
//				x = x - (x / (prjMAXLONG * TWO_PI)) * (TWO_PI * prjMAXLONG)
                x -= (x / (prjMAXLONG * TWO_PI)) * (TWO_PI * prjMAXLONG)
			} else if abs(x / (DBLLONG * TWO_PI)) < prjMAXLONG {
//				x = x - (x / (DBLLONG * TWO_PI)) * (TWO_PI * DBLLONG)
                x -= (x / (DBLLONG * TWO_PI)) * (TWO_PI * DBLLONG)
			} else {
//				x = x - (sign(x: x) * TWO_PI)
                x -= (sign(x: x) * TWO_PI)
			}
		}
		return (x)
	}
	/* *
     * Function to compute the constant small m which is the radius of
     * a parallel of latitude, phi, divided by the semimajor axis.
     *
     * @param eccent the eccent
     * @param sinphi the sinphi
     * @param cosphi the cosphi
     * @return the double
     * @throws Exception the exception
     */
	internal class func msfnz(eccent: Double, _ sinphi: Double, _ cosphi: Double) -> Double {
		var con: Double
		con = eccent * sinphi
		return ((cosphi / (sqrt(1.0 - con * con))))
	}
	/* *
     * Function to compute constant small q which is the radius of a
     * parallel of latitude, phi, divided by the semimajor axis.
     *
     * @param eccent the eccent
     * @param sinphi the sinphi
     * @return the double
     * @throws Exception the exception
     */
	internal class func qsfnz(eccent: Double, _ sinphi: Double) -> Double {
		var con: Double
		if eccent > 1.0e-7 {
			con = eccent * sinphi
			return ((1.0 - eccent * eccent) * (sinphi / (1.0 - con * con) - (0.5 / eccent) * log((1.0 - con) / (1.0 + con))))
		} else {
			return 2.0 * sinphi
		}
	}
	/* *
     * Function to compute the constant small t for use in the forward
     * computations in the Lambert Conformal Conic and the Polar
     * Stereographic projections.
     *
     * @param eccent the eccent
     * @param phi    the phi
     * @param sinphi the sinphi
     * @return the double
     * @throws Exception the exception
     */
	internal class func tsfnz(eccent: Double, _ phi: Double, _ sinphi: Double) -> Double {
		var con: Double
		var com: Double
		con = eccent * sinphi
		com = 0.5 * eccent
		con = pow(((1.0 - con) / (1.0 + con)), com)
		return (tan(0.5 * (HALF_PI - phi)) / con)
	}
	/* *
     * Phi 1 z double.
     *
     * @param eccent the eccent
     * @param qs     the qs
     * @return double
     * @throws Exception the exception
     */
	internal class func phi1z(eccent: Double, _ qs: Double) -> Double {
		var eccnts: Double
		var dphi: Double
		var con: Double
		var com: Double
		var sinpi: Double
		var cospi: Double
		var phi: Double
		// double asinz();
		phi = asinz(c: 0.5 * qs)
		if eccent < EPSLN { return (phi) }
		eccnts = eccent * eccent
		for _ in 1..<25 {
			sinpi = sin(phi)
			cospi = cos(phi)
			con = eccent * sinpi
			com = 1.0 - con * con
			dphi = 0.5 * com * com / cospi * (qs / (1.0 - eccnts) - sinpi / com + 0.5 / eccent * log((1.0 - con) / (1.0 + con)))
//			phi = phi + dphi
            phi += dphi
			if abs(dphi) <= 1e-7 { return (phi) }
		}
		return Double.nan
	}
	/* *
     * Function to eliminate roundoff errors in asin
     *
     * @param con the con
     * @return the double
     * @throws Exception the exception
     */
	internal class func asinz(c: Double) -> Double {
		var con: Double = c
		if abs(con) > 1.0 {
			if con > 1.0 {
				con = 1.0
			} else {
				con = -1.0
			}
		}
		return asin(con)
	}
	/* *
     * Function to compute the latitude angle, phi2, for the inverse of the
     * Lambert Conformal Conic and Polar Stereographic projections.
     *
     * @param eccent Spheroid eccentricity
     * @param ts     Constant value t
     * @return the double
     * @throws Exception the exception
     */
	internal class func phi2z(eccent: Double, _ ts: Double) -> Double {
		var con: Double
		var dphi: Double
		var sinpi: Double
		let eccnth: Double = 0.5 * eccent
		var chi: Double = HALF_PI - 2 * atan(ts)
		for _ in 0..<15 {
			sinpi = sin(chi)
			con = eccent * sinpi
			dphi = HALF_PI - 2 * atan(ts * (pow(((1.0 - con) / (1.0 + con)), eccnth))) - chi
			chi += dphi
			if abs(dphi) <= 0.0000000001 { return (chi) }
		}
		return Double.nan  // throwException() /* throw IllegalArgumentException("Convergence error - phi2z-conv"); */
	}
	/* *
     * Functions to compute the constants e0, e1, e2, and e3 which are used
     * in a series for calculating the distance along a meridian.  The
     * input x represents the eccentricity squared.
     *
     * @param x the x
     * @return the double
     * @throws Exception the exception
     */
	internal class func e0fn(x: Double) -> Double { return (1.0 - 0.25 * x * (1.0 + x / 16.0 * (3.0 + 1.25 * x))) }
	/* *
     * E 1 fn double.
     *
     * @param x the x
     * @return double
     * @throws Exception the exception
     */
	internal class func e1fn(x: Double) -> Double { return (0.375 * x * (1.0 + 0.25 * x * (1.0 + 0.46875 * x))) }
	/* *
     * E 2 fn double.
     *
     * @param x the x
     * @return double
     * @throws Exception the exception
     */
	internal class func e2fn(x: Double) -> Double { return (0.05859375 * x * x * (1.0 + 0.75 * x)) }
	/* *
     * E 3 fn double.
     *
     * @param x the x
     * @return double
     * @throws Exception the exception
     */
	internal class func e3fn(x: Double) -> Double { return (x * x * x * (35.0 / 3072.0)) }
	/* *
     * Function to compute the constant e4 from the input of the eccentricity
     * of the spheroid, x.  This constant is used in the Polar Stereographic
     * projection.
     *
     * @param x the x
     * @return the double
     * @throws Exception the exception
     */
	internal class func e4fn(x: Double) -> Double {
		var con: Double
		var com: Double
		con = 1.0 + x
		com = 1.0 - x
		return (sqrt((pow(con, con)) * (pow(com, com))))
	}
	/* *
     * Function computes the value of M which is the distance along a meridian
     * from the Equator to latitude phi.
     *
     * @param e0  the e 0
     * @param e1  the e 1
     * @param e2  the e 2
     * @param e3  the e 3
     * @param phi the phi
     * @return the double
     * @throws Exception the exception
     */
	internal class func mlfn(e0: Double, _ e1: Double, _ e2: Double, _ e3: Double, _ phi: Double) -> Double { return (e0 * phi - e1 * sin(2.0 * phi) + e2 * sin(4.0 * phi) - e3 * sin(6.0 * phi)) }
	/* *
     * Calculates the flattening factor, (
     * {@code equatorialRadius}
     * -
     * {@code polarRadius}
     * ) /
     * {@code equatorialRadius}
     * .
     *
     * @param equatorialRadius The radius of the equator
     * @param polarRadius      The radius of a circle touching the poles
     * @return The flattening factor
     */
	private class func flatteningFactor(equatorialRadius: Double, _ polarRadius: Double) -> Double { return (equatorialRadius - polarRadius) / equatorialRadius }
	/* *
     * Calculates the square of eccentricity according to es = (2f - f^2) where f is the FlatteningFactor
     * .
     *
     * @param equatorialRadius The radius of the equator
     * @param polarRadius      The radius of a circle touching the poles
     * @return The square of eccentricity
     */
	private class func eccentricySquared(equatorialRadius: Double, _ polarRadius: Double) -> Double {
		let f: Double = flatteningFactor(equatorialRadius: equatorialRadius, polarRadius)
		return 2 * f - f * f
	}
	/* *
     * Function to calculate UTM zone number
     *
     * @param lon The longitudinal value (in Degrees!)
     * @return The UTM zone number
     * @throws Exception the exception
     */
	internal class func calcUtmZone(lon: Double) -> Int64 { return Int64(((lon + 180.0) / 6.0) + 1.0) }
	/* *
     * Converts a longitude value in degrees to radians.
     *
     * @param x    The value in degrees to convert to radians.
     * @param edge If true, -180 and +180 are valid, otherwise they are considered out of range.
     * @return double
     * @throws Exception the exception
     */
	internal class func longitudeToRadians(x: Double, _ edge: Bool) -> Double {
		if edge ? (x >= -180 && x <= 180) : (x > -180 && x < 180) { return degrees2Radians(deg: x) }
		return Double.nan  // throwException() /* throw IllegalArgumentException("x " + x + " not a valid longitude in degrees."); */
	}
	// var projectedPoint = new double[] { 0, 0, 0, };
	/* *
     * Converts a latitude value in degrees to radians.
     *
     * @param y    The value in degrees to to radians.
     * @param edge If true, -90 and +90 are valid, otherwise they are considered out of range.
     * @return double
     * @throws Exception the exception
     */
	internal class func latitudeToRadians(y: Double, _ edge: Bool) -> Double {
		if edge ? (y >= -90 && y <= 90) : (y > -90 && y < 90) { return degrees2Radians(deg: y) }
		return Double.nan  // throwException() /* throw IllegalArgumentException("y " + y + " not a valid latitude in degrees."); */
	}
	/*
                if (proj.NumParameters != NumParameters)
    				return false;
    			
                for (var i = 0; i < _Parameters.Count; i++)
    			{
    				var param = _Parameters.Find(par => par.Name.Equals(proj.GetParameter(i).Name, StringComparison.OrdinalIgnoreCase));
    				if (param == null)
    					return false;
    				if (param.Value != proj.GetParameter(i).Value)
    					return false;
    			}
                 */// defines some usefull constants that are used in the projection routines
	/* *
     * Gets origin.
     *
     * @return the origin
     * @throws Exception the exception
     */
	/* Center longitude (projection center) */internal func getlon_origin() -> Double { return central_meridian }
	/* *
     * Sets origin.
     *
     * @param value the value
     * @throws Exception the exception
     */
	internal func setlon_origin(value: Double) { central_meridian = value }
	/* *
     * Gets the projection classification name (e.g. 'Transverse_Mercator').
     */
	public func getClassName() -> String { return getName() }
	/* *
     * @param index
     * @return
     */
	public func getParameter(index: Int) -> ProjectionParameter? { return _Parameters.getAtIndex(index: index) }
	/* *
     * Gets an named parameter of the projection.
     * The parameter name is case insensitive
     *
     * @param name Name of parameter
     * @return parameter or null if not found
     */
	public func getParameter(name: String) -> ProjectionParameter? { return _Parameters.find(name: name) }

    public func getNumParameters() -> Int { return _Parameters.size() }
	public func getAbbreviation() -> String? { return __Abbreviation }
	/* *
     * Sets abbreviation.
     *
     * @param value the value
     */
	public func setAbbreviation(value: String) { __Abbreviation = value }
	public func getAlias() -> String? { return __Alias }
	/* x^3 */
	/* *
     * Sets alias.
     *
     * @param value the value
     */
	public func setAlias(value: String) { __Alias = value }
	/* assign minimum of a and b */
	public func getAuthority() -> String { return __Authority }
	/* Integer mod function */
	/* *
     * Sets authority.
     *
     * @param value the value
     */
	public func setAuthority(value: String) { __Authority = value }
	public func getAuthorityCode() -> Int { return __AuthorityCode }
	/* *
     * Sets authority code.
     *
     * @param value the value
     */
	public func setAuthorityCode(value: Int) { __AuthorityCode = value }
	public func getName() -> String { return __Name }
	/* *
     * Function to calculate the sine and cosine in one call.  Some computer
     * systems have implemented this function, resulting in a faster implementation
     * than calling each function separately.  It is provided here for those
     * computer systems which don`t implement this function
     *
     * @param value the value
     */
	/* protected static void sincos(double val, RefSupport<double> sin_val, RefSupport<double> cos_val) throws Exception {
        sin_val.setValue(Math.sin(val));
        cos_val.setValue(Math.cos(val));
    }*/
	public func setName(value: String) { __Name = value }
	public func getRemarks() -> String { return __Remarks }
	// p_error ("Convergence error","phi1z-conv");
	// ASSERT(FALSE);
	/* *
     * Sets remarks.
     *
     * @param value the value
     */
	public func setRemarks(value: String) { __Remarks = value }
	/* *
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
    public override func getWKT() -> String {
        /*var sb : StringBuilder = StringBuilder();
         if (_isinverse)
         sb.append("INVERSE_MT[");

         sb.append(String.format("PARAM_MT[\"%s\"", getName()));
         for  var i : Int = 0; i < getNumParameters(); i++
         { sb.append(String.format(", %s", getParameter(i).getWKT())); }
         //if (!String.IsNullOrEmpty(Authority) && AuthorityCode > 0)
         //	sb.AppendFormat(", AUTHORITY[\"{0}\", \"{1}\"]", Authority, AuthorityCode);
         sb.append("]");
         if (_isinverse)
         sb.append("]");

         return sb.toString();*/
        return ""
    }
	/* *
     * Gets an XML representation of this object
     */
    public override func getXML() -> String {
        /*var sb : StringBuilder = StringBuilder();
         sb.append("<CT_MathTransform>");
         sb.append(String.format(_isinverse ? "<CT_InverseTransform Name=\"%s\">" : "<CT_ParameterizedMathTransform Name=\"%s\">", getClassName()));
         for  var i : Int = 0; i < getNumParameters(); i++
         { sb.append(getParameter(i).getXML()); }
         sb.append(_isinverse ? "</CT_InverseTransform>" : "</CT_ParameterizedMathTransform>");
         sb.append("</CT_MathTransform>");
         return sb.toString();*/
        return ""
    }
	public override func getDimSource() -> Int { return 2 }
	public override func getDimTarget() -> Int { return 2 }
	/* *
     * Function to transform from meters to degrees
     *
     * @param p The ordinates of the point
     * @return The transformed ordinates
     * @throws Exception the exception
     */
	public func metersToDegrees(p: [Double]) -> [Double] {
		var tmp: [Double]
		if p.count == 2 {
			tmp = [p[0] * _metersPerUnit - false_easting, p[1] * _metersPerUnit - false_northing]
		} else {
			tmp = [p[0] * _metersPerUnit - false_easting, p[1] * _metersPerUnit - false_northing, p[2] * _metersPerUnit]
		}
		var res: [Double] = metersToRadians(p: tmp)
		res[0] = MapProjection.radians2Degrees(rad: res[0])
		res[1] = MapProjection.radians2Degrees(rad: res[1])
		if getDimTarget() == 3 { res[2] = MapProjection.radians2Degrees(rad: res[2]) }
		return res
	}
	/* *
     * Function to transform from degrees to meters
     *
     * @param lonlat The ordinates of the point
     * @return The transformed ordinates
     * @throws Exception the exception
     */
	public func degreesToMeters(lonlat: [Double]) -> [Double] {
		// Convert to radians
		var tmp: [Double]
		if lonlat.count == 2 {
			tmp = [MapProjection.degrees2Radians(deg: lonlat[0]), MapProjection.degrees2Radians(deg: lonlat[1])]
		} else {
			tmp = [MapProjection.degrees2Radians(deg: lonlat[0]), MapProjection.degrees2Radians(deg: lonlat[1]), MapProjection.degrees2Radians(deg: lonlat[2])]
		}
		// Convert to meters
		var res: [Double] = radiansToMeters(lonlat: tmp)
		// Add false easting and northing, convert to unit
		res[0] = (res[0] + false_easting) / _metersPerUnit
		res[1] = (res[1] + false_northing) / _metersPerUnit
        if res.count == 3 {
//            res[2] = res[2] / _metersPerUnit
            res[2] /= _metersPerUnit
        }
		return res
	}
	/* *
     * Radians to meters double [ ].
     *
     * @param lonlat the lonlat
     * @return the double [ ]
     * @throws Exception the exception
     */
	internal func radiansToMeters(lonlat: [Double]) -> [Double] { return [] }
	/* *
     * Meters to radians double [ ].
     *
     * @param p the p
     * @return the double [ ]
     * @throws Exception the exception
     */
	internal func metersToRadians(p: [Double]) -> [Double] { return [] }
	/* *
     * Reverses the transformation
     */
	public override func invert() {
        _isinverse.toggle()
        if let inverse = _inverse as? MapProjection {
            inverse.invert(invertInverse: false)
        }
	}
	/* *
     * Invert.
     *
     * @param invertInverse the invert inverse
     * @throws Exception the exception
     */
	internal func invert(invertInverse: Bool) {
        _isinverse.toggle()
        if invertInverse, let inverse = _inverse as? MapProjection {
            inverse.invert(invertInverse: false)
        }
	}
	/* *
     * Returns true if this projection is inverted.
     * Most map projections define forward projection as "from geographic to projection", and backwards
     * as "from projection to geographic". If this projection is inverted, this will be the other way around.
     *
     * @return the isinverse
     * @throws Exception the exception
     */
	internal func getIsinverse() -> Bool { return _isinverse }
	/* *
     * Transforms the specified cp.
     *
     * @param cp The cp.
     * @return
     */
	public override func transform(point: [Double]) -> [Double] {
        return !_isinverse ? degreesToMeters(lonlat: point) : metersToDegrees(p: point)
    }
	/* *
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public func equalParams(obj: Any) -> Bool {
        guard let proj = obj as? MapProjection else { return false }
		if !_Parameters.equals(other: proj._Parameters) { return false }
		return getIsinverse() == proj.getIsinverse()
	}
	/* *
     * Calculates the meridian distance. This is the distance along the central
     * meridian from the equator to
     * {@code phi}
     * . Accurate to less then 1e-5 meters
     * when used in conjuction with typical major axis values.
     *
     * @param phi  the phi
     * @param sphi the sphi
     * @param cphi the cphi
     * @return double
     * @throws Exception the exception
     */
	internal func mlfn(phi: Double, _ sphi: Double, _ cphi: Double) -> Double {
		let cphi2 = cphi * sphi
		let sphi2 = sphi * sphi
		return en0 * phi - cphi2 * (en1 + sphi2 * (en2 + sphi2 * (en3 + sphi2 * en4)))
	}
	/* *
     * Calculates the latitude (phi) from a meridian distance.
     * Determines phi to TOL (1e-11) radians, about 1e-6 seconds.
     *
     * @param arg The meridonial distance
     * @return The latitude of the meridian distance.
     * @throws Exception the exception
     */
	internal func inv_mlfn(arg: Double) -> Double {
		var s: Double
		var t: Double
		var phi: Double
        let k: Double = 1.0 / (1.0 - _es)

		phi = arg
		for _ in 0...MAXIMUM_ITERATIONS {
			// rarely goes over 5 iterations
			// if (--i < 0) {
			//    throwException() /* throw IllegalArgumentException("No convergence"); */
			// }
			s = sin(phi)
			t = 1.0 - _es * s * s
			t = (mlfn(phi: phi, s, cos(phi)) - arg) * (t * sqrt(t)) * k
			phi -= t
			if abs(t) < MLFN_TOL { return phi }
		}
		return Double.nan
	}
}
