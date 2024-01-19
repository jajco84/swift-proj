/// Describes a coordinate transformation. This class only describes a
/// coordinate transformation, it does not actually perform the transform
/// operation on points. To transform points you must use a MathTransform
/// .
public class CoordinateTransformation: ICoordinateTransformation {
	private var _AreaOfUse: String = String()
	private var _Authority: String = String()
	private var _AuthorityCode: Int
	private var _MathTransform: IMathTransform
	private var _Name: String = String()
	private var _Remarks: String = String()
	private var _SourceCS: ICoordinateSystem
	private var _TargetCS: ICoordinateSystem
	private var _TransformType: TransformType
	/**
     * Initializes an instance of a CoordinateTransformation
     *
     * @param sourceCS      Source coordinate system
     * @param targetCS      Target coordinate system
     * @param transformType Transformation type
     * @param mathTransform Math transform
     * @param name          Name of transform
     * @param authority     Authority
     * @param authorityCode Authority code
     * @param areaOfUse     Area of use
     * @param remarks       Remarks
     * @throws Exception the exception
     */
	public init(_ sourceCS: ICoordinateSystem, _ targetCS: ICoordinateSystem, _ transformType: TransformType, _ mathTransform: IMathTransform, _ name: String, _ authority: String, _ authorityCode: Int, _ areaOfUse: String, _ remarks: String) {
		_TargetCS = targetCS
		_SourceCS = sourceCS
		_TransformType = transformType
		_MathTransform = mathTransform
		_Name = name
		_Authority = authority
		_AuthorityCode = authorityCode
		_AreaOfUse = areaOfUse
		_Remarks = remarks
	}
	/**
     * Human readable description of domain in source coordinate system.
     */
	public func getAreaOfUse() -> String { return _AreaOfUse }
	/**
     * Authority which defined transformation and parameter values.
     *
     * An Authority is an organization that maintains definitions of Authority Codes. For example the European Petroleum Survey Group (EPSG) maintains a database of coordinate systems, and other spatial referencing objects, where each object has a code number ID. For example, the EPSG code for a WGS84 Lat/Lon coordinate system is 4326
     */
	public func getAuthority() -> String { return _Authority }
	/**
     * Code used by authority to identify transformation. An empty string is used for no code.
     * The AuthorityCode is a compact string defined by an Authority to reference a particular spatial reference object. For example, the European Survey Group (EPSG) authority uses 32 bit integers to reference coordinate systems, so all their code strings will consist of a few digits. The EPSG code for WGS84 Lat/Lon is 4326.
     */
	public func getAuthorityCode() -> Int { return _AuthorityCode }
	/**
     * Gets math transform.
     */
	public func getMathTransform() -> IMathTransform { return _MathTransform }
	/**
     * Name of transformation.
     */
	public func getName() -> String { return _Name }
	/**
     * Gets the provider-supplied remarks.
     */
	public func getRemarks() -> String { return _Remarks }
	/**
     * Source coordinate system.
     */
	public func getSourceCS() -> ICoordinateSystem { return _SourceCS }
	/**
     * Target coordinate system.
     */
	public func getTargetCS() -> ICoordinateSystem { return _TargetCS }
	/**
     * Semantic type of transform. For example, a datum transformation or a coordinate conversion.
     */
	public func getTransformType() -> TransformType { return _TransformType }
}
