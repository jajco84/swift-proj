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
public class Datum: Info, IDatum {
	private var _DatumType: DatumType
	/**
     * Initializes a new instance of a Datum object
     *
     * @param type         Datum type
     * @param name         Name
     * @param authority    Authority name
     * @param code         Authority-specific identification code.
     * @param alias        Alias
     * @param remarks      Provider-supplied remarks
     * @param abbreviation Abbreviation
     * @throws Exception the exception
     */
	public init(_ type: DatumType, _ name: String, _ authority: String, _ code: Int, _ alias: String, _ remarks: String, _ abbreviation: String) {
		_DatumType = type
		super.init(name, authority, code, alias, abbreviation, remarks)
	}
	/**
     * Gets or sets the type of the datum as an enumerated code.
     */
	public func getDatumType() -> DatumType { return _DatumType }
	public func setDatumType(value: DatumType) { _DatumType = value }
	/**
     * Checks whether the values of this instance is equal to the values of another instance.
     * Only parameters used for coordinate system are used for comparison.
     * Name, abbreviation, authority, alias and remarks are ignored in the comparison.
     *
     * @param obj
     * @return True if equal
     */
	public override func equalParams(obj: Any) -> Bool {
		if !(obj is Datum) { return false }
		return (obj as! Datum).getDatumType() == self.getDatumType()
	}
}
