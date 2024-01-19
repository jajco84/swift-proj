/// A named projection parameter value.
/// *
/// The linear units of parameters' values match the linear units of the containing
/// projected coordinate system. The angular units of parameter values match the
/// angular units of the geographic coordinate system that the projected coordinate
/// system is based on. (Notice that this is different from
/// {@link Parameter}
/// ,
/// where the units are always meters and degrees.)
public class ProjectionParameter {
	private var _Name: String = String()
	private var _Value: Double
	/**
     * Initializes an instance of a ProjectionParameter
     *
     * @param name  Name of parameter
     * @param value Parameter value
     * @throws Exception the exception
     */
	public init(_ name: String, _ value: Double) {
		_Name = name
		_Value = value
	}
	public init(_ name: String, _ value: Int) {
		_Name = name
		_Value = Double(value)
	}
	/**
     * Parameter name.
     *
     * @return the name
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
     * Parameter value.
     * The linear units of a parameters' values match the linear units of the containing
     * projected coordinate system. The angular units of parameter values match the
     * angular units of the geographic coordinate system that the projected coordinate
     * system is based on.
     *
     * @return the value
     */
	public func getValue() -> Double { return _Value }
	/**
     * Sets value.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setValue(value: Double) { _Value = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     *
     * @return the wkt
     * @throws Exception the exception
     */
	public func getWKT() -> String {
		return "PARAMETER[\"\(getName())\", \(getValue())]"
	}
	/**
     * Gets an XML representation of this object
     *
     * @return the xml
     * @throws Exception the exception
     */
	public func getXML() -> String { return "<CS_ProjectionParameter Name=\"\(getName())\" Value=\"\(getValue())\"/>" }
	/**
     * Function to get a textual representation of this envelope
     *
     * @return A textual representation of this envelope
     */
	public func toString() -> String {
		return "ProjectionParameter '\(getName())': \(getValue())"
	}
}
