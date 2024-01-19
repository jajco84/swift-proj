/// The IParameterInfo interface provides an interface through which clients of a
/// Projected Coordinate System or of a Projection can set the parameters of the
/// projection. It provides a generic interface for discovering the names and default
/// values of parameters, and for setting and getting parameter values. Subclasses of
/// this interface may provide projection specific parameter access methods.
public protocol IParameterInfo {
	/**
     * Gets the number of parameters expected.
     *
     * @return the num parameters
     * @throws Exception the exception
     */
	func getNumParameters() -> Int
	/**
     * Returns the default parameters for this projection.
     *
     * @return parameter [ ]
     * @throws Exception the exception
     */
	func defaultParameters() -> [Parameter]
	/**
     * Gets or sets the parameters set for this projection.
     *
     * @return the parameters
     * @throws Exception the exception
     */
	func getParameters() -> [Parameter]?
	/**
     * Sets parameters.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setParameters(value: [Parameter])
	/**
     * Gets the parameter by its name
     *
     * @param name the name
     * @return parameter by name
     * @throws Exception the exception
     */
	func getParameterByName(name: String) -> Parameter?
}
