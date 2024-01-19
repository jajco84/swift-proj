import Foundation
/// A set of projection parameters
public class ProjectionParameterSet  // extends Dictionary<String, double>
{
	private var _originalNames: [String: String] = Dictionary()
	private var _originalIndex: [Int: String] = Dictionary()
	private var vals: [String: Double] = Dictionary()
	/* *
     * Needed for serialzation
     */
	/*  public ProjectionParameterSet(SerializationInfo info, StreamingContext context) throws Exception {
        super(info, context);
    }*/
	/* *
     * Creates an instance of this class
     *
     * @param parameters An enumeration of paramters
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter]) {
		for pp: ProjectionParameter in parameters {
			let key: String = pp.getName().lowercased()
			_originalNames.updateValue(pp.getName(), forKey: key)  // .put(key, pp.getName());
			_originalIndex.updateValue(key, forKey: _originalIndex.count)  // .put(_originalIndex.size(), key);
			vals.updateValue(pp.getValue(), forKey: key)  // (key, pp.getValue());
		}
	}
	/* *
     * Size int.
     *
     * @return the int
     */
	public func size() -> Int {
		return vals.count  // .size();
	}
	/* *
     * Function to create an enumeration of
     * ProjectionParameter
     * s of the content of this projection parameter set.
     *
     * @return An enumeration of ProjectionParameter s
     * @throws Exception the exception
     */
	public func toProjectionParameter() -> [ProjectionParameter] {
		//    ProjectionParameter pp = new ProjectionParameter();
		// for (int oi : _originalIndex.){
		// }
		var ret: [ProjectionParameter] = Array()
		// var en : Enumeration<Integer> = _originalIndex.keys();
		// while en.hasMoreElements() {
		for (key, _) in _originalIndex {
			// var key : Int = en.nextElement();
			ret.append(ProjectionParameter(_originalNames[_originalIndex[key]!]!, vals[_originalIndex[key]!]!))
		}
		return ret
	}
	/* *
     * Function to get the value of a mandatory projection parameter
     *
     * @param parameterName  or any of                      {@code alternateNames}                      is not defined.
     * @param alternateNames the alternate names
     * @return The value of the parameter
     * @throws Exception the exception
     */
	public func getParameterValue(parameterName: String, alternateNames: String...) -> Double {
		let name: String = parameterName.lowercased()
		if vals[name] == nil {
			for alternateName: String in alternateNames {
				if vals[alternateName.lowercased()] != nil { return vals[alternateName.lowercased()]! }
			}
		}
		return self.vals[name]!
	}
	/* *
     * Method to check if all mandatory projection parameters are passed
     *
     * @param name           the name
     * @param value          the value
     * @param alternateNames the alternate names
     * @return the optional parameter value
     * @throws Exception the exception
     */
	public func getOptionalParameterValue(name: String, _ value: Double, alternateNames: String...) -> Double {
		let nm = name.lowercased()
		if vals[nm] == nil {
            for alternateName: String in alternateNames {
                if vals[alternateName.lowercased()] != nil {
                    return vals[alternateName.lowercased()]!
                }
            }
			return value
		}
 		return vals[nm]!
	}
	// Add(name, value);
	/* *
     * Function to find a parameter based on its name
     *
     * @param name The name of the parameter
     * @return The parameter if present, otherwise null
     * @throws Exception the exception
     */
	public func find(name: String) -> ProjectionParameter? {
		let nm: String = name.lowercased()
        guard let _originalName = _originalNames[nm], let val = self.vals[nm] else { return nil }
        return ProjectionParameter(_originalName, val)
		// return vals[nm] != nil ? ProjectionParameter(_originalNames[nm]!, self.vals[nm]!) : nil
	}
	/* *
     * Function to get the parameter at the given index
     *
     * @param index The index
     * @return The parameter
     * @throws Exception the exception
     */
	public func getAtIndex(index: Int) -> ProjectionParameter? {
//        let name: String? = _originalIndex[index]
//		if name == nil {
//            return nil
//        }
//		return ProjectionParameter(_originalNames[name!]!, self.vals[name!]!)
        let name: String? = _originalIndex[index]
        guard let name else { return nil }
        guard let _originalName = _originalNames[name], let val = self.vals[name] else { return nil }

        return ProjectionParameter(_originalName, val)
	}
	/* *
     * Equals boolean.
     *
     * @param other the other
     * @return the boolean
     */
	public func equals(other: ProjectionParameterSet) -> Bool {
		if other.vals.count != vals.count { return false }
		// for (String key : this.vals.keys())
		// var en : Enumeration<String> = self.vals.keys();
		// while en.hasMoreElements() {
		// var key : String = en.nextElement();
		for (key, _) in vals {
			if other.vals[key] == nil { return false }
			let otherValue: Double = other.getParameterValue(parameterName: key)
			if otherValue != vals[key] { return false }
		}
		return true
	}
	/* *
     * Sets parameter value.
     *
     * @param name  the name
     * @param value the value
     * @throws Exception the exception
     */
	public func setParameterValue(name: String, _ value: Double) {
		let key: String = name.lowercased()
		if vals[key] == nil {
			_originalIndex.updateValue(key, forKey: _originalIndex.count)  // (_originalIndex.size(), key);
			_originalNames.updateValue(name, forKey: key)  // (key, name);
			vals.updateValue(value, forKey: key)  // (key, value);
		} else {
			// vals.removeValue(forKey: key)
			vals.updateValue(value, forKey: key)  // (key, value);
		}
	}
}
