/// A set of quantities from which other quantities are calculated.
/// *
/// For the OGC abstract model, it can be defined as a set of real points on the earth
/// that have coordinates. EG. A datum can be thought of as a set of parameters
/// defining completely the origin and orientation of a coordinate system with respect
/// to the earth. A textual description and/or a set of parameters describing the
/// relationship of a coordinate system to some predefined physical locations (such
/// as center of mass) and physical directions (such as axis of spin). The definition
/// of the datum may also include the temporal behavior (such as the rate of change of
/// the orientation of the coordinate axes).
public protocol IDatum: IInfo {
	/**
     * Gets or sets the type of the datum as an enumerated code.
     *
     * @return the datum type
     * @throws Exception the exception
     */
	func getDatumType() -> DatumType
	/**
     * Sets datum type.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setDatumType(value: DatumType)
}
