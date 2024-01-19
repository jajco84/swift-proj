/// A 2D coordinate system suitable for positions on the Earth's surface.
public class HorizontalCoordinateSystem: CoordinateSystem, IHorizontalCoordinateSystem {
	private var _HorizontalDatum: IHorizontalDatum?
	/**
     * Creates an instance of HorizontalCoordinateSystem
     *
     * @param datum        Horizontal datum
     * @param AxisInfo     Axis information
     * @param name         Name
     * @param authority    Authority name
     * @param code         Authority-specific identification code.
     * @param alias        Alias
     * @param remarks      Provider-supplied remarks
     * @param abbreviation Abbreviation
     * @throws Exception the exception
     */
	public init(_ datum: IHorizontalDatum?, _ AxisInfo: [AxisInfo], _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_HorizontalDatum = datum
		//if (AxisInfo.count != 2)
		//    throwException() /* throw IllegalArgumentException("Axis info should contain two axes for horizontal coordinate systems"); */
		super.init(name, authority, code, alias, abbreviation, remarks)
		super.setAxisInfo(value: AxisInfo)
	}
	/**
     * Gets or sets the HorizontalDatum.
     */
	public func getHorizontalDatum() -> IHorizontalDatum? { return _HorizontalDatum }
	public func setHorizontalDatum(value: IHorizontalDatum) { _HorizontalDatum = value }
}
