/// Base interface for all coordinate systems.
/// A coordinate system is a mathematical space, where the elements of the space
/// are called positions. Each position is described by a list of numbers. The length
/// of the list corresponds to the dimension of the coordinate system. So in a 2D
/// coordinate system each position is described by a list containing 2 numbers.However, in a coordinate system, not all lists of numbers correspond to a
/// position - some lists may be outside the domain of the coordinate system. For
/// example, in a 2D Lat/Lon coordinate system, the list (91,91) does not correspond
/// to a position.Some coordinate systems also have a mapping from the mathematical space into
/// locations in the real world. So in a Lat/Lon coordinate system, the mathematical
/// position (lat, long) corresponds to a location on the surface of the Earth. This
/// mapping from the mathematical space into real-world locations is called a Datum.
public class CoordinateSystem: Info, ICoordinateSystem {
	private var _AxisInfo: [AxisInfo] = [AxisInfo]()
	private var _DefaultEnvelope: [Double]
	/**
     * Initializes a new instance of a coordinate system.
     *
     * @param name          Name
     * @param authority     Authority name
     * @param authorityCode Authority-specific identification code.
     * @param alias         Alias
     * @param abbreviation  Abbreviation
     * @param remarks       Provider-supplied remarks
     * @throws Exception the exception
     */
	public override init(_ name: String, _ authority: String, _ authorityCode: Int, _ alias: String, _ abbreviation: String, _ remarks: String) {
		_DefaultEnvelope = [Double]()
		super.init(name, authority, authorityCode, alias, abbreviation, remarks)
	}
	/**
     * Dimension of the coordinate system.
     */
	public func getDimension() -> Int { return _AxisInfo.count }
	/**
     * Gets the units for the dimension within coordinate system.
     * Each dimension in the coordinate system has corresponding units.
     */
	public func getUnits(dimension: Int) -> IUnit { preconditionFailure("This method must be overridden") }
	/**
     * Gets axis info.
     *
     * @return the axis info
     * @throws Exception the exception
     */
	public func getAxisInfo() -> [AxisInfo] { return _AxisInfo }
	/**
     * Sets axis info.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setAxisInfo(value: [AxisInfo]) { _AxisInfo = value }
	/**
     * Gets axis details for dimension within coordinate system.
     *
     * @param dimension Dimension
     * @return Axis info
     */
	public func getAxis(dimension: Int) -> AxisInfo {
		if dimension >= _AxisInfo.count || dimension < 0 {
			//   throwException() /* throw IllegalArgumentException("AxisInfo not available for dimension " + dimension); */
		}
		return _AxisInfo[dimension]
	}
	/**
     * Gets default envelope of coordinate system.
     *
     * Coordinate systems which are bounded should return the minimum bounding box of their domain.
     * Unbounded coordinate systems should return a box which is as large as is likely to be used.
     * For example, a (lon,lat) geographic coordinate system in degrees should return a box from
     * (-180,-90) to (180,90), and a geocentric coordinate system could return a box from (-r,-r,-r)
     * to (+r,+r,+r) where r is the approximate radius of the Earth.
     */
	public func getDefaultEnvelope() -> [Double] { return _DefaultEnvelope }
	/**
     * Sets default envelope.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setDefaultEnvelope(value: [Double]) { _DefaultEnvelope = value }
}
