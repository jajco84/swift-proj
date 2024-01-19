/// The IGeographicCoordinateSystem interface is a subclass of IGeodeticSpatialReference and
/// defines the standard information stored with geographic coordinate system objects.
public protocol IGeographicCoordinateSystem: IHorizontalCoordinateSystem {
	/**
     * Gets or sets the angular units of the geographic coordinate system.
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
	/**
     * Gets or sets the prime meridian of the geographic coordinate system.
     *
     * @return the prime meridian
     * @throws Exception the exception
     */
	func getPrimeMeridian() -> IPrimeMeridian
	/**
     * Sets prime meridian.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setPrimeMeridian(value: IPrimeMeridian)
	/**
     * Gets the number of available conversions to WGS84 coordinates.
     *
     * @return the num conversion to wgs 84
     * @throws Exception the exception
     */
	func getNumConversionToWGS84() -> Int
	/**
     * Gets details on a conversion to WGS84.
     *
     * @param index the index
     * @return the wgs 84 conversion info
     * @throws Exception the exception
     */
	func getWgs84ConversionInfo(index: Int) -> Wgs84ConversionInfo
}
