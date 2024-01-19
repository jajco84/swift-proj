/// Transforms muti-dimensional coordinate points.
/// *
/// If a client application wishes to query the source and target coordinate
/// systems of a transformation, then it should keep hold of the
/// *
/// ICoordinateTransformation
/// interface, and use the contained
/// math transform object whenever it wishes to perform a transform.
public protocol IMathTransform {
	/**
     * Gets the dimension of input points.
     *
     * @return the dim source
     * @throws Exception the exception
     */
	func getDimSource() -> Int
	/**
     * Gets the dimension of output points.
     *
     * @return the dim target
     * @throws Exception the exception
     */
	func getDimTarget() -> Int
	/**
     * Tests whether this transform does not move any points.
     *
     * @return boolean
     * @throws Exception the exception
     */
	func identity() -> Bool
	/**
     * Gets a Well-Known text representation of this object.
     *
     * @return the wkt
     * @throws Exception the exception
     */
	func getWKT() -> String
	/**
     * Gets an XML representation of this object.
     *
     * @return the xml
     * @throws Exception the exception
     */
	func getXML() -> String
	/**
     * Gets the derivative of this transform at a point. If the transform does
     * not have a well-defined derivative at the point, then this function should
     * fail in the usual way for the DCP. The derivative is the matrix of the
     * non-translating portion of the approximate affine map at the point. The
     * matrix will have dimensions corresponding to the source and target
     * coordinate systems. If the input dimension is M, and the output dimension
     * is N, then the matrix will have size [M][N]. The elements of the matrix
     * {elt[n][m] : n=0..(N-1)} form a vector in the output space which is
     * parallel to the displacement caused by a small change in the m'th ordinate
     * in the input space.
     *
     * @param point the point
     * @return double [ ] [ ]
     * @throws Exception the exception
     */
	func derivative(point: [Double]) -> [Double]
	/**
     * Gets transformed convex hull.
     * The supplied ordinates are interpreted as a sequence of points, which generates a convex
     * hull in the source space. The returned sequence of ordinates represents a convex hull in the
     * output space. The number of output points will often be different from the number of input
     * points. Each of the input points should be inside the valid domain (this can be checked by
     * testing the points' domain flags individually). However, the convex hull of the input points
     * may go outside the valid domain. The returned convex hull should contain the transformed image
     * of the intersection of the source convex hull and the source domain.A convex hull is a shape in a coordinate system, where if two positions A and B are
     * inside the shape, then all positions in the straight line between A and B are also inside
     * the shape. So in 3D a cube and a sphere are both convex hulls. Other less obvious examples
     * of convex hulls are straight lines, and single points. (A single point is a convex hull,
     * because the positions A and B must both be the same - i.e. the point itself. So the straight
     * line between A and B has zero length.)Some examples of shapes that are NOT convex hulls are donuts, and horseshoes.
     *  @param points
     *  @return
     */
	// List<double> getCodomainConvexHull(List<double> points) throws Exception ;
	/**
     * Gets flags classifying domain points within a convex hull.
     *
     * The supplied ordinates are interpreted as a sequence of points, which
     * generates a convex hull in the source space. Conceptually, each of the
     * (usually infinite) points inside the convex hull is then tested against
     * the source domain. The flags of all these tests are then combined. In
     * practice, implementations of different transforms will use different
     * short-cuts to avoid doing an infinite number of tests.
     *
     *  @param points
     *  @return
     */
	// DomainFlags getDomainFlags(List<double> points) throws Exception ;
	/**
     * Creates the inverse transform of this object.
     * This method may fail if the transform is not one to one. However, all cartographic projections should succeed.
     *
     * @return math transform
     * @throws Exception the exception
     */
	func inverse() -> IMathTransform?
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point the point
     * @return double [ ]
     * @throws Exception the exception
     */
	func transform(point: [Double]) -> [Double]
	/**
     * Transforms a a coordinate. The input coordinate remains unchanged.
     *
     *  @param coordinate The coordinate to transform
     *  @return The transformed coordinate
     */
	// ICoordinate transform(ICoordinate coordinate) throws Exception ;
	/**
     * Transforms a a coordinate. The input coordinate remains unchanged.
     *
     *  @param coordinate The coordinate to transform
     *  @return The transformed coordinate
     */
	//  Coordinate transform(Coordinate coordinate) throws Exception ;
	/**
     * Transforms a list of coordinate point ordinal values.
     *
     * This method is provided for efficiently transforming many points. The supplied array
     * of ordinal values will contain packed ordinal values. For example, if the source
     * dimension is 3, then the ordinals will be packed in this order (x0,y0,z0,x1,y1,z1 ...).
     * The size of the passed array must be an integer multiple of DimSource. The returned
     * ordinal values are packed in a similar way. In some DCPs. the ordinals may be
     * transformed in-place, and the returned array may be the same as the passed array.
     * So any client code should not attempt to reuse the passed ordinal values (although
     * they can certainly reuse the passed array). If there is any problem then the server
     * implementation will throw an exception. If this happens then the client should not
     * make any assumptions about the state of the ordinal values.
     *
     * @param points the points
     * @return list
     * @throws Exception the exception
     */
	func transformList(points: [[Double]]) -> [[Double]]
	/**
     * Transforms a list of coordinates.
     *
     * This method is provided for efficiently transforming many points. The supplied array
     * of ordinal values will contain packed ordinal values. For example, if the source
     * dimension is 3, then the ordinals will be packed in this order (x0,y0,z0,x1,y1,z1 ...).
     * The size of the passed array must be an integer multiple of DimSource. The returned
     * ordinal values are packed in a similar way. In some DCPs. the ordinals may be
     * transformed in-place, and the returned array may be the same as the passed array.
     * So any client code should not attempt to reuse the passed ordinal values (although
     * they can certainly reuse the passed array). If there is any problem then the server
     * implementation will throw an exception. If this happens then the client should not
     * make any assumptions about the state of the ordinal values.
     *
     *  @param points
     *  @return
     */
	//IList<Coordinate> transformList(IList<Coordinate> points) throws Exception ;
	/**
     * Reverses the transformation
     *
     * @throws Exception the exception
     */
	func invert()
	/**
     * Transforms a coordinate sequence. The input coordinate sequence remains unchanged.
     *
     *  @param coordinateSequence The coordinate sequence to transform.
     *  @return The transformed coordinate sequence.
     */
	// ICoordinateSequence transform(ICoordinateSequence coordinateSequence) throws Exception ;
}
