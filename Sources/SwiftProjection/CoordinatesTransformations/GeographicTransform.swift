/// The GeographicTransform class is implemented on geographic transformation objects and
/// implements datum transformations between geographic coordinate systems.
public class GeographicTransform: MathTransform {
	private var _SourceGCS: IGeographicCoordinateSystem
	private var _TargetGCS: IGeographicCoordinateSystem
	/**
     * Instantiates a new Geographic transform.
     *
     * @param sourceGCS the source gcs
     * @param targetGCS the target gcs
     * @throws Exception the exception
     */
	public init(_ sourceGCS: IGeographicCoordinateSystem, _ targetGCS: IGeographicCoordinateSystem) {
		_SourceGCS = sourceGCS
		_TargetGCS = targetGCS
	}
	/**
     * Gets or sets the source geographic coordinate system for the transformation.
     *
     * @return the source gcs
     * @throws Exception the exception
     */
	public func getSourceGCS() -> IGeographicCoordinateSystem { return _SourceGCS }
	/**
     * Sets source gcs.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setSourceGCS(value: IGeographicCoordinateSystem) { _SourceGCS = value }
	/**
     * Gets or sets the target geographic coordinate system for the transformation.
     *
     * @return the target gcs
     * @throws Exception the exception
     */
	public func getTargetGCS() -> IGeographicCoordinateSystem { return _TargetGCS }
	/**
     * Sets target gcs.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setTargetGCS(value: IGeographicCoordinateSystem) { _TargetGCS = value }
	/**
     * Returns the Well-known text for this object
     * as defined in the simple features specification. [NOT IMPLEMENTED].
     */
	public override func getWKT() -> String { return "" }
	/**
     * Gets an XML representation of this object [NOT IMPLEMENTED].
     */
	public override func getXML() -> String { return "" }
	public override func getDimSource() -> Int { return _SourceGCS.getDimension() }
	public override func getDimTarget() -> Int { return _TargetGCS.getDimension() }
	/**
     * Creates the inverse transform of this object.
     * This method may fail if the transform is not one to one. However, all cartographic projections should succeed.
     *
     * @return
     */
	public override func inverse() -> IMathTransform? { return nil }
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point
     * @return
     */
	public override func transform(point: [Double]) -> [Double] {
		var pOut: [Double] = cloneArray(a: point)
		pOut[0] /= getSourceGCS().getangularUnit().getRadiansPerUnit()
		pOut[0] -= getSourceGCS().getPrimeMeridian().getLongitude() / getSourceGCS().getPrimeMeridian().getangularUnit().getRadiansPerUnit()
		pOut[0] += getTargetGCS().getPrimeMeridian().getLongitude() / getTargetGCS().getPrimeMeridian().getangularUnit().getRadiansPerUnit()
		pOut[0] *= getSourceGCS().getangularUnit().getRadiansPerUnit()
		return pOut
	}
    
	func cloneArray(a: [Double]) -> [Double] {
		var r: [Double] = [Double]()
		for x in a { r.append(x) }
		return r
	}
	/**
     * Transforms a list of coordinate point ordinal values.
     *
     * This method is provided for efficiently transforming many points. The supplied array
     * of ordinal values will contain packed ordinal values. For example, if the source
     * dimension is 3, then the ordinals will be packed in this order (x0,y0,z0,x1,y1,z1 ...).
     * The size of the passed array must be an integer multiple of DimSource. The returned
     * ordinal values are packed in a similar way. In some DCPs. the ordinals may be
     * transformed in-place, and the returned array may be the same as the passed array.
     * So any client code should not attempt to reuse the passed ordinal values (although
     * they can certainly reuse the passed array). If there is any problem then the server
     * implementation will throw an exception. If this happens then the client should not
     * make any assumptions about the state of the ordinal values.
     *
     * @param points
     * @return
     */
	public override func transformList(points: [[Double]]) -> [[Double]] {
		var trans: [[Double]] = [[Double]]()
		for p: [Double] in points { trans.append(transform(point: p)) }
		return trans
	}
	/**
     * Reverses the transformation
     */
	public override func invert() {
	}
}
