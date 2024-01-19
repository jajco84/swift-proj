// import com.asseco.android.proj.IPrimeMeridian;
/// Adjusts target Prime Meridian
public class PrimeMeridianTransform: MathTransform {
	private var _isinverted: Bool = false
	private var _source: IPrimeMeridian
	private var _target: IPrimeMeridian
	/**
     * Creates instance prime meridian transform
     *
     * @param source the source
     * @param target the target
     * @throws Exception the exception
     */
	public init(_ source: IPrimeMeridian, _ target: IPrimeMeridian) {
		// if (!source.getangularUnit().equalParams(target.getangularUnit())) {
		//    throwException() /* throw UnsupportedOperationException("The method or operation is not implemented."); */
		// }
		_source = source
		_target = target
	}
	/* *
     * Gets a Well-Known text representation of this affine math transformation.
     */
	public override func getWKT() -> String { return "" }
	/**
     * Gets an XML representation of this affine transformation.
     */
	public override func getXML() -> String { return "" }
	/**
     * Gets the dimension of input points.
     */
	public override func getDimSource() -> Int { return 3 }
	/**
     * Gets the dimension of output points.
     */
	public override func getDimTarget() -> Int { return 3 }
	/**
     * Returns the inverse of this affine transformation.
     *
     * @return IMathTransform that is the reverse of the current affine transformation.
     */
	public override func inverse() -> IMathTransform { return PrimeMeridianTransform(_target, _source) }
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point
     * @return
     */
	public override func transform(point: [Double]) -> [Double] {
		var transformed: [Double] = [Double]()
		if !_isinverted {
			transformed.append(point[0] + _source.getLongitude() - _target.getLongitude())
		} else {
			transformed.append(point[0] + _target.getLongitude() - _source.getLongitude())
		}
		transformed.append(point[1])
		if point.count > 2 { transformed.append(point[2]) }
		return transformed
	}
	/* *
     * Reverses the transformation
     */
    public override func invert() {
        self._isinverted.toggle()
    }
}
