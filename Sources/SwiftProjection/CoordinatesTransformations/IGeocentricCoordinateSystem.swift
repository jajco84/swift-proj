/// A 3D coordinate system, with its origin at the center of the Earth.
public protocol IGeocentricCoordinateSystem: ICoordinateSystem {
	/**
     * Returns the HorizontalDatum. The horizontal datum is used to determine where
     * the centre of the Earth is considered to be. All coordinate points will be
     * measured from the centre of the Earth, and not the surface.
     *
     * @return the horizontal datum
     * @throws Exception the exception
     */
	func getHorizontalDatum() -> IHorizontalDatum
	/**
     * Sets horizontal datum.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setHorizontalDatum(value: IHorizontalDatum)
	/**
     * Gets the units used along all the axes.
     *
     * @return the linear unit
     * @throws Exception the exception
     */
	func getLinearUnit() -> ILinearUnit
	/**
     * Sets linear unit.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setLinearUnit(value: ILinearUnit)
	/**
     * Returns the PrimeMeridian.
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
}
