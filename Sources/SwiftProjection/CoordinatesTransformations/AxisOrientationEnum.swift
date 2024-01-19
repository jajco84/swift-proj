/// The enum Axis orientation enum.
public enum AxisOrientationEnum {
	/**
     * Orientation of axis. Some coordinate systems use non-standard orientations.
     * For example, the first axis in South African grids usually points West,
     * instead of East. This information is obviously relevant for algorithms
     * converting South African grid coordinates into Lat/Long.
     *
     * Unknown or unspecified axis orientation. This can be used for local or fitted coordinate systems.
     */
	case Other, /**
     * Increasing ordinates values go North. This is usually used for Grid Y coordinates and Latitude.
     */
		North, /**
     * Increasing ordinates values go South. This is rarely used.
     */
		South, /**
     * Increasing ordinates values go East. This is rarely used.
     */
		East, /**
     * Increasing ordinates values go West. This is usually used for Grid X coordinates and Longitude.
     */
		West, /**
     * Increasing ordinates values go up. This is used for vertical coordinate systems.
     */
		Up, /**
     * Increasing ordinates values go down. This is used for vertical coordinate systems.
     */
		Down
}
