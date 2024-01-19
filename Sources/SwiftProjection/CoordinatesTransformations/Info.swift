/// The Info object defines the standard information
/// stored with spatial reference objects
public class Info: IInfo {
	private var _Name: String = String()
	private var _Authority: String = String()
	private var _Code: Int
	private var _Alias: String = String()
	private var _Abbreviation: String = String()
	private var _Remarks: String = String()
	/**
     * A base interface for metadata applicable to coordinate system objects.
     * The metadata items Abbreviation, Alias, Authority, AuthorityCode, Name and Remarks
     * were specified in the Simple Features interfaces, so they have been kept here.This specification does not dictate what the contents of these items
     * should be. However, the following guidelines are suggested:When
     * {@link ICoordinateSystemAuthorityFactory}
     * is used to create an object, the Authority
     * and 'AuthorityCode' values should be set to the authority name of the factory object, and the authority
     * code supplied by the client, respectively. The other values may or may not be set. (If the authority is
     * EPSG, the implementer may consider using the corresponding metadata values in the EPSG tables.)When
     * {@link CoordinateSystemFactory}
     * creates an object, the 'Name' should be set to the value
     * supplied by the client. All of the other metadata items should be left empty
     *
     * @param name         Name
     * @param authority    Authority name
     * @param code         Authority-specific identification code.
     * @param alias        Alias
     * @param abbreviation Abbreviation
     * @param remarks      Provider-supplied remarks
     * @throws Exception the exception
     */
	public init(_ name: String, _ authority: String, _ code: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_Name = name
		_Authority = authority
		_Code = code
		_Alias = alias
		_Abbreviation = abbreviation
		_Remarks = remarks
	}
	/**
     * Gets or sets the name of the object.
     */
	public func getName() -> String { return _Name }
	/**
     * Sets name.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setName(value: String) { _Name = value }
	/**
     * Gets or sets the authority name for this object, e.g., "EPSG",
     * is this is a standard object with an authority specific
     * identity code. Returns "CUSTOM" if this is a custom object.
     */
	public func getAuthority() -> String { return _Authority }
	/**
     * Sets authority.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setAuthority(value: String) { _Authority = value }
	/**
     * Gets or sets the authority specific identification code of the object
     */
	public func getAuthorityCode() -> Int { return _Code }
	/**
     * Sets authority code.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setAuthorityCode(value: Int) { _Code = value }
	/**
     * Gets or sets the alias of the object.
     */
	public func getAlias() -> String? { return _Alias }
	/**
     * Sets alias.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setAlias(value: String) { _Alias = value }
	/**
     * Gets or sets the abbreviation of the object.
     */
	public func getAbbreviation() -> String? { return _Abbreviation }
	/**
     * Sets abbreviation.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setAbbreviation(value: String) { _Abbreviation = value }
	/**
     * Gets or sets the provider-supplied remarks for the object.
     */
	public func getRemarks() -> String { return _Remarks }
	/**
     * Sets remarks.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setRemarks(value: String) { _Remarks = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public func toString() -> String {
		return getWKT()
	}
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public func getWKT() -> String { preconditionFailure("This method must be overridden") }
	/**
     * Gets an XML representation of this object.
     */
	public func getXML() -> String { preconditionFailure("This method must be overridden") }
	/**
     * Returns an XML string of the info object
     *
     * @return the info xml
     * @throws Exception the exception
     */
	public func getInfoXml() -> String {
		var sb: String
		sb = "<CS_Info"
		if getAuthorityCode() > 0 { sb += " AuthorityCode=\"\(getAuthorityCode())\"" }
		if getAbbreviation() != nil && getAbbreviation() != "" { sb += " Abbreviation=\"\(getAbbreviation() ?? "")\"" }
		if getAuthority() != "" { sb += " Authority=\"\(getAuthority())\"" }
		if getName() != "" { sb += " Name=\"%\(getName())\"" }
		sb += "/>"
		return sb
	}
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public func equalParams(obj: Any) -> Bool { preconditionFailure("This method must be overridden") }
}
