/// Transformation for applying
public class DatumTransform: MathTransform {
	/**
     * The Inverse.
     */
	internal var _inverse: IMathTransform?
	/**
     * The V.
     */
	var v: [Double]
	private var _toWgs94: Wgs84ConversionInfo
	private var _isinverse: Bool
	/**
     * Initializes a new instance of the
     * {@link #DatumTransform}
     * class.
     *
     * @param towgs84 the towgs 84
     * @throws Exception the exception
     */
	public convenience init(_ towgs84: Wgs84ConversionInfo) { self.init(towgs84, false) }
	private init(_ towgs84: Wgs84ConversionInfo, _ isinverse: Bool) {
		_toWgs94 = towgs84
		v = _toWgs94.getAffineTransform()
		_isinverse = isinverse
	}
	/**
     * Gets a Well-Known text representation of this object.
     */
	public override func getWKT() -> String { return "" }
	/**
     * Gets an XML representation of this object.
     */
	public override func getXML() -> String { return "" }
	public override func getDimSource() -> Int { return 3 }
	public override func getDimTarget() -> Int { return 3 }
	/**
     * Creates the inverse transform of this object.
     *
     * @return This method may fail if the transform is not one to one. However, all cartographic projections should succeed.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let t = DatumTransform(_toWgs94, !_isinverse)
            self._inverse = t
            return t
        }
        return _inverse

//		if _inverse == nil { _inverse = DatumTransform(_toWgs94, !_isinverse) }
//		return _inverse!
	}
	/**
     * Transforms a coordinate point.
     *
     * @param p
     * @return
     * @see
     */
	private func apply(p: [Double]) -> [Double] {
		var d: [Double] = [Double]()
		d.append(v[0] * (p[0] - v[3] * p[1] + v[2] * p[2]) + v[4])
		d.append(v[0] * (v[3] * p[0] + p[1] - v[1] * p[2]) + v[5])
		d.append(v[0] * (-v[2] * p[0] + v[1] * p[1] + p[2]) + v[6])
		return d
	}
	/**
     * For the reverse transformation, each element is multiplied by -1.
     *
     * @param p
     * @return
     * @see
     */
	private func applyInverted(p: [Double]) -> [Double] {
		var d: [Double] = [Double]()
		d.append((1 - (v[0] - 1)) * (p[0] + v[3] * p[1] - v[2] * p[2]) - v[4])
		d.append((1 - (v[0] - 1)) * (-v[3] * p[0] + p[1] + v[1] * p[2]) - v[5])
		d.append((1 - (v[0] - 1)) * (v[2] * p[0] - v[1] * p[1] + p[2]) - v[6])
		return d
	}
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point
     * @return
     */
	public override func transform(point: [Double]) -> [Double] {
		if !_isinverse {
			return apply(p: point)
		} else {
			return applyInverted(p: point)
		}
	}
	/**
     * Transforms a list of coordinate point ordinal values.
     *
     * @param points
     * @return This method is provided for efficiently transforming many points. The supplied array
     * of ordinal values will contain packed ordinal values. For example, if the source
     * dimension is 3, then the ordinals will be packed in this order (x0,y0,z0,x1,y1,z1 ...).
     * The size of the passed array must be an integer multiple of DimSource. The returned
     * ordinal values are packed in a similar way. In some DCPs. the ordinals may be
     * transformed in-place, and the returned array may be the same as the passed array.
     * So any client code should not attempt to reuse the passed ordinal values (although
     * they can certainly reuse the passed array). If there is any problem then the server
     * implementation will throw an exception. If this happens then the client should not
     * make any assumptions about the state of the ordinal values.
     */
	public override func transformList(points: [[Double]]) -> [[Double]] {
		var pnts: [[Double]] = [[Double]]()
		for p: [Double] in points { pnts.append(transform(point: p)) }
		return pnts
	}
	/**
     * Reverses the transformation
     */
    public override func invert() {
//        _isinverse = !_isinverse
        _isinverse.toggle()
    }
}
