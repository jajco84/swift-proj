/// Represents affine math transform which ttransform input coordinates to target using affine transformation matrix. Dimensionality might change.
/// If the transform's input dimension is M, and output dimension is N, then the matrix will have size [N+1][M+1].
/// The +1 in the matrix dimensions allows the matrix to do a shift, as well as a rotation.
/// The [M][j] element of the matrix will be the j'th ordinate of the moved origin.
/// The [i][N] element of the matrix will be 0 for i less than M, and 1 for i equals M.
/// *
public class AffineTransform: MathTransform {
	/**
     * Saved inverse transform
     */
	private var _inverse: IMathTransform?
	/**
     * Dimension of source points - it's related to number of transformation matrix rows
     */
	private var dimSource: Int
	/**
     * Dimension of output points - it's related to number of columns
     */
	private var dimTarget: Int
	/**
     * Represents transform matrix of this affine transformation from input points to output ones using dimensionality defined within the affine transform
     * Number of rows = dimTarget + 1
     * Number of columns = dimSource + 1
     */
	private var transformMatrix: [[Double]]
	/**
     * Creates instance of 2D affine transform (source dimensionality 2, target dimensionality 2) using the specified values
     *
     * @param m00 Value for row 0, column 0 - AKA ScaleX
     * @param m01 Value for row 0, column 1 - AKA ShearX
     * @param m02 Value for row 0, column 2 - AKA Translate X
     * @param m10 Value for row 1, column 0 - AKA Shear Y
     * @param m11 Value for row 1, column 1 - AKA Scale Y
     * @param m12 Value for row 1, column 2 - AKA Translate Y
     * @throws Exception the exception
     */
	public init(_ m00: Double, _ m01: Double, _ m02: Double, _ m10: Double, _ m11: Double, _ m12: Double) {
		// fill dimensionlity
		dimSource = 2
		dimTarget = 2
		// create matrix - 2D affine transform uses 3x3 matrix (3rd row is the special one)
		// transformMatrix = Double[][]{{m00, m01, m02}, {m10, m11, m12}, {0, 0, 1}};
		transformMatrix = [[Double]]()
		transformMatrix.append([m00, m01, m02])
		transformMatrix.append([m10, m11, m12])
		transformMatrix.append([0, 0, 1])
		super.init()
	}
	public init(m: [[Double]]) {
		dimSource = m[0].count - 1
		dimTarget = m[1].count - 1
		transformMatrix = m
	}
	/**
     * Given L,U,P and b solve for x.
     * Input the L and U matrices as a single matrix LU.
     * Return the solution as a double[].
     * LU will be a n+1xm+1 matrix where the first row and columns are zero.
     * This is for ease of computation and consistency with Cormen et al.
     * pseudocode.
     * The pi array represents the permutation matrix.
     *
     * @param LU
     * @param pi
     * @param b
     * @return
     * @see
     */
	private class func lUPSolve(LU: [[Double]], _ pi: [Int], _ b: [Double]) -> [Double] {
		let n: Int = LU[0].count - 1
		var x: [Double] = [Double]()  // [n + 1];
		var y: [Double] = [Double]()  // [n + 1];
		var suml: Double = 0
		var sumu: Double = 0
		var lij: Double = 0
		for i in 0...n {
            /*
             * Solve for y using formward substitution
             *
             */
            suml = 0
            for j in 0...i - 1 {
                /*
                 * since we've taken L and U as a singular matrix as an input
                 * the value for L at index i and j will be 1 when i equals j, not LU[i][j], since
                 * the diagonal values are all 1 for L.
                 * */
                if i == j {
                    lij = 1
                } else {
                    lij = LU[i][j]
                }
//                suml = suml + (lij * y[j])
                suml += (lij * y[j])
            }
            y[i] = b[pi[i]] - suml
        }
		// for i : Int i = n; i >= 0; i-- {
		for i in (0...n).reversed() {
			// Solve for x by using back substitution
			sumu = 0
			// for  var j : Int = i + 1; j <= n; j++ {
            for j in i + 1...n {
//                sumu = sumu + (LU[i][j] * x[j])
                sumu += (LU[i][j] * x[j])
            }
			x[i] = (y[i] - sumu) / LU[i][i]
		}
		return x
	}
	/**
     * Perform LUP decomposition on a matrix A.
     * Return L and U as a single matrix(double[][]) and P as an array of ints.
     * We implement the code to compute LU "in place" in the matrix A.
     * In order to make some of the calculations more straight forward and to
     * match Cormen's et al. pseudocode the matrix A should have its first row and first columns
     * to be all 0.
     *
     * @param A
     * @return
     * @see
     */
	private class func lUPDecomposition(AA: [[Double]]) -> ([[Double]], [Int]) {
		var A = AA
		let n: Int = A[0].count - 1
		/*
                    * pi represents the permutation matrix.  We implement it as an array
                    * whose value indicates which column the 1 would appear.  We use it to avoid
                    * dividing by zero or small numbers.
                    * */
        var pi: [Int] = [Int]()  // int[n + 1];
		var p: Double = 0
		var kp: Int = 0
		var pik: Int = 0
		var pikp: Int = 0
		var aki: Double = 0
		var akpi: Double = 0
		// for  var j : Int = 0; j <= n; j++ {
		for j in 0...n {
			// Initialize the permutation matrix, will be the identity matrix
			pi[j] = j
		}
		// for  var k : Int = 0; k <= n; k++ {
		for k in 0...n {
			/*
                            * In finding the permutation matrix p that avoids dividing by zero
                            * we take a slightly different approach.  For numerical stability
                            * We find the element with the largest
                            * absolute value of those in the current first column (column k).  If all elements in
                            * the current first column are zero then the matrix is singluar and throw an
                            * error.
                            * */
            p = 0
			// for  var i : Int = k; i <= n; i++ {
			for i in k...n {
				if abs(A[i][k]) > p {
					p = abs(A[i][k])
					kp = i
				}
			}
			if p == 0 {
				//  throwException() /* throw Exception("singular matrix"); */
			}
            /*
             * These lines update the pivot array (which represents the pivot matrix)
             * by exchanging pi[k] and pi[kp].
             * */
            pik = pi[k]
			pikp = pi[kp]
			pi[k] = pikp
			pi[kp] = pik
			// for  var i : Int = 0; i <= n; i++ {
			for i in 0...n {
                /*
                 * Exchange rows k and kpi as determined by the pivot
                 * */
                aki = A[k][i]
                akpi = A[kp][i]
                A[k][i] = akpi
                A[kp][i] = aki
			}
			// for  var i : Int = k + 1; i <= n; i++ {
            for i in k + 1...n {
                /*
                 * Compute the Schur complement
                 * */
//                A[i][k] = A[i][k] / A[k][k]
                A[i][k] /= A[k][k]
                // for  var j : Int = k + 1; j <= n; j++ {
                for j in k + 1...n {
//                    A[i][j] = A[i][j] - (A[i][k] * A[k][j])
                    A[i][j] -= (A[i][k] * A[k][j])
                }
            }
		}
		return (A, pi)
	}
	/**
     * Given an nXn matrix A, solve n linear equations to find the inverse of A.
     *
     * @param A
     * @return
     * @see
     */
	private class func invertMatrix(AA: [[Double]]) -> [[Double]] {
		let A = AA
		let n: Int = A[0].count
		var _: Int = A[1].count
		// x will hold the inverse matrix to be returned
		var x: [[Double]] = [[Double]]()
		/*
                    * solve will contain the vector solution for the LUP decomposition as we solve
                    * for each vector of x.  We will combine the solutions into the double[][] array x.
                    * */
        var solve: [Double]
		// Get the LU matrix and P matrix (as an array)
		let results: ([[Double]], [Int]) = lUPDecomposition(AA: A)
		let LU: [[Double]] = results.0
		// .getKey();
		let P: [Int] = results.1
		// .getValue();
		// for  var i : Int = 0; i < n; i++ {
		for i in 0..<n {
			/*
                        * Solve AX = e for each column ei of the identity matrix using LUP decomposition
                        * */// e will represent each column in the identity matrix
			var e: [Double] = [Double]()
			e[i] = 1
			solve = lUPSolve(LU: LU, P, e)
			// for  var j : Int = 0; j < solve.length; j++ {
			for j in 0..<solve.count { x[j][i] = solve[j] }
		}
		return x
	}
	/**
     * Gets the dimension of input points.
     */
	public override func getDimSource() -> Int { return dimSource }
	/**
     * Gets the dimension of output points.
     */
	public override func getDimTarget() -> Int { return dimTarget }
	/**
     * Return affine transformation matrix as group of parameter values that maiy be used for retrieving WKT of this affine transform
     *
     * @return List of string pairs NAME VALUE
     */
	private func getParameterValues() -> [ProjectionParameter] {
		let rowCnt: Int = transformMatrix[0].count
		let colCnt: Int = transformMatrix[1].count
		var pInfo: [ProjectionParameter] = [ProjectionParameter]()
		pInfo.append(ProjectionParameter("num_row", rowCnt))
		pInfo.append(ProjectionParameter("num_col", colCnt))
		// for  var row : Int = 0; row < rowCnt; row++ {
		for row in 0..<rowCnt {
			// for  var col : Int = 0; col < colCnt; col++ {
			for col in 0..<colCnt {
				// fill matrix values
				let name: String = "elt_\(row)_\(col)"
				pInfo.append(ProjectionParameter(name, transformMatrix[row][col]))
			}
		}
		return pInfo
	}
	/**
     * Returns the inverse of this affine transformation.
     *
     * @return IMathTransform that is the reverse of the current affine transformation.
     */
	public override func inverse() -> IMathTransform {
		guard let _inverse else {
			// find the inverse transformation matrix - use cloned matrix array
			// remarks about dimensionality: if input dimension is M, and output dimension is N, then the matrix will have size [N+1][M+1].
			let invMatrix: [[Double]] = AffineTransform.invertMatrix(AA: clonematrix(m: transformMatrix))
            let trans = AffineTransform(m: invMatrix)
            self._inverse = trans
            return trans
		}
		return _inverse
	}
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point point
     * @return point
     */
	public override func transform(point: [Double]) -> [Double] {
		// check source dimensionality - alow coordinate clipping, if source dimensionality is greater then expected source dimensionality of affine transformation
		if point.count >= dimSource {
			// use transformation matrix to create output points that has dimTarget dimensionality
			var transformed: [Double] = [Double]()  // [dimTarget];
			// for  var row : Int = 0; row < dimTarget; row++ {
			for row in 0..<dimTarget {
				// count each target dimension using the apropriate row
				// start with the last value which is in fact multiplied by 1
				var dimVal: Double = transformMatrix[row][dimSource]
				// for  var col : Int = 0; col < dimSource; col++ {
				for col in 0..<dimSource { dimVal += transformMatrix[row][col] * point[col] }
				transformed[row] = dimVal
			}
			return transformed
		}
		return [Double]()
	}
	// nepodporovane
	/**
     * Returns this affine transform as an affine transform matrix.
     *
     * @return point double [ ] [ ]
     * @throws Exception the exception
     */
	public func getMatrix() -> [[Double]] { return clonematrix(m: transformMatrix) }
	func clonematrix(m: [[Double]]) -> [[Double]] {
		var r: [[Double]] = [[Double]]()
		for i in 0..<m.count {
			var l: [Double] = [Double]()
			for j in 0..<r[i].count { l.append(r[i][j]) }
			r.append(l)
		}
		return r
	}
}
