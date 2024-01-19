import Foundation
/// The type Hotine oblique mercator projection.
public class HotineObliqueMercatorProjection: MapProjection {
	private var _azimuth: Double = 0
	private var _sinP20: Double = 0, _cosP20: Double = 0
	private var _bl: Double = 0, _al: Double = 0
	private var _d: Double = 0, _el: Double = 0
	private var _singrid: Double = 0, _cosgrid: Double = 0
	private var _singam: Double = 0, _cosgam: Double = 0
	private var _sinaz: Double = 0, _cosaz: Double = 0
	private var _u: Double = 0

	/**
     * Instantiates a new Hotine oblique mercator projection.
     *
     * @param parameters the parameters
     * @param inverse    the inverse
     * @throws Exception the exception
     */
	public init(_ parameters: [ProjectionParameter], _ inverse: HotineObliqueMercatorProjection?) {
		super.init(parameters, inverse)
		setAuthority(value: "EPSG")
		setAuthorityCode(value: 9812)
		setName(value: "Hotine_Oblique_Mercator")
		_azimuth = Self.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "azimuth"))
		let rectifiedGridAngle: Double = Self.degrees2Radians(deg: _Parameters.getParameterValue(parameterName: "rectified_grid_angle"))
		_sinP20 = sin(lat_origin)
		_cosP20 = cos(lat_origin)
		var con: Double = 1.0 - _es * pow(_sinP20, 2)
		let com: Double = sqrt(1.0 - _es)
		_bl = sqrt(1.0 + _es * pow(_cosP20, 4.0) / (1.0 - _es))
		_al = _semiMajor * _bl * scale_factor * com / con
		var f: Double
		if abs(lat_origin) < Self.EPSLN {
			// ts = 1.0;
			_d = 1.0
			_el = 1.0
			f = 1.0
		} else {
			let ts: Double = Self.tsfnz(eccent: _e, lat_origin, _sinP20)
			con = sqrt(con)
			_d = _bl * com / (_cosP20 * con)
			if (_d * _d - 1.0) > 0.0 {
				if lat_origin >= 0.0 {
					f = _d + sqrt(_d * _d - 1.0)
				} else {
					f = _d - sqrt(_d * _d - 1.0)
				}
			} else {
				f = _d
			}
			_el = f * pow(ts, _bl)
		}
		let g: Double = 0.5 * (f - 1.0 / f)
		let gama: Double = Self.asinz(c: sin(_azimuth) / _d)
		setlon_origin(value: getlon_origin() - Self.asinz(c: g * tan(gama)) / _bl)
		con = abs(lat_origin)
		if (con > Self.EPSLN) && (abs(con - Self.HALF_PI) > Self.EPSLN) {
			_singam = sin(gama)
			_cosgam = cos(gama)
			_sinaz = sin(_azimuth)
			_cosaz = cos(_azimuth)
			if lat_origin >= 0 {
				_u = (_al / _bl) * atan(sqrt(_d * _d - 1.0) / _cosaz)
			} else {
				_u = -(_al / _bl) * atan(sqrt(_d * _d - 1.0) / _cosaz)
			}
		} else {
			// throwException() /* throw IllegalArgumentException("Input data error"); */
		}
		_singrid = sin(rectifiedGridAngle)
		_cosgrid = cos(rectifiedGridAngle)
	}
	private func getNaturalOriginOffsets() -> Bool {
		if getAuthorityCode() == 9812 { return false }
		if getAuthorityCode() == 9815 { return true }
		return true
	}
	public override func inverse() -> IMathTransform {
        guard let _inverse else {
            let transform = HotineObliqueMercatorProjection(_Parameters.toProjectionParameter(), self)
            self._inverse = transform
            return transform
        }
        return _inverse

//		if _inverse == nil { _inverse = HotineObliqueMercatorProjection(_Parameters.toProjectionParameter(), self) }
//		return _inverse!
	}
	internal override func radiansToMeters(lonlat: [Double]) -> [Double] {
		let lon: Double = lonlat[0]
		let lat: Double = lonlat[1]
		var us: Double
		var ul: Double
		// Forward equations
		// -----------------
		let sin_phi: Double = sin(lat)
		let dlon: Double = HotineObliqueMercatorProjection.adjust_lon(a: lon - getlon_origin())
		let vl: Double = sin(_bl * dlon)
		if abs(abs(lat) - HotineObliqueMercatorProjection.HALF_PI) > HotineObliqueMercatorProjection.EPSLN {
			let ts1: Double = HotineObliqueMercatorProjection.tsfnz(eccent: _e, lat, sin_phi)
			let q: Double = _el / (pow(ts1, _bl))
			let s: Double = 0.5 * (q - 1.0 / q)
			let t: Double = 0.5 * (q + 1.0 / q)
			ul = (s * _singam - vl * _cosgam) / t
			let con: Double = cos(_bl * dlon)
			if abs(con) < 0.0000001 {
				us = _al * _bl * dlon
			} else {
				us = _al * atan((s * _cosgam + vl * _singam) / con) / _bl
                if con < 0 {
//                    us = us + HotineObliqueMercatorProjection.PI * _al / _bl
                    us += HotineObliqueMercatorProjection.PI * _al / _bl
                }
			}
		} else {
			if lat >= 0 {
				ul = _singam
			} else {
				ul = -_singam
			}
			us = _al * lat / _bl
		}
		if abs(abs(ul) - 1.0) <= HotineObliqueMercatorProjection.EPSLN {
			// throwException() /* throw Exception("Point projects into infinity"); */
			return []
		}
		let vs: Double = 0.5 * _al * log((1.0 - ul) / (1.0 + ul)) / _bl
        if !getNaturalOriginOffsets() {
//            us = us - _u
            us -= _u
        }
		let x: Double = vs * _cosgrid + us * _singrid
		let y: Double = us * _cosgrid - vs * _singrid
		if lonlat.count == 2 { return [x, y] }
		return [x, y, lonlat[2]]
	}
	internal override func metersToRadians(p: [Double]) -> [Double] {
		// Inverse equations
		// -----------------
		let x: Double = p[0]
		let y: Double = p[1]
		let vs: Double = x * _cosgrid - y * _singrid
		var us: Double = y * _cosgrid + x * _singrid
        if !getNaturalOriginOffsets() {
//            us = us + _u
            us += _u
        }
		let q: Double = exp(-_bl * vs / _al)
		let s: Double = 0.5 * (q - 1.0 / q)
		let t: Double = 0.5 * (q + 1.0 / q)
		let vl: Double = sin(_bl * us / _al)
		let ul: Double = (vl * _cosgam + s * _singam) / t
		var lon: Double
		var lat: Double
		if abs(abs(ul) - 1.0) <= HotineObliqueMercatorProjection.EPSLN {
			lon = getlon_origin()
			lat = HotineObliqueMercatorProjection.sign(x: ul) * HotineObliqueMercatorProjection.HALF_PI
		} else {
			var con: Double = 1.0 / _bl
			let ts1: Double = pow((_el / sqrt((1.0 + ul) / (1.0 - ul))), con)
			lat = HotineObliqueMercatorProjection.phi2z(eccent: _e, ts1)
			con = cos(_bl * us / _al)
			let theta: Double = getlon_origin() - atan2((s * _cosgam - vl * _singam), con) / _bl
			lon = HotineObliqueMercatorProjection.adjust_lon(a: theta)
		}
		if p.count == 2 { return [lon, lat] }
		return [lon, lat, p[2]]
	}
}
