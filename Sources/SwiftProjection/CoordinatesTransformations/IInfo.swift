/// The ISpatialReferenceInfo interface defines the standard
/// information stored with spatial reference objects. This
/// interface is reused for many of the spatial reference
/// objects in the system.
public protocol IInfo {
	/**
     * Gets or sets the name of the object.
     *
     * @return the name
     * @throws Exception the exception
     */
	func getName() -> String
	/**
     * Gets or sets the authority name for this object, e.g., “POSC”,
     * is this is a standard object with an authority specific
     * identity code. Returns “CUSTOM” if this is a custom object.
     *
     * @return the authority
     * @throws Exception the exception
     */
	func getAuthority() -> String
	/**
     * Gets or sets the authority specific identification code of the object
     *
     * @return the authority code
     * @throws Exception the exception
     */
	func getAuthorityCode() -> Int
	/**
     * Gets or sets the alias of the object.
     *
     * @return the alias
     * @throws Exception the exception
     */
	func getAlias() -> String?
	/**
     * Gets or sets the abbreviation of the object.
     *
     * @return the abbreviation
     * @throws Exception the exception
     */
	func getAbbreviation() -> String?
	/**
     * Gets or sets the provider-supplied remarks for the object.
     *
     * @return the remarks
     * @throws Exception the exception
     */
	func getRemarks() -> String
	/**
     * Returns the Well-known text for this spatial reference object
     * as defined in the simple features specification.
     *
     * @return the wkt
     * @throws Exception the exception
     */
	func getWKT() -> String
	/**
     * Gets an XML representation of this object.
     *
     * @return the xml
     * @throws Exception the exception
     */
	func getXML() -> String
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj the obj
     * @return True if equal
     * @throws Exception the exception
     */
	func equalParams(obj: Any) -> Bool
}
