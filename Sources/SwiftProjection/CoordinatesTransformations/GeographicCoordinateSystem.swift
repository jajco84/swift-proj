/// A coordinate system based on latitude and longitude.
/// *
/// Some geographic coordinate systems are Lat/Lon, and some are Lon/Lat.
/// You can find out which this is by examining the axes. You should also
/// check the angular units, since not all geographic coordinate systems
/// use degrees.
public class GeographicCoordinateSystem: HorizontalCoordinateSystem, IGeographicCoordinateSystem {
	private var _AngularUnit: IAngularUnit
	private var _PrimeMeridian: IPrimeMeridian
	private var _WGS84ConversionInfo: [Wgs84ConversionInfo] = [Wgs84ConversionInfo]()
	/**
     * Creates an instance of a Geographic Coordinate System
     *
     * @param angularUnit     Angular units
     * @param horizontalDatum Horizontal datum
     * @param primeMeridian   Prime meridian
     * @param AxisInfo        Axis info
     * @param name            Name
     * @param authority       Authority name
     * @param authorityCode   Authority-specific identification code.
     * @param alias           Alias
     * @param abbreviation    Abbreviation
     * @param remarks         Provider-supplied remarks
     * @throws Exception the exception
     */
	public init(_ angularUnit: IAngularUnit, _ horizontalDatum: IHorizontalDatum, _ primeMeridian: IPrimeMeridian, _ AxisInfo: [AxisInfo], _ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_AngularUnit = angularUnit
		_PrimeMeridian = primeMeridian
		super.init(horizontalDatum, AxisInfo, name, authority, authorityCode, alias, abbreviation, remarks)
	}
	/**
     * Creates a decimal degrees geographic coordinate system based on the WGS84 ellipsoid, suitable for GPS measurements
     *
     * @return the wgs 84
     * @throws Exception the exception
     */
	public class func getWGS84() -> IGeographicCoordinateSystem {
		var axes: [AxisInfo] = [AxisInfo]()
		axes.append(AxisInfo("Lon", AxisOrientationEnum.East))
		axes.append(AxisInfo("Lat", AxisOrientationEnum.North))
		return GeographicCoordinateSystem(AngularUnit.getDegrees(), HorizontalDatum.getWGS84(), PrimeMeridian.getGreenwich(), axes, "WGS 84", "EPSG", 4326, "", "", "")
	}
	/**
     * Gets or sets the angular units of the geographic coordinate system.
     */
	public func getangularUnit() -> IAngularUnit { return _AngularUnit }
	public func setangularUnit(value: IAngularUnit) { _AngularUnit = value }
	/**
     * Gets units for dimension within coordinate system. Each dimension in
     * the coordinate system has corresponding units.
     *
     * @param dimension Dimension
     * @return Unit
     */
	public override func getUnits(dimension: Int) -> IUnit { return _AngularUnit }
	/**
     * Gets or sets the prime meridian of the geographic coordinate system.
     */
	public func getPrimeMeridian() -> IPrimeMeridian { return _PrimeMeridian }
	public func setPrimeMeridian(value: IPrimeMeridian) { _PrimeMeridian = value }
	/**
     * Gets the number of available conversions to WGS84 coordinates.
     */
	public func getNumConversionToWGS84() -> Int { return _WGS84ConversionInfo.count }
	/**
     * Gets wgs 84 conversion info.
     *
     * @return the wgs 84 conversion info
     * @throws Exception the exception
     */
	public func getWGS84ConversionInfo() -> [Wgs84ConversionInfo] { return _WGS84ConversionInfo }
	/**
     * Sets wgs 84 conversion info.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setWGS84ConversionInfo(value: [Wgs84ConversionInfo]) { _WGS84ConversionInfo = value }
	/**
     * Gets details on a conversion to WGS84.
     */
	public func getWgs84ConversionInfo(index: Int) -> Wgs84ConversionInfo {
		return _WGS84ConversionInfo[index]  // .get(index);
	}
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "GEOGCS[\"\(getName())\", \(getHorizontalDatum()!.getWKT()), \(getPrimeMeridian().getWKT()), \(getangularUnit().getWKT())"
		// Skip axis info if they contain default values
		if getAxisInfo().count != 2 || getAxisInfo()[0].getName() != "Lon" || getAxisInfo()[0].getOrientation() != AxisOrientationEnum.East || getAxisInfo()[1].getName() != "Lat" || getAxisInfo()[1].getOrientation() != AxisOrientationEnum.North {
			for ai in getAxisInfo()  // : Int = 0; i < getAxisInfo().size(); i++
			{ sb += ", \(ai.getWKT())" }
		}
        if !getAuthority().isEmpty && getAuthorityCode() > 0 {
            sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]"
        }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String {
		var sb: String
		sb = "<CS_CoordinateSystem Dimension=\"\(getDimension())\"><CS_GeographicCoordinateSystem>\(getInfoXml())"
		for ai in self.getAxisInfo() {
			sb += ai.getXML()
		}
		sb += "\(getHorizontalDatum()!.getXML())\(getangularUnit().getXML())\(getPrimeMeridian().getXML())</CS_GeographicCoordinateSystem></CS_CoordinateSystem>"
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
	public override func equalParams(obj: Any) -> Bool {
		if !(obj is GeographicCoordinateSystem) { return false }
		let gcs: GeographicCoordinateSystem = obj as! GeographicCoordinateSystem
		if gcs.getDimension() != self.getDimension() { return false }
		
	
			if self.getWGS84ConversionInfo().count != gcs.getWGS84ConversionInfo().count {
                return false
            }
            
            
			for i in 0..<getWGS84ConversionInfo().count {
                if !gcs.getWGS84ConversionInfo()[i].equals(obj: self.getWGS84ConversionInfo()[i]) {
                    return false
                }
            }
		
		if self.getAxisInfo().count != gcs.getAxisInfo().count { return false }
        for i in 0..<gcs.getAxisInfo().count {
            if gcs.getAxisInfo()[i].getOrientation() != self.getAxisInfo()[i].getOrientation() { return false }
        }
        return gcs.getangularUnit().equalParams(obj: self.getangularUnit()) && gcs.getHorizontalDatum()!.equalParams(obj: self.getHorizontalDatum()!) && gcs.getPrimeMeridian().equalParams(obj: self.getPrimeMeridian())
	}
}
