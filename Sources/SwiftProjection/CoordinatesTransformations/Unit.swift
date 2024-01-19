/// Class for defining units
public class Unit: Info, IUnit {
	private var _ConversionFactor: Double
	/**
     * Initializes a new unit
     *
     * @param conversionFactor Conversion factor to base unit
     * @param name             Name of unit
     * @param authority        Authority name
     * @param authorityCode    Authority-specific identification code.
     * @param alias            Alias
     * @param abbreviation     Abbreviation
     * @param remarks          Provider-supplied remarks
     * @throws Exception the exception
     */
	init(_ conversionFactor: Double, _ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_ConversionFactor = conversionFactor
		super.init(name, authority, authorityCode, alias, abbreviation, remarks)
	}
	/**
     * Initializes a new unit
     *
     * @param name             Name of unit
     * @param conversionFactor Conversion factor to base unit
     * @throws Exception the exception
     */
	convenience init(_ name: String, _ conversionFactor: Double) { self.init(conversionFactor, name, "", -1, "", "", "") }
	/**
     * Gets or sets the number of units per base-unit.
     *
     * @return the conversion factor
     * @throws Exception the exception
     */
	public func getConversionFactor() -> Double { return _ConversionFactor }
	/**
     * Sets conversion factor.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setConversionFactor(value: Double) { _ConversionFactor = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "UNIT[\"\(getName())\", \(_ConversionFactor)"
		if getAuthority() != "" && getAuthorityCode() > 0 { sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]" }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object [NOT IMPLEMENTED].
     */
	public override func getXML() -> String {
		return "not implemented"  //throwException() /* throw UnsupportedOperationException(); */
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
		if !(obj is Unit) { return false }
		let u: Unit = obj as! Unit
		return u.getConversionFactor() == self.getConversionFactor()
	}
}
