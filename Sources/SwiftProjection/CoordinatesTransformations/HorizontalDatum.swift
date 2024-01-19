/// Horizontal datum defining the standard datum information.
public class HorizontalDatum: Datum, IHorizontalDatum {
	/**
     * The Ellipsoid.
     */
	var _Ellipsoid: IEllipsoid
	/**
     * The Wgs 84 conversion info.
     */
	var _Wgs84ConversionInfo: Wgs84ConversionInfo? = Wgs84ConversionInfo()
	/**
     * Initializes a new instance of a horizontal datum
     *
     * @param ellipsoid    Ellipsoid
     * @param toWgs84      Parameters for a Bursa Wolf transformation into WGS84
     * @param type         Datum type
     * @param name         Name
     * @param authority    Authority name
     * @param code         Authority-specific identification code.
     * @param alias        Alias
     * @param remarks      Provider-supplied remarks
     * @param abbreviation Abbreviation
     * @throws Exception the exception
     */
	public init(_ ellipsoid: IEllipsoid, _ toWgs84: Wgs84ConversionInfo?, _ type: DatumType, _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_Ellipsoid = ellipsoid
		_Wgs84ConversionInfo = toWgs84
		super.init(type, name, authority, code, alias, remarks, abbreviation)
	}
	/**
     * EPSG's WGS 84 datum has been the then current realisation. No distinction is made between the original WGS 84
     * frame, WGS 84 (G730), WGS 84 (G873) and WGS 84 (G1150). since 1997, WGS 84 has been maintained within 10cm of
     * the then current ITRF.
     * Area of use: WorldOrigin description: Defined through a consistent set of station coordinates. These have changed with time: by 0.7m
     * on 29/6/1994 [WGS 84 (G730)], a further 0.2m on 29/1/1997 [WGS 84 (G873)] and a further 0.06m on
     * 20/1/2002 [WGS 84 (G1150)].
     *
     * @return the wgs 84
     * @throws Exception the exception
     */
	public class func getWGS84() -> HorizontalDatum { return HorizontalDatum(Ellipsoid.getWGS84(), nil, DatumType.HD_Geocentric, "World Geodetic System 1984", "EPSG", 6326, "", "EPSG's WGS 84 datum has been the then current realisation. No distinction is made between the original WGS 84 frame, WGS 84 (G730), WGS 84 (G873) and WGS 84 (G1150). since 1997, WGS 84 has been maintained within 10cm of the then current ITRF.", "") }
	/**
     * World Geodetic System 1972
     * Used by GPS before 1987. For Transit satellite positioning see also WGS 72BE. Datum code 6323 reserved for southern hemisphere ProjCS's.Area of use: WorldOrigin description: Developed from a worldwide distribution of terrestrial and
     * geodetic satellite observations and defined through a set of station coordinates.
     *
     * @return the wgs 72
     * @throws Exception the exception
     */
	public class func getWGS72() -> HorizontalDatum {
		let datum: HorizontalDatum = HorizontalDatum(Ellipsoid.getWGS72(), nil, DatumType.HD_Geocentric, "World Geodetic System 1972", "EPSG", 6322, "", "Used by GPS before 1987. For Transit satellite positioning see also WGS 72BE. Datum code 6323 reserved for southern hemisphere ProjCS's.", "")
		datum.setWgs84Parameters(value: Wgs84ConversionInfo(0, 0, 4.5, 0, 0, 0.554, 0.219))
		return datum
	}
	/**
     * European Terrestrial Reference System 1989
     * Area of use:
     * Europe: Albania; Andorra; Austria; Belgium; Bosnia and Herzegovina; Bulgaria; Croatia;
     * Cyprus; Czech Republic; Denmark; Estonia; Finland; Faroe Islands; France; Germany; Greece;
     * Hungary; Ireland; Italy; Latvia; Liechtenstein; Lithuania; Luxembourg; Malta; Netherlands;
     * Norway; Poland; Portugal; Romania; San Marino; Serbia and Montenegro; Slovakia; Slovenia;
     * Spain; Svalbard; Sweden; Switzerland; United Kingdom (UK) including Channel Islands and
     * Isle of Man; Vatican City State.Origin description: Fixed to the stable part of the Eurasian continental
     * plate and consistent with ITRS at the epoch 1989.0.
     *
     * @return the etrf 89
     * @throws Exception the exception
     */
	public class func getETRF89() -> HorizontalDatum {
		let datum: HorizontalDatum = HorizontalDatum(Ellipsoid.getGRS80(), nil, DatumType.HD_Geocentric, "European Terrestrial Reference System 1989", "EPSG", 6258, "ETRF89", "The distinction in usage between ETRF89 and ETRS89 is confused: although in principle conceptually different in practice both are used for the realisation.", "")
		datum.setWgs84Parameters(value: Wgs84ConversionInfo())
		return datum
	}
	/**
     * European Datum 1950
     * Area of use:
     * Europe - west - Denmark; Faroe Islands; France offshore; Israel offshore; Italy including San
     * Marino and Vatican City State; Ireland offshore; Netherlands offshore; Germany; Greece (offshore);
     * North Sea; Norway; Spain; Svalbard; Turkey; United Kingdom UKCS offshore. Egypt - Western Desert.
     * Origin description: Fundamental point: Potsdam (Helmert Tower).
     * Latitude: 52 deg 22 min 51.4456 sec N; Longitude: 13 deg  3 min 58.9283 sec E (of Greenwich).
     *
     * @return the ed 50
     * @throws Exception the exception
     */
	public class func getED50() -> HorizontalDatum { return HorizontalDatum(Ellipsoid.getInternational1924(), Wgs84ConversionInfo(-87, -98, -121, 0, 0, 0, 0), DatumType.HD_Geocentric, "European Datum 1950", "EPSG", 6230, "ED50", "", "") }
	/**
     * Gets or sets the ellipsoid of the datum
     */
	public func getEllipsoid() -> IEllipsoid { return _Ellipsoid }
	public func setEllipsoid(value: IEllipsoid) { _Ellipsoid = value }
	/**
     * Gets preferred parameters for a Bursa Wolf transformation into WGS84
     */
	public func getWgs84Parameters() -> Wgs84ConversionInfo? { return _Wgs84ConversionInfo }
	public func setWgs84Parameters(value: Wgs84ConversionInfo) { _Wgs84ConversionInfo = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "DATUM[\"\(getName())\", \(_Ellipsoid.getWKT())"
		if _Wgs84ConversionInfo != nil { sb += ", \(_Wgs84ConversionInfo?.getWKT() ?? "")" }
		if getAuthority() != "" && getAuthorityCode() > 0 { sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]" }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String { return "<CS_HorizontalDatum DatumType=\"\(getDatumType())\">\(getInfoXml())\(getEllipsoid().getXML())\(getWgs84Parameters()?.getXML() ?? "")</CS_HorizontalDatum>" }
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public override func equalParams(obj: Any) -> Bool {
		if !(obj is HorizontalDatum) { return false }
		let datum: HorizontalDatum = obj as! HorizontalDatum
		if datum.getWgs84Parameters() == nil && self.getWgs84Parameters() != nil {
            return false
        }
		if datum.getWgs84Parameters() != nil && !datum.getWgs84Parameters()!.equals(obj: self.getWgs84Parameters()) { return false
            
        }
		return (datum.getEllipsoid().equalParams(obj: self.getEllipsoid())) && self.getDatumType() == datum.getDatumType()
	}
}
