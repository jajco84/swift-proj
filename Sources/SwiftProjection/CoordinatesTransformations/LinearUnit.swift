/// Definition of linear units.
public class LinearUnit: Info, ILinearUnit {
	private var _MetersPerUnit: Double
	/**
     * Creates an instance of a linear unit
     *
     * @param metersPerUnit Number of meters per                      {@link #LinearUnit}
     * @param name          Name
     * @param authority     Authority name
     * @param authorityCode Authority-specific identification code.
     * @param alias         Alias
     * @param abbreviation  Abbreviation
     * @param remarks       Provider-supplied remarks
     * @throws Exception the exception
     */
	init(_ metersPerUnit: Double, _ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_MetersPerUnit = metersPerUnit
		super.init(name, authority, authorityCode, alias, abbreviation, remarks)
	}
	/**
     * Returns the meters linear unit.
     * Also known as International metre. SI standard unit.
     *
     * @return the metre
     * @throws Exception the exception
     */
	public class func getMetre() -> ILinearUnit { return LinearUnit(1.0, "metre", "EPSG", 9001, "m", "", "Also known as International metre. SI standard unit.") }
	/**
     * Returns the foot linear unit (1ft = 0.3048m).
     *
     * @return the foot
     * @throws Exception the exception
     */
	public class func getFoot() -> ILinearUnit { return LinearUnit(0.3048, "foot", "EPSG", 9002, "ft", "", "") }
	/**
     * Returns the US Survey foot linear unit (1ftUS = 0.304800609601219m).
     *
     * @return the us survey foot
     * @throws Exception the exception
     */
	public class func getUSSurveyFoot() -> ILinearUnit { return LinearUnit(0.304800609601219, "US survey foot", "EPSG", 9003, "American foot", "ftUS", "Used in USA.") }
	/**
     * Returns the Nautical Mile linear unit (1NM = 1852m).
     *
     * @return the nautical mile
     * @throws Exception the exception
     */
	public class func getNauticalMile() -> ILinearUnit { return LinearUnit(1852, "nautical mile", "EPSG", 9030, "NM", "", "") }
	/**
     * Returns Clarke's foot.
     *
     * Assumes Clarke's 1865 ratio of 1 British foot = 0.3047972654 French legal metres applies to the international metre.
     * Used in older Australian, southern African and British West Indian mapping.
     *
     * @return the clarkes foot
     * @throws Exception the exception
     */
	public class func getClarkesFoot() -> ILinearUnit { return LinearUnit(0.3047972654, "Clarke's foot", "EPSG", 9005, "Clarke's foot", "", "Assumes Clarke's 1865 ratio of 1 British foot = 0.3047972654 French legal metres applies to the international metre. Used in older Australian, southern African & British West Indian mapping.") }
	/**
     * Gets or sets the number of meters per
     * {@link #LinearUnit}
     * .
     */
	public func getMetersPerUnit() -> Double { return _MetersPerUnit }
	public func setMetersPerUnit(value: Double) { _MetersPerUnit = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "UNIT[\"\(getName())\", \(getMetersPerUnit())"
		if getAuthority() != "" && getAuthorityCode() > 0 { sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]" }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String { return "<CS_LinearUnit MetersPerUnit=\"\(getMetersPerUnit())\">\(getInfoXml())</CS_LinearUnit>" }
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public override func equalParams(obj: Any) -> Bool {
        if !(obj is LinearUnit) { return false }
        let lu: LinearUnit = obj as! LinearUnit
		return lu.getMetersPerUnit() == self.getMetersPerUnit()
	}
}
