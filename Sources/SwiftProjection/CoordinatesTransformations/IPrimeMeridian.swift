/// The IPrimeMeridian interface defines the standard information stored with prime
/// meridian objects. Any prime meridian object must implement this interface as
/// well as the ISpatialReferenceInfo interface.
public protocol IPrimeMeridian: IInfo {
	/**
     * Gets or sets the longitude of the prime meridian (relative to the Greenwich prime meridian).
     *
     * @return the longitude
     * @throws Exception the exception
     */
	func getLongitude() -> Double
	/**
     * Sets longitude.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setLongitude(value: Double)
	/**
     * Gets or sets the AngularUnits.
     *
     * @return the unit
     * @throws Exception the exception
     */
	func getangularUnit() -> IAngularUnit
	/**
     * Sets unit.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setangularUnit(value: IAngularUnit)
}
