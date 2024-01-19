/// A 2D coordinate system suitable for positions on the Earth's surface.
public protocol IHorizontalCoordinateSystem: ICoordinateSystem {
	/**
     * Returns the HorizontalDatum.
     *
     * @return the horizontal datum
     * @throws Exception the exception
     */
	func getHorizontalDatum() -> IHorizontalDatum?
	/**
     * Sets horizontal datum.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setHorizontalDatum(value: IHorizontalDatum)
}
