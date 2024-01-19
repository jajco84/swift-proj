/// The IEllipsoid interface defines the standard information stored with ellipsoid objects.
public protocol IEllipsoid: IInfo {
	/**
     * Gets or sets the value of the semi-major axis.
     *
     * @return the semi major axis
     * @throws Exception the exception
     */
	func getSemiMajorAxis() -> Double
	/**
     * Sets semi major axis.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setSemiMajorAxis(value: Double)
	/**
     * Gets or sets the value of the semi-minor axis.
     *
     * @return the semi minor axis
     * @throws Exception the exception
     */
	func getSemiMinorAxis() -> Double
	/**
     * Sets semi minor axis.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setSemiMinorAxis(value: Double)
	/**
     * Gets or sets the value of the inverse of the flattening constant of the ellipsoid.
     *
     * @return the inverse flattening
     * @throws Exception the exception
     */
	func getInverseFlattening() -> Double
	/**
     * Sets inverse flattening.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setInverseFlattening(value: Double)
	/**
     * Gets or sets the value of the axis unit.
     *
     * @return the axis unit
     * @throws Exception the exception
     */
	func getAxisUnit() -> ILinearUnit
	/**
     * Sets axis unit.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setAxisUnit(value: ILinearUnit)
	/**
     * Is the Inverse Flattening definitive for this ellipsoid? Some ellipsoids use the
     * IVF as the defining value, and calculate the polar radius whenever asked. Other
     * ellipsoids use the polar radius to calculate the IVF whenever asked. This
     * distinction can be important to avoid floating-point rounding errors.
     *
     * @return the is ivf definitive
     * @throws Exception the exception
     */
	func getIsIvfDefinitive() -> Bool
	/**
     * Sets is ivf definitive.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setIsIvfDefinitive(value: Bool)
}
