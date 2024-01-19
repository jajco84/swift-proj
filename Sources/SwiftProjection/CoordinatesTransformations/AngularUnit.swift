public class AngularUnit: Info, IAngularUnit {
    /* *
     * Equality tolerance value. Values with a difference less than this are considered equal.
     */
    var EqualityTolerance: Double = 2.0e-17
    var _RadiansPerUnit: Double

    /* *
     * Initializes a new instance of a angular unit
     *
     * @param radiansPerUnit Radians per unit
     * @throws Exception the exception
     */
    public convenience init(_ radiansPerUnit: Double) {
        self.init(radiansPerUnit, "", "", -1, "", "", "")
    }

    /* *
     * Initializes a new instance of a angular unit
     *
     * @param radiansPerUnit Radians per unit
     * @param name           Name
     * @param authority      Authority name
     * @param authorityCode  Authority-specific identification code.
     * @param alias          Alias
     * @param abbreviation   Abbreviation
     * @param remarks        Provider-supplied remarks
     * @throws Exception the exception
     */
    public init(_ radiansPerUnit: Double, _ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
        _RadiansPerUnit = radiansPerUnit
        super.init(name, authority, authorityCode, alias, abbreviation, remarks)
    }

    /* *
     * The angular degrees are PI/180 = 0.017453292519943295769236907684886 radians
     *
     * @return the degrees
     * @throws Exception the exception
     */
    public class func getDegrees() -> AngularUnit {
        return AngularUnit(0.017453292519943295769236907684886, "degree", "EPSG", 9102, "deg", "", "=pi/180 radians")
    }

    /* *
     * SI standard unit
     *
     * @return the radian
     * @throws Exception the exception
     */
    public class func getRadian() -> AngularUnit {
        return AngularUnit(1, "radian", "EPSG", 9101, "rad", "", "SI standard unit.")
    }

    /* *
     * Pi / 200 = 0.015707963267948966192313216916398 radians
     *
     * @return the grad
     * @throws Exception the exception
     */
    public class func getGrad() -> AngularUnit {
        return AngularUnit(0.015707963267948966192313216916398, "grad", "EPSG", 9105, "gr", "", "=pi/200 radians.")
    }

    /* *
     * Pi / 200 = 0.015707963267948966192313216916398 radians
     *
     * @return the gon
     * @throws Exception the exception
     */
    public class func getGon() -> AngularUnit {
        return AngularUnit(0.015707963267948966192313216916398, "gon", "EPSG", 9106, "g", "", "=pi/200 radians.")
    }

    /* *
     * Gets or sets the number of radians per
     * {@link #AngularUnit}
     * .
     */
    public func getRadiansPerUnit() -> Double { return _RadiansPerUnit }
    public func setRadiansPerUnit(value: Double) { _RadiansPerUnit = value }

    /* *
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
    public override func getWKT() -> String {
        var sb: String
        sb = "UNIT[\"\(getName())\", \(getRadiansPerUnit())"
        if !getAuthority().isEmpty && getAuthorityCode() > 0 {
            sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]"
        }
        sb += "]"
        return sb
    }

    /* *
     * Gets an XML representation of this object.
     */
    public override func getXML() -> String {
        return "<CS_AngularUnit RadiansPerUnit=\"\(getRadiansPerUnit())\">\(getInfoXml())</CS_AngularUnit>"
    }

    /* *
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
    public override func equalParams(obj: Any) -> Bool {
        guard let au = obj as? AngularUnit else { return false }
        return abs(au.getRadiansPerUnit() - self.getRadiansPerUnit()) < EqualityTolerance
        //		if !(obj is AngularUnit) { return false }
        //		return abs((obj as! AngularUnit).getRadiansPerUnit() - self.getRadiansPerUnit()) < EqualityTolerance
    }
}
