/// The IProjectedCoordinateSystem interface defines the standard information stored with
/// projected coordinate system objects. A projected coordinate system is defined using a
/// geographic coordinate system object and a projection object that defines the
/// coordinate transformation from the geographic coordinate system to the projected
/// coordinate systems. The instances of a single ProjectedCoordinateSystem COM class can
/// be used to model different projected coordinate systems (e.g., UTM Zone 10, Albers)
/// by associating the ProjectedCoordinateSystem instances with Projection instances
/// belonging to different Projection COM classes (Transverse Mercator and Albers,
/// respectively).
public protocol IProjectedCoordinateSystem: IHorizontalCoordinateSystem {
	/**
     * Gets or sets the geographic coordinate system associated with the projected
     * coordinate system.
     *
     * @return the geographic coordinate system
     * @throws Exception the exception
     */
	func getGeographicCoordinateSystem() -> IGeographicCoordinateSystem
	/**
     * Sets geographic coordinate system.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setGeographicCoordinateSystem(value: IGeographicCoordinateSystem)
	/**
     * Gets or sets the linear (projected) units of the projected coordinate system.
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
     * Gets or sets the projection for the projected coordinate system.
     *
     * @return the projection
     * @throws Exception the exception
     */
	func getProjection() -> IProjection
	/**
     * Sets projection.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setProjection(value: IProjection)
}
