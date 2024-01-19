/// A named parameter value.
public class Parameter {
	private var _Name: String = String()
	private var _Value: Double
	/**
     * Creates an instance of a parameter
     * Units are always either meters or degrees.
     *
     * @param name  Name of parameter
     * @param value Value
     * @throws Exception the exception
     */
	public init(_ name: String, _ value: Double) {
		_Name = name
		_Value = value
	}
	/**
     * Parameter name
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
     * Parameter value
     *
     * @return the value
     * @throws Exception the exception
     */
	public func getValue() -> Double { return _Value }
	/**
     * Sets value.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setValue(value: Double) { _Value = value }
}
