/// Simple class that implements the IParameterInfo interface for providing general set of the parameters.
/// It allows discovering the names, and for setting and getting parameter values.
public class ParameterInfo: IParameterInfo {
	/* *
     * Gets or sets the parameters set for this projection.
     */
	private var __Parameters: [Parameter]? = [Parameter]()
	/* *
     * Gets the number of parameters expected.
     */
	public func getNumParameters() -> Int {
//		if self.getParameters() != nil { return self.getParameters()!.count }
//		return 0
        self.getParameters()?.count ?? 0
	}
    public func getParameters() -> [Parameter]? {
        return __Parameters
    }
    public func setParameters(value: [Parameter]) {
        __Parameters = value
    }
	/* *
     * Returns the default parameters for this projection.
     *
     * @return
     */
	public func defaultParameters() -> [Parameter] { return [Parameter]() }
	/* *
     * Gets the parameter by its name
     *
     * @param name
     * @return
     */
	public func getParameterByName(name: String) -> Parameter? {
//		if self.getParameters() != nil {
//			for param: Parameter in self.getParameters()! {
//				// search parameter collection by name
//				if param.getName() == name { return param }
//			}
//		}
//		return nil
        guard let parameters = self.getParameters() else { return nil }
        for param in parameters {
            // search parameter collection by name
            if param.getName() == name {
                return param
            }
        }

        return nil
	}
}
