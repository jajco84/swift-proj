/**
 * Latitude, Longitude and ellipsoidal height in terms of a 3-dimensional geographic system
 * may by expressed in terms of a geocentric (earth centered) Cartesian coordinate reference system
 * X, Y, Z with the Z axis corresponding to the earth's rotation axis positive northwards, the X
 * axis through the intersection of the prime meridian and equator, and the Y axis through
 * the intersection of the equator with longitude 90 degrees east. The geographic and geocentric
 * systems are based on the same geodetic datum.Geocentric coordinate reference systems are conventionally taken to be defined with the X
 * axis through the intersection of the Greenwich meridian and equator. This requires that the equivalent
 * geographic coordinate reference systems based on a non-Greenwich prime meridian should first be
 * transformed to their Greenwich equivalent. Geocentric coordinates X, Y and Z take their units from
 * the units of the ellipsoid axes (a and b). As it is conventional for X, Y and Z to be in metres,
 * if the ellipsoid axis dimensions are given in another linear unit they should first be converted
 * to metres.
 */
import Foundation
public class GeocentricTransform: MathTransform {
	private static let cos_67P5: Double = 0.38268343236508977
	/* cosine of 67.5 degrees */private static let AD_C: Double = 1.0026000
	/* Toms region 1 constant *//**
     * The Isinverse.
     */
	internal var _isinverse: Bool = false
	/**
     * The Parameters.
     */
	internal var _Parameters: [ProjectionParameter] = [ProjectionParameter]()
	/**
     * The Inverse.
     */
	internal var _inverse: MathTransform?
	private var es: Double = 0
	// Eccentricity squared : (a^2 - b^2)/a^2
	private var semiMajor: Double = 0
	// major axis
	private var semiMinor: Double = 0
	// minor axis
	private var ab: Double = 0
	// Second eccentricity squared : (a^2 - b^2)/b^2
	// Semi_major / semi_minor
	private var ba: Double = 0
	// Semi_minor / semi_major
	private var ses: Double = 0
	/**
     * Initializes a geocentric projection object
     *
     * @param parameters List of parameters to initialize the projection.
     * @param isinverse  Indicates whether the projection forward (meters to degrees or degrees to meters).
     * @throws Exception the exception
     */
	public convenience init(_ parameters: [ProjectionParameter], _ isinverse: Bool) {
		self.init(parameters)
		_isinverse = isinverse
	}
	/**
     * Initializes a geocentric projection object
     *
     * @param parameters List of parameters to initialize the projection.
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter]) {
		super.init()
		_Parameters = parameters
		for p: ProjectionParameter in _Parameters {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_major" {
				semiMajor = p.getValue()
				break
			}
		}
		for p: ProjectionParameter in _Parameters {
			if p.getName().lowercased().replacingOccurrences(of: " ", with: "_") == "semi_minor" {
				semiMinor = p.getValue()
				break
			}
		}
		es = 1.0 - (semiMinor * semiMinor) / (semiMajor * semiMajor)
		// e^2
		ses = (pow(semiMajor, 2) - pow(semiMinor, 2)) / pow(semiMinor, 2)
		ba = semiMinor / semiMajor
		ab = semiMajor / semiMinor
	}
	public override func getDimSource() -> Int { return 3 }
	public override func getDimTarget() -> Int { return 3 }
	/**
     * Returns the inverse of this conversion.
     *
     * @return IMathTransform that is the reverse of the current conversion.
     */
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let t = GeocentricTransform(self._Parameters, !_isinverse)
            self._inverse = t
            return t
        }
        return _inverse

//		if _inverse == nil { _inverse = GeocentricTransform(self._Parameters, !_isinverse) }
//		return _inverse!
	}
	/**
     * Converts coordinates in decimal degrees to projected meters.
     *
     * @param lonlat The point in decimal degrees.
     * @return Point in projected meters
     */
	private func degreesToMeters(lonlat: [Double]) -> [Double] {
		let lon: Double = GeocentricTransform.degrees2Radians(deg: lonlat[0])
		let lat: Double = GeocentricTransform.degrees2Radians(deg: lonlat[1])
		let h: Double = lonlat.count < 3 ? 0 : ((lonlat[2]).isNaN ? 0 : lonlat[2])
        let v: Double = semiMajor / sqrt(1.0 - es * pow(sin(lat), 2))
		let x: Double = (v + h) * cos(lat) * cos(lon)
		let y: Double = (v + h) * cos(lat) * sin(lon)
		let z: Double = ((1 - es) * v + h) * sin(lat)
		return [x, y, z]
	}
	/**
     * Converts coordinates in projected meters to decimal degrees.
     *
     * @param pnt Point in meters
     * @return Transformed point in decimal degrees
     */
	private func metersToDegrees(pnt: [Double]) -> [Double] {
		var At_Pole: Bool = false
		// indicates whether location is in polar region */
		let Z: Double = pnt.count < 3 ? 0 : (pnt[2].isNaN ? 0 : pnt[2])
		var lon: Double = 0
		var lat: Double = 0
		var Height: Double = 0
		if pnt[0] != 0.0 {
			lon = atan2(pnt[1], pnt[0])
		} else {
			if pnt[1] > 0 {
				lon = Double.pi / 2
			} else if pnt[1] < 0 {
				lon = -Double.pi * 0.5
			} else {
				At_Pole = true
				lon = 0.0
				if Z > 0.0 {
					/* north pole */lat = Double.pi * 0.5
				} else if Z < 0.0 {
					/* south pole */lat = -Double.pi * 0.5
				} else {
					return [GeocentricTransform.radians2Degrees(rad: lon), GeocentricTransform.radians2Degrees(rad: Double.pi * 0.5), -semiMinor]
				}
			}
		}
		/* center of earth */let W2: Double = pnt[0] * pnt[0] + pnt[1] * pnt[1]
		// Square of distance from Z axis
		let W: Double = sqrt(W2)
		// distance from Z axis
		let T0: Double = Z * GeocentricTransform.AD_C
		// initial estimate of vertical component
		let S0: Double = sqrt(T0 * T0 + W2)
		// initial estimate of horizontal component
		let sin_B0: Double = T0 / S0
		// sin(B0), B0 is estimate of Bowring aux variable
		let cos_B0: Double = W / S0
		// cos(B0)
		let sin3_B0: Double = pow(sin_B0, 3)
		let T1: Double = Z + semiMinor * ses * sin3_B0
		// corrected estimate of vertical component
		let Sum: Double = W - semiMajor * es * cos_B0 * cos_B0 * cos_B0
		// numerator of cos(phi1)
		let S1: Double = sqrt(T1 * T1 + Sum * Sum)
		// corrected estimate of horizontal component
		let sin_p1: Double = T1 / S1
		// sin(phi1), phi1 is estimated latitude
		let cos_p1: Double = Sum / S1
		// cos(phi1)
		let Rn: Double = semiMajor / sqrt(1.0 - es * sin_p1 * sin_p1)
		// Earth radius at location
		if cos_p1 >= GeocentricTransform.cos_67P5 {
			Height = W / cos_p1 - Rn
		} else if cos_p1 <= -GeocentricTransform.cos_67P5 {
			Height = W / -cos_p1 - Rn
		} else {
			Height = Z / sin_p1 + Rn * (es - 1.0)
		}
		if !At_Pole { lat = atan(sin_p1 / cos_p1) }
		return [GeocentricTransform.radians2Degrees(rad: lon), GeocentricTransform.radians2Degrees(rad: lat), Height]
	}
	/**
     * Transforms a coordinate point. The passed parameter point should not be modified.
     *
     * @param point
     * @return
     */
	public override func transform(point: [Double]) -> [Double] {
		if !_isinverse { return degreesToMeters(lonlat: point) }
		return metersToDegrees(pnt: point)
	}
	/**
     * Transforms a list of coordinate point ordinal values.
     *
     * @param points
     * @return This method is provided for efficiently transforming many points. The supplied array
     * of ordinal values will contain packed ordinal values. For example, if the source
     * dimension is 3, then the ordinals will be packed in this order (x0,y0,z0,x1,y1,z1 ...).
     * The size of the passed array must be an integer multiple of DimSource. The returned
     * ordinal values are packed in a similar way. In some DCPs. the ordinals may be
     * transformed in-place, and the returned array may be the same as the passed array.
     * So any client code should not attempt to reuse the passed ordinal values (although
     * they can certainly reuse the passed array). If there is any problem then the server
     * implementation will throw an exception. If this happens then the client should not
     * make any assumptions about the state of the ordinal values.
     */
	public override func transformList(points: [[Double]]) -> [[Double]] {
		var result: [[Double]] = [[Double]]()
		for i in 0..<points.count {
			let point: [Double] = points[i]
			result.append(transform(point: point))
		}
		return result
	}
	/**
     * Reverses the transformation
     */
    public override func invert() {
//        _isinverse = !_isinverse
        _isinverse.toggle()
    }
	/**
     * Gets a Well-Known text representation of this object.
     */
	public override func getWKT() -> String { return "" }
	/**
     * Gets an XML representation of this object.
     */
	public override func getXML() -> String { return "" }
}
