/// The type Concatenated transform.
public class ConcatenatedTransform: MathTransform {
	/**
     * The Inverse.
     */
	internal var _inverse: IMathTransform?
	private var _coordinateTransformationList: [ICoordinateTransformation] = [ICoordinateTransformation]()
//	/**
//     * Instantiates a new Concatenated transform.
//     *
//     * @throws Exception the exception
//     */
//	public override convenience init() { self.init([ICoordinateTransformation]()) }
	/**
     * Instantiates a new Concatenated transform.
     *
     * @param transformlist the transformlist
     * @throws Exception the exception
     */
	public init(_ transformlist: [ICoordinateTransformation] = []) { _coordinateTransformationList = transformlist }
	/**
     * Gets coordinate transformation list.
     *
     * @return the coordinate transformation list
     * @throws Exception the exception
     */
	public func getCoordinateTransformationList() -> [ICoordinateTransformation] { return _coordinateTransformationList }
	public func appendTransformationToList(tr: ICoordinateTransformation) { _coordinateTransformationList.append(tr) }
	/**
     * Sets coordinate transformation list.
     *
     * @param value the value
     * @throws Exception the exception
     */
	public func setCoordinateTransformationList(value: [ICoordinateTransformation]) {
		_coordinateTransformationList = value
		_inverse = nil
	}
	public override func getDimSource() -> Int { return _coordinateTransformationList[0].getSourceCS().getDimension() }
	public override func getDimTarget() -> Int { return _coordinateTransformationList[_coordinateTransformationList.count - 1].getTargetCS().getDimension() }
	/**
     * Transforms a point
     *
     * @param point point
     * @return transformed point
     */
	public override func transform(point: [Double]) -> [Double] {
		var pp = point
		for ct: ICoordinateTransformation in _coordinateTransformationList {
            pp = ct.getMathTransform().transform(point: pp)
        }
		return pp
	}
	/**
     * Transforms a list point
     *
     * @param points points
     * @return transformed points
     */
	public override func transformList(points: [[Double]]) -> [[Double]] {
		var pnts: [[Double]] = [[Double]](points)
		for ct: ICoordinateTransformation in _coordinateTransformationList { pnts = ct.getMathTransform().transformList(points: pnts) }
		return pnts
	}
	/**
     * Returns the inverse of this conversion.
     *
     * @return IMathTransform that is the reverse of the current conversion.
     */
	public override func inverse() -> IMathTransform? {
        guard let _inverse else {
            let transform = clone()
            transform.invert()
            self._inverse = transform
            return transform
        }
        return _inverse
//
//        if _inverse == nil {
//			_inverse = clone()
//			_inverse!.invert()
//		}
//		return _inverse
	}
	/**
     * Reverses the transformation
     */
	public override func invert() {
		for ic: ICoordinateTransformation in _coordinateTransformationList.reversed() { ic.getMathTransform().invert() }
	}
	public func clone() -> ConcatenatedTransform {
		var clonedList: [ICoordinateTransformation] = [ICoordinateTransformation]()
		for ct: ICoordinateTransformation in _coordinateTransformationList {
			clonedList.append(ct)
		}
		return ConcatenatedTransform(clonedList)
	}
	/**
     * Gets a Well-Known text representation of this object.
     */
	public override func getWKT() -> String { return "" }
	/**
     * Gets an XML representation of this object.
     */
	public override func getXML() -> String { return "" }
}
