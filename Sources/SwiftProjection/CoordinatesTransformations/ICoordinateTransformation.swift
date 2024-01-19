/// Describes a coordinate transformation. This interface only describes a
/// coordinate transformation, it does not actually perform the transform
/// operation on points. To transform points you must use a math transform.
public protocol ICoordinateTransformation {
	/**
     * Human readable description of domain in source coordinate system.
     *
     * @return the area of use
     * @throws Exception the exception
     */
	func getAreaOfUse() -> String
	/**
     * Authority which defined transformation and parameter values.
     *
     * An Authority is an organization that maintains definitions of Authority Codes. For example the European Petroleum Survey Group (EPSG) maintains a database of coordinate systems, and other spatial referencing objects, where each object has a code number ID. For example, the EPSG code for a WGS84 Lat/Lon coordinate system is 4326
     *
     * @return the authority
     * @throws Exception the exception
     */
	func getAuthority() -> String
	/**
     * Code used by authority to identify transformation. An empty string is used for no code.
     * The AuthorityCode is a compact string defined by an Authority to reference a particular spatial reference object. For example, the European Survey Group (EPSG) authority uses 32 bit integers to reference coordinate systems, so all their code strings will consist of a few digits. The EPSG code for WGS84 Lat/Lon is 4326.
     *
     * @return the authority code
     * @throws Exception the exception
     */
	func getAuthorityCode() -> Int
	/**
     * Gets math transform.
     *
     * @return the math transform
     * @throws Exception the exception
     */
	func getMathTransform() -> IMathTransform
	/**
     * Name of transformation.
     *
     * @return the name
     * @throws Exception the exception
     */
	func getName() -> String
	/**
     * Gets the provider-supplied remarks.
     *
     * @return the remarks
     * @throws Exception the exception
     */
	func getRemarks() -> String
	/**
     * Source coordinate system.
     *
     * @return the source cs
     * @throws Exception the exception
     */
	func getSourceCS() -> ICoordinateSystem
	/**
     * Target coordinate system.
     *
     * @return the target cs
     * @throws Exception the exception
     */
	func getTargetCS() -> ICoordinateSystem
	/**
     * Semantic type of transform. For example, a datum transformation or a coordinate conversion.
     *
     * @return the transform type
     * @throws Exception the exception
     */
	func getTransformType() -> TransformType
}
