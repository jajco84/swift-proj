/// Procedure used to measure positions on the surface of the Earth.
public protocol IHorizontalDatum: IDatum {
	/**
     * Gets or sets the ellipsoid of the datum.
     *
     * @return the ellipsoid
     * @throws Exception the exception
     */
	func getEllipsoid() -> IEllipsoid
	/**
     * Sets ellipsoid.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setEllipsoid(value: IEllipsoid)
	/**
     * Gets preferred parameters for a Bursa Wolf transformation into WGS84. The 7 returned values
     * correspond to (dx,dy,dz) in meters, (ex,ey,ez) in arc-seconds, and scaling in parts-per-million.
     *
     * @return the wgs 84 parameters
     * @throws Exception the exception
     */
	func getWgs84Parameters() -> Wgs84ConversionInfo?
	/**
     * Sets wgs 84 parameters.
     *
     * @param value the value
     * @throws Exception the exception
     */
	func setWgs84Parameters(value: Wgs84ConversionInfo)
}
