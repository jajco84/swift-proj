/// A meridian used to take longitude measurements from.
public class PrimeMeridian: Info, IPrimeMeridian {
	private var _Longitude: Double
	private var _AngularUnit: IAngularUnit
	/* *
     * Initializes a new instance of a prime meridian
     *
     * @param longitude     Longitude of prime meridian
     * @param angularUnit   Angular unit
     * @param name          Name
     * @param authority     Authority name
     * @param authorityCode Authority-specific identification code.
     * @param alias         Alias
     * @param abbreviation  Abbreviation
     * @param remarks       Provider-supplied remarks
     * @throws Exception the exception
     */
	public init(_ longitude: Double, _ angularUnit: IAngularUnit, _ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_Longitude = longitude
		_AngularUnit = angularUnit
		super.init(name, authority, authorityCode, alias, abbreviation, remarks)
	}
	/* *
     * Greenwich prime meridian
     *
     * @return the greenwich
     * @throws Exception the exception
     */
	public class func getGreenwich() -> PrimeMeridian { return PrimeMeridian(0.0, AngularUnit.getDegrees(), "Greenwich", "EPSG", 8901, "", "", "") }
	/* *
     * Lisbon prime meridian
     *
     * @return the lisbon
     * @throws Exception the exception
     */
	public class func getLisbon() -> PrimeMeridian { return PrimeMeridian(-9.0754862, AngularUnit.getDegrees(), "Lisbon", "EPSG", 8902, "", "", "") }
	/* *
     * Paris prime meridian.
     * Value adopted by IGN (Paris) in 1936. Equivalent to 2 deg 20min 14.025sec. Preferred by EPSG to earlier value of 2deg 20min 13.95sec (2.596898 grads) used by RGS London.
     *
     * @return the paris
     * @throws Exception the exception
     */
	public class func getParis() -> PrimeMeridian { return PrimeMeridian(2.5969213, AngularUnit.getDegrees(), "Paris", "EPSG", 8903, "", "", "Value adopted by IGN (Paris) in 1936. Equivalent to 2 deg 20min 14.025sec. Preferred by EPSG to earlier value of 2deg 20min 13.95sec (2.596898 grads) used by RGS London.") }
	/* *
     * Bogota prime meridian
     *
     * @return the bogota
     * @throws Exception the exception
     */
	public class func getBogota() -> PrimeMeridian { return PrimeMeridian(-74.04513, AngularUnit.getDegrees(), "Bogota", "EPSG", 8904, "", "", "") }
	/* *
     * Madrid prime meridian
     *
     * @return the madrid
     * @throws Exception the exception
     */
	public class func getMadrid() -> PrimeMeridian { return PrimeMeridian(-3.411658, AngularUnit.getDegrees(), "Madrid", "EPSG", 8905, "", "", "") }
	/* *
     * Rome prime meridian
     *
     * @return the rome
     * @throws Exception the exception
     */
	public class func getRome() -> PrimeMeridian { return PrimeMeridian(12.27084, AngularUnit.getDegrees(), "Rome", "EPSG", 8906, "", "", "") }
	/* *
     * Bern prime meridian.
     * 1895 value. Newer value of 7 deg 26 min 22.335 sec E determined in 1938.
     *
     * @return the bern
     * @throws Exception the exception
     */
	public class func getBern() -> PrimeMeridian { return PrimeMeridian(7.26225, AngularUnit.getDegrees(), "Bern", "EPSG", 8907, "", "", "1895 value. Newer value of 7 deg 26 min 22.335 sec E determined in 1938.") }
	/* *
     * Jakarta prime meridian
     *
     * @return the jakarta
     * @throws Exception the exception
     */
	public class func getJakarta() -> PrimeMeridian { return PrimeMeridian(106.482779, AngularUnit.getDegrees(), "Jakarta", "EPSG", 8908, "", "", "") }
	/* *
     * Ferro prime meridian.
     * Used in Austria and former Czechoslovakia.
     *
     * @return the ferro
     * @throws Exception the exception
     */
	public class func getFerro() -> PrimeMeridian { return PrimeMeridian(-17.66666666666667, AngularUnit.getDegrees(), "Ferro", "EPSG", 8909, "", "", "Used in Austria and former Czechoslovakia.") }
	/* *
     * Brussels prime meridian
     *
     * @return the brussels
     * @throws Exception the exception
     */
	public class func getBrussels() -> PrimeMeridian { return PrimeMeridian(4.220471, AngularUnit.getDegrees(), "Brussels", "EPSG", 8910, "", "", "") }
	/* *
     * Stockholm prime meridian
     *
     * @return the stockholm
     * @throws Exception the exception
     */
	public class func getStockholm() -> PrimeMeridian { return PrimeMeridian(18.03298, AngularUnit.getDegrees(), "Stockholm", "EPSG", 8911, "", "", "") }
	/* *
     * Athens prime meridian.
     * Used in Greece for older mapping based on Hatt projection.
     *
     * @return the athens
     * @throws Exception the exception
     */
	public class func getAthens() -> PrimeMeridian { return PrimeMeridian(23.4258815, AngularUnit.getDegrees(), "Athens", "EPSG", 8912, "", "", "Used in Greece for older mapping based on Hatt projection.") }
	/* *
     * Oslo prime meridian.
     * Formerly known as Kristiania or Christiania.
     *
     * @return the oslo
     * @throws Exception the exception
     */
	public class func getOslo() -> PrimeMeridian { return PrimeMeridian(10.43225, AngularUnit.getDegrees(), "Oslo", "EPSG", 8913, "", "", "Formerly known as Kristiania or Christiania.") }
	/* *
     * Gets or sets the longitude of the prime meridian (relative to the Greenwich prime meridian).
     */
	public func getLongitude() -> Double { return _Longitude }
	public func setLongitude(value: Double) { _Longitude = value }
	/* *
     * Gets or sets the AngularUnits.
     */
	public func getangularUnit() -> IAngularUnit { return _AngularUnit }
	public func setangularUnit(value: IAngularUnit) { _AngularUnit = value }
	/* *
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "PRIMEM[\"\(getName())\", \(getLongitude())"
		if getAuthority() != "" && getAuthorityCode() > 0 { sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]" }
		sb += "]"
		return sb
	}
	/* *
     * Gets an XML representation of this object
     */
	public override func getXML() -> String { return "<CS_PrimeMeridian Longitude=\"\(getLongitude())\" >\(getInfoXml())\(getangularUnit().getXML())</CS_PrimeMeridian>" }
	/* *
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
    public override func equalParams(obj: Any) -> Bool{
		if !(obj is PrimeMeridian) { return false }
        let prime: PrimeMeridian = obj as! PrimeMeridian
		return prime.getangularUnit().equalParams(obj: self.getangularUnit()) && prime.getLongitude() == self.getLongitude()
	}
}
