/// A 2D cartographic coordinate system.
public class ProjectedCoordinateSystem: HorizontalCoordinateSystem, IProjectedCoordinateSystem {
	private var _GeographicCoordinateSystem: IGeographicCoordinateSystem
	private var _LinearUnit: ILinearUnit
	private var _Projection: IProjection
	/**
     * Initializes a new instance of a projected coordinate system
     *
     * @param datum                      Horizontal datum
     * @param geographicCoordinateSystem Geographic coordinate system
     * @param linearUnit                 Linear unit
     * @param projection                 Projection
     * @param AxisInfo                   Axis info
     * @param name                       Name
     * @param authority                  Authority name
     * @param code                       Authority-specific identification code.
     * @param alias                      Alias
     * @param remarks                    Provider-supplied remarks
     * @param abbreviation               Abbreviation
     * @throws Exception the exception
     */
	public init(_ datum: IHorizontalDatum?, _ geographicCoordinateSystem: IGeographicCoordinateSystem, _ linearUnit: ILinearUnit, _ projection: IProjection, _ AxisInfo: [AxisInfo], _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_GeographicCoordinateSystem = geographicCoordinateSystem
		_LinearUnit = linearUnit
		_Projection = projection
		super.init(datum, AxisInfo, name, authority, code, alias, abbreviation, remarks)
	}
	/**
     * Universal Transverse Mercator - WGS84
     *
     * @param zone        UTM zone
     * @param zoneIsNorth true of Northern hemisphere, false if southern
     * @return UTM /WGS84 coordsys
     * @throws Exception the exception
     */
	public class func wGS84_UTM(zone: Int, _ zoneIsNorth: Bool) -> IProjectedCoordinateSystem {
		var pInfo: [ProjectionParameter] = [ProjectionParameter]()
		pInfo.append(ProjectionParameter("latitude_of_origin", 0))
		pInfo.append(ProjectionParameter("central_meridian", Double(zone * 6 - 183)))
		pInfo.append(ProjectionParameter("scale_factor", 0.9996))
		pInfo.append(ProjectionParameter("false_easting", 500000))
		pInfo.append(ProjectionParameter("false_northing", zoneIsNorth ? 0 : 10_000_000))
		// IProjection projection = cFac.CreateProjection("UTM" + Zone.ToString() + (ZoneIsNorth ? "N" : "S"), "Transverse_Mercator", parameters);
		let proj: Projection = Projection("Transverse_Mercator", pInfo, "UTM" + String(zone) + (zoneIsNorth ? "N" : "S"), "EPSG", 32600 + zone + (zoneIsNorth ? 0 : 100), "", "", "")
		var axes: [AxisInfo] = [AxisInfo]()
		axes.append(AxisInfo("East", AxisOrientationEnum.East))
		axes.append(AxisInfo("North", AxisOrientationEnum.North))
		var zisnorth: String = "S"
		var zz: Int = 100
		if zoneIsNorth {
			zz = 0
			zisnorth = "N"
		}
		return ProjectedCoordinateSystem(HorizontalDatum.getWGS84(), GeographicCoordinateSystem.getWGS84(), LinearUnit.getMetre(), proj, axes, "WGS 84 / UTM zone " + String(zone) + zisnorth, "EPSG", 32600 + zone + zz, "", "Large and medium scale topographic mapping and engineering survey.", "")
	}
	/**
     * Gets a WebMercator coordinate reference system
     *
     * @return the web mercator
     * @throws Exception the exception
     */
	public class func getWebMercator() -> IProjectedCoordinateSystem {
        /*
         new ProjectionParameter("semi_major", 6378137.0),
         new ProjectionParameter("semi_minor", 6378137.0),
         new ProjectionParameter("scale_factor", 1.0),
         */
        var pInfo: [ProjectionParameter] = [ProjectionParameter]()
		pInfo.append(ProjectionParameter("latitude_of_origin", 0.0))
		pInfo.append(ProjectionParameter("central_meridian", 0.0))
		pInfo.append(ProjectionParameter("false_easting", 0.0))
		pInfo.append(ProjectionParameter("false_northing", 0.0))
		let proj: Projection = Projection("Popular Visualisation Pseudo-Mercator", pInfo, "Popular Visualisation Pseudo-Mercator", "EPSG", 3856, "Pseudo-Mercator", "", "")
		var axes: [AxisInfo] = [AxisInfo]()
		axes.append(AxisInfo("East", AxisOrientationEnum.East))
		axes.append(AxisInfo("North", AxisOrientationEnum.North))
		return ProjectedCoordinateSystem(HorizontalDatum.getWGS84(), GeographicCoordinateSystem.getWGS84(), LinearUnit.getMetre(), proj, axes, "WGS 84 / Pseudo-Mercator", "EPSG", 3857, "WGS 84 / Popular Visualisation Pseudo-Mercator", "Certain Web mapping and visualisation applications." + "Uses spherical development of ellipsoidal coordinates. Relative to an ellipsoidal development errors of up to 800 metres in position and 0.7 percent in scale may arise. It is not a recognised geodetic system: see WGS 84 / World Mercator (CRS code 3395).", "WebMercator")
	}
	/**
     * Gets or sets the GeographicCoordinateSystem.
     */
	public func getGeographicCoordinateSystem() -> IGeographicCoordinateSystem { return _GeographicCoordinateSystem }
	public func setGeographicCoordinateSystem(value: IGeographicCoordinateSystem) { _GeographicCoordinateSystem = value }
	/**
     * Gets or sets the
     * {@link LinearUnit}
     * . The linear unit must be the same as the
     *CoordinateSystem
     * units.
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
     * Gets or sets the projection
     */
	public func getProjection() -> IProjection { return _Projection }
	public func setProjection(value: IProjection) { _Projection = value }
	/* *
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "PROJCS[\"\(getName())\", \(getGeographicCoordinateSystem().getWKT()), \(getLinearUnit().getWKT()), \(getProjection().getWKT())"
        for i in 0...getProjection().getNumParameters() {
            sb += ", \(getProjection().getParameter(index: i)!.getWKT())"
        }
		// sb.AppendFormat(", {0}", LinearUnit.WKT);
		// Skip authority and code if not defined
        if !getAuthority().isEmpty && getAuthorityCode() > 0 {
            sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]"
        }
		// Skip axis info if they contain default values
		if getAxisInfo().count != 2 || getAxisInfo()[0].getName() != "X" || getAxisInfo()[0].getOrientation() != AxisOrientationEnum.East || getAxisInfo()[1].getName() != "Y" || getAxisInfo()[1].getOrientation() != AxisOrientationEnum.North { for i in 0...getAxisInfo().count - 1 { sb += ", \(getAxis(dimension: i).getWKT())" } }
		// if (!String.IsNullOrEmpty(Authority) && AuthorityCode > 0)
		//    sb.AppendFormat(", AUTHORITY[\"{0}\", \"{1}\"]", Authority, AuthorityCode);
		sb.append("]")
		return sb
	}
	/* *
     * Gets an XML representation of this object.
     */
	public override func getXML() -> String {
		var sb: String
		sb = "<CS_CoordinateSystem Dimension=\"\(getDimension())\"><CS_ProjectedCoordinateSystem>\(getInfoXml())"
		for ai: AxisInfo in self.getAxisInfo() { sb.append(ai.getXML()) }
		sb += "\(getGeographicCoordinateSystem().getXML())\(getLinearUnit().getXML())\(getProjection().getXML())</CS_ProjectedCoordinateSystem></CS_CoordinateSystem>"
		return sb
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
//		if !(obj is ProjectedCoordinateSystem) { return false }
//		let pcs: ProjectedCoordinateSystem = obj as! ProjectedCoordinateSystem
        guard let pcs = obj as? ProjectedCoordinateSystem else { return false }
		if pcs.getDimension() != self.getDimension() { return false }
		for i in 0...pcs.getDimension() - 1 {
			if pcs.getAxis(dimension: i).getOrientation() != self.getAxis(dimension: i).getOrientation() { return false }
			if !pcs.getUnits(dimension: i).equalParams(obj: self.getUnits(dimension: i)) { return false }
		}
        return pcs.getGeographicCoordinateSystem().equalParams(obj: self.getGeographicCoordinateSystem()) && pcs.getHorizontalDatum()!.equalParams(obj: self.getHorizontalDatum()!) && pcs.getLinearUnit().equalParams(obj: self.getLinearUnit()) && pcs.getProjection().equalParams(obj: self.getProjection())
	}
}
