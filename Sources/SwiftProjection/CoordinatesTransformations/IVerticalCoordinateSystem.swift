/// A 2D coordinate system suitable for positions on the Earth's surface.
public protocol IVerticalCoordinateSystem: ICoordinateSystem {
	/**
     * Returns the HorizontalDatum.
     *
     * @return the horizontal datum
     * @throws Exception the exception
     */
	func getVerticalDatum() -> IVerticalDatum
	/**
     * Sets horizontal datum.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setVerticalDatum(value: IVerticalDatum)
	func getVerticalUnit() -> ILinearUnit
	func setVerticalUnit(value: ILinearUnit)
}
