/// The ILinearUnit interface defines methods on linear units.
public protocol ILinearUnit: IUnit {
	/**
     * Gets or sets the number of meters per
     * {@link ILinearUnit}
     * .
     *
     * @return the meters per unit
     * @throws Exception the exception
     */
	func getMetersPerUnit() -> Double
	/**
     * Sets meters per unit.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setMetersPerUnit(value: Double)
}
