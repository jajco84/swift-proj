/// An aggregate of two coordinate systems (CRS). One of these is usually a
/// CRS based on a two dimensional coordinate system such as a geographic or
/// a projected coordinate system with a horizontal datum. The other is a
/// vertical CRS which is a one-dimensional coordinate system with a vertical
/// datum.
public protocol ICompoundCoordinateSystem: ICoordinateSystem {
	/**
     * Gets first sub-coordinate system.
     *
     * @return the head cs
     * @throws Exception the exception
     */
	func getHeadCS() -> ICoordinateSystem
	/**
     * Gets second sub-coordinate system.
     *
     * @return the tail cs
     * @throws Exception the exception
     */
	func getTailCS() -> ICoordinateSystem
}
