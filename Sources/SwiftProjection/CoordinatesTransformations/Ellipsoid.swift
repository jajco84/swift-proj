/// The IEllipsoid interface defines the standard information stored with ellipsoid objects.
public class Ellipsoid: Info, IEllipsoid {
	/**
     * Gets or sets the value of the semi-major axis.
     */
	private var __SemiMajorAxis: Double
	/**
     * Gets or sets the value of the semi-minor axis.
     */
	private var __SemiMinorAxis: Double
	/**
     * Gets or sets the value of the inverse of the flattening constant of the ellipsoid.
     */
	private var __InverseFlattening: Double
	/**
     * Gets or sets the value of the axis unit.
     */
	private var __AxisUnit: ILinearUnit
	/**
     * Tells if the Inverse Flattening is definitive for this ellipsoid. Some ellipsoids use
     * the IVF as the defining value, and calculate the polar radius whenever asked. Other
     * ellipsoids use the polar radius to calculate the IVF whenever asked. This
     * distinction can be important to avoid floating-point rounding errors.
     */
	private var __IsIvfDefinitive: Bool
	/**
     * Initializes a new instance of an Ellipsoid
     *
     * @param semiMajorAxis     Semi major axis
     * @param semiMinorAxis     Semi minor axis
     * @param inverseFlattening Inverse flattening
     * @param isIvfDefinitive   Inverse Flattening is definitive for this ellipsoid (Semi-minor axis will be overridden)
     * @param axisUnit          Axis unit
     * @param name              Name
     * @param authority         Authority name
     * @param code              Authority-specific identification code.
     * @param alias             Alias
     * @param abbreviation      Abbreviation
     * @param remarks           Provider-supplied remarks
     * @throws Exception the exception
     */
	public init(_ semiMajorAxis: Double, _ semiMinorAxis: Double, _ inverseFlattening: Double, _ isIvfDefinitive: Bool, _ axisUnit: ILinearUnit, _ name: String, _ authority: String, _ code: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		__SemiMajorAxis = semiMajorAxis
		__InverseFlattening = inverseFlattening
		__AxisUnit = axisUnit
		__IsIvfDefinitive = isIvfDefinitive
		if isIvfDefinitive && (inverseFlattening == 0 || inverseFlattening.isInfinite) {
			__SemiMinorAxis = semiMinorAxis
		} else if isIvfDefinitive {
			__SemiMinorAxis = (1.0 - (1.0 / inverseFlattening)) * semiMajorAxis
		} else {
			__SemiMinorAxis = semiMinorAxis
		}
		super.init(name, authority, code, alias, abbreviation, remarks)
	}
	/**
     * WGS 84 ellipsoid
     *
     * Inverse flattening derived from four defining parameters
     * (semi-major axis;
     * C20 = -484.16685*10e-6;
     * earth's angular velocity w = 7292115e11 rad/sec;
     * gravitational constant GM = 3986005e8 m*m*m/s/s).
     *
     * @return the wgs 84
     * @throws Exception the exception
     */
	public class func getWGS84() -> Ellipsoid { return Ellipsoid(6_378_137, 0, 298.257223563, true, LinearUnit.getMetre(), "WGS 84", "EPSG", 7030, "WGS84", "", "Inverse flattening derived from four defining parameters (semi-major axis; C20 = -484.16685*10e-6; earth's angular velocity w = 7292115e11 rad/sec; gravitational constant GM = 3986005e8 m*m*m/s/s).") }
	/**
     * WGS 72 Ellipsoid
     *
     * @return the wgs 72
     * @throws Exception the exception
     */
	public class func getWGS72() -> Ellipsoid { return Ellipsoid(6378135.0, 0, 298.26, true, LinearUnit.getMetre(), "WGS 72", "EPSG", 7043, "WGS 72", "", "") }
	/**
     * GRS 1980 / International 1979 ellipsoid
     *
     * Adopted by IUGG 1979 Canberra.
     * Inverse flattening is derived from
     * geocentric gravitational constant GM = 3986005e8 m*m*m/s/s;
     * dynamic form factor J2 = 108263e8 and Earth's angular velocity = 7292115e-11 rad/s.")
     *
     * @return the grs 80
     * @throws Exception the exception
     */
	public class func getGRS80() -> Ellipsoid { return Ellipsoid(6_378_137, 0, 298.257222101, true, LinearUnit.getMetre(), "GRS 1980", "EPSG", 7019, "International 1979", "", "Adopted by IUGG 1979 Canberra.  Inverse flattening is derived from geocentric gravitational constant GM = 3986005e8 m*m*m/s/s; dynamic form factor J2 = 108263e8 and Earth's angular velocity = 7292115e-11 rad/s.") }
	/**
     * International 1924 / Hayford 1909 ellipsoid
     *
     * Described as a=6378388 m. and b=6356909m. from which 1/f derived to be 296.95926.
     * The figure was adopted as the International ellipsoid in 1924 but with 1/f taken as
     * 297 exactly from which b is derived as 6356911.946m.
     *
     * @return the international 1924
     * @throws Exception the exception
     */
	public class func getInternational1924() -> Ellipsoid { return Ellipsoid(6_378_388, 0, 297, true, LinearUnit.getMetre(), "International 1924", "EPSG", 7022, "Hayford 1909", "", "Described as a=6378388 m. and b=6356909 m. from which 1/f derived to be 296.95926. The figure was adopted as the International ellipsoid in 1924 but with 1/f taken as 297 exactly from which b is derived as 6356911.946m.") }
	/**
     * Clarke 1880
     *
     * Clarke gave a and b and also 1/f=293.465 (to 3 decimal places).  1/f derived from a and b = 293.4663077
     *
     * @return the clarke 1880
     * @throws Exception the exception
     */
	public class func getClarke1880() -> Ellipsoid { return Ellipsoid(20_926_202, 0, 297, true, LinearUnit.getClarkesFoot(), "Clarke 1880", "EPSG", 7034, "Clarke 1880", "", "Clarke gave a and b and also 1/f=293.465 (to 3 decimal places).  1/f derived from a and b = 293.4663077…") }
	/**
     * Clarke 1866
     *
     * Original definition a=20926062 and b=20855121 (British) feet. Uses Clarke's 1865 inch-metre ratio of 39.370432 to obtain metres. (Metric value then converted to US survey feet for use in the United States using 39.37 exactly giving a=20925832.16 ft US).
     *
     * @return the clarke 1866
     * @throws Exception the exception
     */
	public class func getClarke1866() -> Ellipsoid { return Ellipsoid(6378206.4, 6356583.8, Double.infinity, false, LinearUnit.getMetre(), "Clarke 1866", "EPSG", 7008, "Clarke 1866", "", "Original definition a=20926062 and b=20855121 (British) feet. Uses Clarke's 1865 inch-metre ratio of 39.370432 to obtain metres. (Metric value then converted to US survey feet for use in the United States using 39.37 exactly giving a=20925832.16 ft US).") }
	/**
     * Sphere
     *
     * Authalic sphere derived from GRS 1980 ellipsoid (code 7019).  (An authalic sphere is
     * one with a surface area equal to the surface area of the ellipsoid). 1/f is infinite.
     *
     * @return the sphere
     * @throws Exception the exception
     */
	public class func getSphere() -> Ellipsoid { return Ellipsoid(6370997.0, 6370997.0, Double.infinity, false, LinearUnit.getMetre(), "GRS 1980 Authalic Sphere", "EPSG", 7048, "Sphere", "", "Authalic sphere derived from GRS 1980 ellipsoid (code 7019).  (An authalic sphere is one with a surface area equal to the surface area of the ellipsoid). 1/f is infinite.") }
	public func getSemiMajorAxis() -> Double { return __SemiMajorAxis }
	public func setSemiMajorAxis(value: Double) { __SemiMajorAxis = value }
	public func getSemiMinorAxis() -> Double { return __SemiMinorAxis }
	public func setSemiMinorAxis(value: Double) { __SemiMinorAxis = value }
	public func getInverseFlattening() -> Double { return __InverseFlattening }
	public func setInverseFlattening(value: Double) { __InverseFlattening = value }
	public func getAxisUnit() -> ILinearUnit { return __AxisUnit }
	public func setAxisUnit(value: ILinearUnit) { __AxisUnit = value }
	public func getIsIvfDefinitive() -> Bool { return __IsIvfDefinitive }
	public func setIsIvfDefinitive(value: Bool) { __IsIvfDefinitive = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "SPHEROID[\"\(getName())\", \(getSemiMajorAxis()), \(getInverseFlattening())"
		if getAuthority() != "" && getAuthorityCode() > 0 { sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]" }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String {
		return "<CS_Ellipsoid SemiMajorAxis=\"\(getSemiMajorAxis())\" SemiMinorAxis=\"\(getSemiMinorAxis())\" InverseFlattening=\"\(getInverseFlattening())\" IvfDefinitive=\"\(getIsIvfDefinitive() ? 1 : 0)\">\(getInfoXml())\(getAxisUnit().getXML())</CS_Ellipsoid>"
	}
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public override func equalParams(obj: Any) -> Bool {
		if !(obj is Ellipsoid) { return false }
		let e: Ellipsoid = obj as! Ellipsoid
		return (e.getInverseFlattening() == self.getInverseFlattening() && e.getIsIvfDefinitive() == self.getIsIvfDefinitive() && e.getSemiMajorAxis() == self.getSemiMajorAxis() && e.getSemiMinorAxis() == self.getSemiMinorAxis() && e.getAxisUnit().equalParams(obj: self.getAxisUnit()))
	}
}
