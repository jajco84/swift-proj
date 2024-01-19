/// The Projection class defines the standard information stored with a projection
/// objects. A projection object implements a coordinate transformation from a geographic
/// coordinate system to a projected coordinate system, given the ellipsoid for the
/// geographic coordinate system. It is expected that each coordinate transformation of
/// interest, e.g., Transverse Mercator, Lambert, will be implemented as a class of
/// type Projection, supporting the IProjection interface.
public class Projection: Info, IProjection {
	private var _parameters: [ProjectionParameter] = [ProjectionParameter]()
	private var _ClassName: String = String()
	/**
     * Instantiates a new Projection.
     *
     * @param className    the class name
     * @param parameters   the parameters
     * @param name         the name
     * @param authority    the authority
     * @param code         the code
     * @param alias        the alias
     * @param remarks      the remarks
     * @param abbreviation the abbreviation
     * @throws Exception the exception
     */
	init(_ className: String, _ parameters: [ProjectionParameter], _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_parameters = parameters
		_ClassName = className
		super.init(name, authority, code, alias, abbreviation, remarks)
	}
	/**
     * Gets the number of parameters of the projection.
     */
	public func getNumParameters() -> Int { return _parameters.count }
	/**
     * Gets or sets the parameters of the projection
     *
     * @return the parameters
     * @throws Exception the exception
     */
	public func getParameters() -> [ProjectionParameter] { return _parameters }
	/**
     * Sets parameters.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setParameters(value: [ProjectionParameter]) { _parameters = value }
	/**
     * Gets an indexed parameter of the projection.
     *
     * @param index Index of parameter
     * @return n'th parameter
     */
	public func getParameter(index: Int) -> ProjectionParameter? { return _parameters[index] }
	/**
     * Gets an named parameter of the projection.
     * The parameter name is case insensitive
     *
     * @param name Name of parameter
     * @return parameter or null if not found
     */
	public func getParameter(name: String) -> ProjectionParameter? {
        for par: ProjectionParameter in _parameters {
            if par.getName().lowercased() == name.lowercased() {
                return par
            }
        }
		return nil
	}
	/**
     * Gets the projection classification name (e.g. "Transverse_Mercator").
     */
	public func getClassName() -> String { return _ClassName }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		var sb: String
		sb = "PROJECTION[\"\(getName())\""
        if !getAuthority().isEmpty && getAuthorityCode() > 0 {
            sb += ", AUTHORITY[\"\(getAuthority())\", \"\(getAuthorityCode())\"]"
        }
		sb.append("]")
		return sb
	}
	/**
     * Gets an XML representation of this object
     */
	public override func getXML() -> String {
		var sb: String
		sb = "<CS_Projection Classname=\"\(getClassName())\">\(getInfoXml())"
		for param: ProjectionParameter in getParameters() { sb.append(param.getXML()) }
		sb.append("</CS_Projection>")
		return sb
	}
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
    public override func equalParams(obj: Any) -> Bool {
        //		if !(obj is Projection) { return false }
        //		let proj: Projection = obj as! Projection
        guard let proj = obj as? Projection else { return false }
		if proj.getNumParameters() != self.getNumParameters() { return false }
		for pp in _parameters {
			let p2 = proj.getParameter(name: pp.getName())
			if p2 == nil { return false }
			if p2?.getValue() != pp.getValue() { return false }
		}
		return true
	}
}
