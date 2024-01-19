/// A coordinate system which sits inside another coordinate system. The fitted
/// coordinate system can be rotated and shifted, or use any other math transform
/// to inject itself into the base coordinate system.
public class FittedCoordinateSystem: CoordinateSystem, IFittedCoordinateSystem {
	private var _ToBaseTransform: IMathTransform
	private var _BaseCoordinateSystem: ICoordinateSystem
	/**
     * Creates an instance of FittedCoordinateSystem using the specified parameters
     *
     * @param baseSystem   Underlying coordinate system.
     * @param transform    Transformation from fitted coordinate system to the base one
     * @param name         Name
     * @param authority    Authority name
     * @param code         Authority-specific identification code.
     * @param alias        Alias
     * @param remarks      Provider-supplied remarks
     * @param abbreviation Abbreviation
     * @throws Exception the exception
     */
	public init(_ baseSystem: ICoordinateSystem, _ transform: IMathTransform, _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_BaseCoordinateSystem = baseSystem
		_ToBaseTransform = transform
		// get axis infos from the source
		var ai: [AxisInfo] = [AxisInfo]()
		for dim in 0...baseSystem.getDimension() - 1 { ai.append(baseSystem.getAxis(dimension: dim)) }
		super.init(name, authority, code, alias, abbreviation, remarks)
		super.setAxisInfo(value: ai)
	}
	/**
     * Represents math transform that injects itself into the base coordinate system.
     *
     * @return the to base transform
     * @throws Exception the exception
     */
	public func getToBaseTransform() -> IMathTransform { return _ToBaseTransform }
	/**
     * Gets underlying coordinate system.
     */
	public func getBaseCoordinateSystem() -> ICoordinateSystem { return _BaseCoordinateSystem }
	/**
     * Gets Well-Known Text of a math transform to the base coordinate system.
     * The dimension of this fitted coordinate system is determined by the source
     * dimension of the math transform. The transform should be one-to-one within
     * this coordinate system's domain, and the base coordinate system dimension
     * must be at least as big as the dimension of this coordinate system.
     *
     * @return
     */
	public func toBase() -> String { return _ToBaseTransform.getWKT() }
	/**
     * Returns the Well-known text for this object as defined in the simple features specification.
     */
	public override func getWKT() -> String {
		// <fitted cs>          = FITTED_CS["<name>", <to base>, <base cs>]
		var sb: String
		sb = "FITTED_CS[\"\(getName())\", \(_ToBaseTransform.getWKT()), \(_BaseCoordinateSystem.getWKT())]"
		return sb
	}
	/**
     * Gets an XML representation of this object.
     */
	public override func getXML() -> String {
		// throwException() /* throw UnsupportedOperationException(); */
		return "not supported"
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
		let fcs: IFittedCoordinateSystem? = obj as? IFittedCoordinateSystem
		// ? (IFittedCoordinateSystem) obj : (IFittedCoordinateSystem) nil;
		if fcs != nil {
			if (fcs?.getBaseCoordinateSystem().equalParams(obj: self.getBaseCoordinateSystem())) != nil {
				let fcsToBase: String = fcs?.toBase() ?? ""
				let thisToBase: String = self.toBase()
				if fcsToBase == thisToBase { return true }
			}
		}
		return false
	}
	/**
     * Gets the units for the dimension within coordinate system.
     * Each dimension in the coordinate system has corresponding units.
     */
	public override func getUnits(dimension: Int) -> IUnit { return _BaseCoordinateSystem.getUnits(dimension: dimension) }
}
