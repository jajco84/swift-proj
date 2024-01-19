public class PseudoMercator: Mercator {
	/**
     * Instantiates a new Pseudo mercator.
     *
     * @param parameters the parameters
     * @throws Exception the exception
     */
	public convenience init(_ parameters: [ProjectionParameter]) { self.init(parameters, nil) }
	/**
     * Instantiates a new Pseudo mercator.
     *
     * @param parameters the parameters
     * @param inverse    the inverse
     * @throws Exception the exception
     */
	override init(_ parameters: [ProjectionParameter], _ inverse: Mercator?) {
		super.init(PseudoMercator.verifyParameters(parameters: parameters), inverse)
		setName(value: "Pseudo-Mercator")
		setAuthority(value: "EPSG")
		setAuthorityCode(value: 3856)
	}
	private class func verifyParameters(parameters: [ProjectionParameter]) -> [ProjectionParameter] {
		let p: ProjectionParameterSet = ProjectionParameterSet(parameters)
		let semi_major: Double = p.getParameterValue(parameterName: "semi_major")
		p.setParameterValue(name: "semi_minor", semi_major)
		p.setParameterValue(name: "scale_factor", 1)
		return p.toProjectionParameter()
	}
	public override func inverse() -> IMathTransform {
		if _inverse == nil { _inverse = PseudoMercator(_Parameters.toProjectionParameter(), self) }
		return _inverse!
	}
}
