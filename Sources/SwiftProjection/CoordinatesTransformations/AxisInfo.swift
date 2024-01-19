/// Details of axis. This is used to label axes, and indicate the orientation.
public class AxisInfo {
	private var _Name: String
	private var _Orientation: AxisOrientationEnum = AxisOrientationEnum.Other
	/**
     * Initializes a new instance of an AxisInfo.
     *
     * @param name        Name of axis
     * @param orientation Axis orientation
     * @throws Exception the exception
     */
	public init(_ name: String, _ orientation: AxisOrientationEnum) {
		_Name = name
		_Orientation = orientation
	}
	/**
     * Human readable name for axis. Possible values are X, Y, Long, Lat or any other short string.
     *
     * @return the name
     * @throws Exception the exception
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
     * Gets enumerated value for orientation.
     *
     * @return the orientation
     * @throws Exception the exception
     */
	public func getOrientation() -> AxisOrientationEnum { return _Orientation }
	/**
     * Sets orientation.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setOrientation(value: AxisOrientationEnum) { _Orientation = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     *
     * @return the wkt
     * @throws Exception the exception
     */
	public func getWKT() -> String { return "AXIS[\"\(getName())\", \(getOrientation())]" }
	/**
     * Gets an XML representation of this object
     *
     * @return the xml
     * @throws Exception the exception
     */
	public func getXML() -> String { return "<CS_AxisInfo Name=\"\(getName())\" Orientation=\"\(getOrientation())\"/>" }
}
