// A 3D coordinate system, with its origin at the center of the Earth.
public class GeocentricCoordinateSystem: CoordinateSystem, IGeocentricCoordinateSystem {
	private var _HorizontalDatum: IHorizontalDatum
	private var _LinearUnit: ILinearUnit
	private var _Primemeridan: IPrimeMeridian
	/**
     * Instantiates a new Geocentric coordinate system.
     *
     * @param datum         the datum
     * @param linearUnit    the linear unit
     * @param primeMeridian the prime meridian
     * @param AxisInfo      the axis info
     * @param name          the name
     * @param authority     the authority
     * @param code          the code
     * @param alias         the alias
     * @param remarks       the remarks
     * @param abbreviation  the abbreviation
     * @throws Exception the exception
     */
	public init(_ datum: IHorizontalDatum, _ linearUnit: ILinearUnit, _ primeMeridian: IPrimeMeridian, _ AxisInfo: [AxisInfo], _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_HorizontalDatum = datum
		_LinearUnit = linearUnit
		_Primemeridan = primeMeridian
		// if (AxisInfo.size() != 3)
		//   throwException() /* throw IllegalArgumentException("Axis info should contain three axes for geocentric coordinate systems"); */
		super.init(name, authority, code, alias, abbreviation, remarks)
		setAxisInfo(value: AxisInfo)
	}
	/**
     * Creates a geocentric coordinate system based on the WGS84 ellipsoid, suitable for GPS measurements
     *
     * @return the wgs 84
     * @throws Exception the exception
     */
    public class func getWGS84() -> IGeocentricCoordinateSystem {
        return CoordinateSystemFactory().createGeocentricCoordinateSystem(name: "WGS84 Geocentric", HorizontalDatum.getWGS84() as! ILinearUnit as! IHorizontalDatum, LinearUnit.getMetre() as! IPrimeMeridian as! ILinearUnit, PrimeMeridian.getGreenwich())!
    }
	/**
     * Returns the HorizontalDatum. The horizontal datum is used to determine where
     * the centre of the Earth is considered to be. All coordinate points will be
     * measured from the centre of the Earth, and not the surface.
     */
	public func getHorizontalDatum() -> IHorizontalDatum { return _HorizontalDatum }
	public func setHorizontalDatum(value: IHorizontalDatum) { _HorizontalDatum = value }
	/**
     * Gets the units used along all the axes.
     */
	public func getLinearUnit() -> ILinearUnit { return _LinearUnit }
	public func setLinearUnit(value: ILinearUnit) { _LinearUnit = value }
	/**
     * Gets units for dimension within coordinate system. Each dimension in
     * the coordinate system has corresponding units.
     *
     * @param dimension Dimension
     * @return Unit
     */
	public override func getUnits(dimension: Int) -> IUnit { return _LinearUnit }
	/**
     * Returns the PrimeMeridian.
     */
	public func getPrimeMeridian() -> IPrimeMeridian { return _Primemeridan }
	public func setPrimeMeridian(value: IPrimeMeridian) { _Primemeridan = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		/*var sb : StringBuilder = StringBuilder();
        sb.append(String.format("GEOCCS[\"%s\", %s, %s, %s", getName(), getHorizontalDatum().getWKT(), getPrimeMeridian().getWKT(), getLinearUnit().getWKT()));
        //Skip axis info if they contain default values
        if (getAxisInfo().size() != 3 || !getAxisInfo().get(0).getName().equals("X") || getAxisInfo().get(0).getOrientation() != AxisOrientationEnum.Other || !getAxisInfo().get(1).getName().equals("Y") || getAxisInfo().get(1).getOrientation() != AxisOrientationEnum.East || !getAxisInfo().get(2).getName().equals("Z") || getAxisInfo().get(2).getOrientation() != AxisOrientationEnum.North)
            for  var i : Int = 0; i < getAxisInfo().size(); i++
                { sb.append(String.format(", %s", getAxis(i).getWKT())); }

        if (getAuthority() != nil && getAuthority() != "" && getAuthorityCode() > 0)
            sb.append(String.format(", AUTHORITY[\"%s\", \"%d\"]", getAuthority(), getAuthorityCode()));

        sb.append("]");
        return sb.toString();*/
		return ""
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String { /*var sb : StringBuilder = StringBuilder();
        sb.append(String.format("<CS_CoordinateSystem Dimension=\"%d\"><CS_GeocentricCoordinateSystem>%s", self.getDimension(), getInfoXml()));
        for ai : AxisInfo in self.getAxisInfo() {
            sb.append(ai.getXML());
        }
        sb.append(String.format("%s%s%s</CS_GeocentricCoordinateSystem></CS_CoordinateSystem>", getHorizontalDatum().getXML(), getLinearUnit().getXML(), getPrimeMeridian().getXML()));
        return sb.toString();*/ return "" }
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
    public override func equalParams(obj: Any) -> Bool {
        if !(obj is GeocentricCoordinateSystem) { return false }
        let gcc: GeocentricCoordinateSystem = obj as! GeocentricCoordinateSystem
        return gcc.getHorizontalDatum().equalParams(obj: self.getHorizontalDatum()) && gcc.getLinearUnit().equalParams(obj: self.getLinearUnit()) && gcc.getPrimeMeridian().equalParams(obj: self.getPrimeMeridian())
    }
}
