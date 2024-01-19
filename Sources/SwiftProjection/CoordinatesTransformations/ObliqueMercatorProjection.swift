/// The type Oblique mercator projection.
public class ObliqueMercatorProjection: HotineObliqueMercatorProjection {
	/**
     * Instantiates a new Oblique mercator projection.
     *
     * @param parameters the parameters
     * @throws Exception the exception
     */
	public convenience init(_ parameters: [ProjectionParameter]) { self.init(parameters, nil) }
	/**
     * Instantiates a new Oblique mercator projection.
     *
     * @param parameters the parameters
     * @param inverse    the inverse
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter], _ inverse: ObliqueMercatorProjection?) {
		super.init(parameters, inverse)
		setAuthorityCode(value: 9815)
		setName(value: "Oblique_Mercator")
	}
	public override func inverse() -> IMathTransform {
		if _inverse == nil { _inverse = ObliqueMercatorProjection(_Parameters.toProjectionParameter(), self) }
		return _inverse!
	}
}
