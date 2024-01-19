// Creates an object based on the supplied Well Known Text (WKT).
public class CoordinateSystemWktReader {
	/**
     * Reads and parses a WKT-formatted projection string.
     *
     * @param wkt String containing WKT.
     * @return Object representation of the WKT.
     * @throws Exception If a token is not recognised.
     */
	public class func parse(wkt: String) -> IInfo? {
		// if (wkt == nil || wkt == "")
		//   throwException() /* throw Exception("empty wkt"); */
		let reader: StringReader = StringReader(string: wkt)
		let tokenizer: WktStreamTokenizer = WktStreamTokenizer(reader)
		_ = tokenizer.nextToken()
		let objectName: String = tokenizer.getStringValue()
		if objectName == "UNIT" {
			return readUnit(tokenizer: tokenizer)
		} else if objectName == "SPHEROID" {
			return readEllipsoid(tokenizer: tokenizer)
		} else if objectName == "DATUM" {
			return readHorizontalDatum(tokenizer: tokenizer)
		} else if objectName == "PRIMEM" {
			return readPrimeMeridian(tokenizer: tokenizer)
		} else if objectName == "VERT_CS" || objectName == "GEOGCS" || objectName == "PROJCS" || objectName == "COMPD_CS" || objectName == "GEOCCS" || objectName == "FITTED_CS" || objectName == "LOCAL_CS" {
			return readCoordinateSystem(coordinateSystem: wkt, tokenizer)
		} else {
			// throwException() /* throw IllegalArgumentException(String.format("'%s' is not recognized.", objectName)); */
		}
		return nil
	}
	/**
     * Returns a IUnit given a piece of WKT.
     *
     * @param tokenizer WktStreamTokenizer that has the WKT.
     * @return An object that implements the IUnit interface.
     */
	private class func readUnit(tokenizer: WktStreamTokenizer) -> IUnit {
		tokenizer.readToken(expectedToken: "[")
        let unitName: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
        let unitsPerUnit: Double = tokenizer.getNumericValue()
		var authority: String = ""
		var authorityCode: Int = -1
		_ = tokenizer.nextToken()
		if tokenizer.getStringValue() == "," {
            let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		return Unit(unitsPerUnit, unitName, authority, authorityCode, "", "", "")
	}
	/**
     * Returns a
     * {LinearUnit}
     * given a piece of WKT.
     *
     * @param tokenizer WktStreamTokenizer that has the WKT.
     * @return An object that implements the IUnit interface.
     */
	private class func readLinearUnit(tokenizer: WktStreamTokenizer) -> ILinearUnit {
		tokenizer.readToken(expectedToken: "[")
		let unitName: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
		let unitsPerUnit: Double = tokenizer.getNumericValue()
		var authority: String = ""
		var authorityCode: Int = -1
		_ = tokenizer.nextToken()
		if tokenizer.getStringValue() == "," {
			let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		return LinearUnit(unitsPerUnit, unitName, authority, authorityCode, "", "", "")
	}
	/**
     * Returns a
     * {AngularUnit}
     * given a piece of WKT.
     *
     * @param tokenizer WktStreamTokenizer that has the WKT.
     * @return An object that implements the IUnit interface.
     */
	private class func readAngularUnit(tokenizer: WktStreamTokenizer) -> IAngularUnit {
		tokenizer.readToken(expectedToken: "[")
		let unitName: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
		let unitsPerUnit: Double = tokenizer.getNumericValue()
		var authority: String = ""
		var authorityCode: Int = -1
		_ = tokenizer.nextToken()
		if tokenizer.getStringValue() == "," {
			let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		return AngularUnit(unitsPerUnit, unitName, authority, authorityCode, "", "", "")
	}
	/**
     * Returns a
     * {Axisinfo}
     * given a piece of WKT.
     *
     * @param tokenizer WktStreamTokenizer that has the WKT.
     * @return An Axisinfo object.
     */
	private class func readAxis(tokenizer: WktStreamTokenizer) -> AxisInfo? {
		if tokenizer.getStringValue() != "AXIS" { tokenizer.readToken(expectedToken: "AXIS") }
		tokenizer.readToken(expectedToken: "[")
		let axisName: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
		let unitname: String = tokenizer.getStringValue().uppercased()
		tokenizer.readToken(expectedToken: "]")
		if unitname == "DOWN" {
			return AxisInfo(axisName, AxisOrientationEnum.Down)
		} else if unitname == "EAST" {
			return AxisInfo(axisName, AxisOrientationEnum.East)
		} else if unitname == "NORTH" {
			return AxisInfo(axisName, AxisOrientationEnum.North)
		} else if unitname == "OTHER" {
			return AxisInfo(axisName, AxisOrientationEnum.Other)
		} else if unitname == "SOUTH" {
			return AxisInfo(axisName, AxisOrientationEnum.South)
		} else if unitname == "UP" {
			return AxisInfo(axisName, AxisOrientationEnum.Up)
		} else if unitname == "WEST" {
			return AxisInfo(axisName, AxisOrientationEnum.West)
		} else {
			// throwException() /* throw IllegalArgumentException("Invalid axis name '" + unitname + "' in WKT"); */
		}
		return nil
	}
	private class func readCoordinateSystem(coordinateSystem: String, _ tokenizer: WktStreamTokenizer) -> ICoordinateSystem? {
		let cstype: String = tokenizer.getStringValue()
		if cstype == "GEOGCS" {
			return readGeographicCoordinateSystem(tokenizer: tokenizer)
		} else if cstype == "PROJCS" {
			return readProjectedCoordinateSystem(tokenizer: tokenizer)
		} else if cstype == "FITTED_CS" {
			return readFittedCoordinateSystem(tokenizer: tokenizer)
		} else if cstype == "COMPD_CS" || cstype == "VERT_CS" || cstype == "GEOCCS" || cstype == "LOCAL_CS" {
			// throwException() /* throw Exception(String.format("%s coordinate system is not supported.", coordinateSystem)); */
		} else {
			// throwException() /* throw Exception(String.format("%s coordinate system is not recognized.", coordinateSystem)); */
		}
		return nil
	}
	// Reads either 3, 6 or 7 parameter Bursa-Wolf values from TOWGS84 token
	private class func readWGS84ConversionInfo(tokenizer: WktStreamTokenizer) -> Wgs84ConversionInfo {
		// TOWGS84[0,0,0,0,0,0,0]
		tokenizer.readToken(expectedToken: "[")
        let info: Wgs84ConversionInfo = Wgs84ConversionInfo()
		_ = tokenizer.nextToken()
		info.Dx = tokenizer.getNumericValue()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
		info.Dy = tokenizer.getNumericValue()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
		info.Dz = tokenizer.getNumericValue()
		_ = tokenizer.nextToken()
		if tokenizer.getStringValue() == "," {
			_ = tokenizer.nextToken()
			info.Ex = tokenizer.getNumericValue()
			tokenizer.readToken(expectedToken: ",")
			_ = tokenizer.nextToken()
			info.Ey = tokenizer.getNumericValue()
			tokenizer.readToken(expectedToken: ",")
			_ = tokenizer.nextToken()
			info.Ez = tokenizer.getNumericValue()
			_ = tokenizer.nextToken()
			if tokenizer.getStringValue() == "," {
				_ = tokenizer.nextToken()
				info.Ppm = tokenizer.getNumericValue()
			}
		}
		if tokenizer.getStringValue() != "]" { tokenizer.readToken(expectedToken: "]") }
		return info
	}
	private class func readEllipsoid(tokenizer: WktStreamTokenizer) -> IEllipsoid {
		// SPHEROID["Airy 1830",6377563.396,299.3249646,AUTHORITY["EPSG","7001"]]
		tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
        let majorAxis: Double = tokenizer.getNumericValue()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
        let e: Double = tokenizer.getNumericValue()
		_ = tokenizer.nextToken()
		var authority: String = ""
		var authorityCode: Int = -1
		if tokenizer.getStringValue() == "," {
			// Read authority
            let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		let ellipsoid: IEllipsoid = Ellipsoid(majorAxis, 0.0, e, true, LinearUnit.getMetre(), name, authority, authorityCode, "", "", "")
		return ellipsoid
	}
	private class func readProjection(tokenizer: WktStreamTokenizer) -> IProjection {
		if tokenizer.getStringValue() != "PROJECTION" { tokenizer.readToken(expectedToken: "PROJECTION") }
		tokenizer.readToken(expectedToken: "[")
		// [
		let projectionName: String = tokenizer.readDoubleQuotedWord()
		var authority: String = ""
		var authorityCode: Int = -1
		_ = tokenizer.nextToken(ignoreWhitespace: true)
		if tokenizer.getStringValue() == "," {
			let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		tokenizer.readToken(expectedToken: ",")
		// ,
		tokenizer.readToken(expectedToken: "PARAMETER")
		var paramList: [ProjectionParameter] = [ProjectionParameter]()
		while tokenizer.getStringValue() == "PARAMETER" {
			tokenizer.readToken(expectedToken: "[")
			let paramName: String = tokenizer.readDoubleQuotedWord()
			tokenizer.readToken(expectedToken: ",")
			_ = tokenizer.nextToken()
			let paramValue: Double = tokenizer.getNumericValue()
			tokenizer.readToken(expectedToken: "]")
			tokenizer.readToken(expectedToken: ",")
			paramList.append(ProjectionParameter(paramName, paramValue))
			_ = tokenizer.nextToken()
		}
		let projection: IProjection = Projection(projectionName, paramList, projectionName, authority, authorityCode, "", "", "")
		return projection
	}
	private class func readProjectedCoordinateSystem(tokenizer: WktStreamTokenizer) -> IProjectedCoordinateSystem {
		/*PROJCS[
         "OSGB 1936 / British National Grid",
         GEOGCS[
         "OSGB 1936",
         DATUM[...]
         PRIMEM[...]
         AXIS["Geodetic latitude","NORTH"]
         AXIS["Geodetic longitude","EAST"]
         AUTHORITY["EPSG","4277"]
         ],
         PROJECTION["Transverse Mercator"],
         PARAMETER["latitude_of_natural_origin",49],
         PARAMETER["longitude_of_natural_origin",-2],
         PARAMETER["scale_factor_at_natural_origin",0.999601272],
         PARAMETER["false_easting",400000],
         PARAMETER["false_northing",-100000],
         AXIS["Easting","EAST"],
         AXIS["Northing","NORTH"],
         AUTHORITY["EPSG","27700"]
         ]
         */
        tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "GEOGCS")
        let geographicCS: IGeographicCoordinateSystem = readGeographicCoordinateSystem(tokenizer: tokenizer)
		tokenizer.readToken(expectedToken: ",")
		var projection: IProjection? = nil
		var unit: IUnit? = nil
		var axes: [AxisInfo] = [AxisInfo]()
		var authority: String = ""
		var authorityCode: Int = -1
		var ct: TokenType = tokenizer.nextToken()
		while ct != TokenType.Eol && ct != TokenType.Eof {
            let token: String = tokenizer.getStringValue()
			if token == "," || token == "]" {
			} else if token == "PROJECTION" {
				projection = readProjection(tokenizer: tokenizer)
				ct = tokenizer.getTokenType()
				continue
			} else  // break;
			if token == "UNIT" {
				unit = readLinearUnit(tokenizer: tokenizer)
			} else if token == "AXIS" {
				axes.append(readAxis(tokenizer: tokenizer)!)
				_ = tokenizer.nextToken()
			} else if token == "AUTHORITY" {
                let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
				authority = auth.authority
				authorityCode = auth.authorityCode
			}
			// tokenizer.ReadToken("]");
			ct = tokenizer.nextToken()
		}
		// This is default axis values if not specified.
		if axes.isEmpty {
			axes.append(AxisInfo("X", AxisOrientationEnum.East))
			axes.append(AxisInfo("Y", AxisOrientationEnum.North))
		}
        let projectedCS: IProjectedCoordinateSystem = ProjectedCoordinateSystem(geographicCS.getHorizontalDatum(), geographicCS, unit as! ILinearUnit, projection!, axes, name, authority, authorityCode, "", "", "")
		return projectedCS
	}
	private class func readGeographicCoordinateSystem(tokenizer: WktStreamTokenizer) -> IGeographicCoordinateSystem {
		/*
         GEOGCS["OSGB 1936",
         DATUM["OSGB 1936",SPHEROID["Airy 1830",6377563.396,299.3249646,AUTHORITY["EPSG","7001"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6277"]]
         PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]]
         AXIS["Geodetic latitude","NORTH"]
         AXIS["Geodetic longitude","EAST"]
         AUTHORITY["EPSG","4277"]
         ]
         */
        tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "DATUM")
        let horizontalDatum: IHorizontalDatum = readHorizontalDatum(tokenizer: tokenizer)
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "PRIMEM")
        let primeMeridian: IPrimeMeridian = readPrimeMeridian(tokenizer: tokenizer)
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "UNIT")
        let angularUnit: IAngularUnit = readAngularUnit(tokenizer: tokenizer)
		var authority: String = ""
		var authorityCode: Int = -1
		_ = tokenizer.nextToken()
		var info: [AxisInfo] = [AxisInfo]()
		if tokenizer.getStringValue() == "," {
			_ = tokenizer.nextToken()
			while tokenizer.getStringValue() == "AXIS" {
				info.append(readAxis(tokenizer: tokenizer)!)
				_ = tokenizer.nextToken()
				if tokenizer.getStringValue() == "," { _ = tokenizer.nextToken() }
			}
			if tokenizer.getStringValue() == "," { _ = tokenizer.nextToken() }
			if tokenizer.getStringValue() == "AUTHORITY" {
                let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
				authority = auth.authority
				authorityCode = auth.authorityCode
				tokenizer.readToken(expectedToken: "]")
			}
		}
		// This is default axis values if not specified.
		if info.isEmpty {
			info.append(AxisInfo("Lon", AxisOrientationEnum.East))
			info.append(AxisInfo("Lat", AxisOrientationEnum.North))
		}
        let geographicCS: IGeographicCoordinateSystem = GeographicCoordinateSystem(angularUnit, horizontalDatum, primeMeridian, info, name, authority, authorityCode, "", "", "")
		return geographicCS
	}
	private class func readHorizontalDatum(tokenizer: WktStreamTokenizer) -> IHorizontalDatum {
		// DATUM["OSGB 1936",SPHEROID["Airy 1830",6377563.396,299.3249646,AUTHORITY["EPSG","7001"]],TOWGS84[0,0,0,0,0,0,0],AUTHORITY["EPSG","6277"]]
		var wgsinfo: Wgs84ConversionInfo? = nil
		var authority: String = ""
		var authorityCode: Int = -1
		tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "SPHEROID")
        let ellipsoid: IEllipsoid = readEllipsoid(tokenizer: tokenizer)
		_ = tokenizer.nextToken()
		while tokenizer.getStringValue() == "," {
			_ = tokenizer.nextToken()
			if tokenizer.getStringValue() == "TOWGS84" {
				wgsinfo = readWGS84ConversionInfo(tokenizer: tokenizer)
				_ = tokenizer.nextToken()
			} else if tokenizer.getStringValue() == "AUTHORITY" {
                let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
				authority = auth.authority
				authorityCode = auth.authorityCode
				tokenizer.readToken(expectedToken: "]")
			}
		}
		// make an assumption about the datum type.
        let horizontalDatum: IHorizontalDatum = HorizontalDatum(ellipsoid, wgsinfo, DatumType.HD_Geocentric, name, authority, authorityCode, "", "", "")
		return horizontalDatum
	}
	private class func readPrimeMeridian(tokenizer: WktStreamTokenizer) -> IPrimeMeridian {
		// PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]]
		tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
        let longitude: Double = tokenizer.getNumericValue()
		_ = tokenizer.nextToken()
		var authority: String = ""
		var authorityCode: Int = -1
		if tokenizer.getStringValue() == "," {
            let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
			authority = auth.authority
			authorityCode = auth.authorityCode
			tokenizer.readToken(expectedToken: "]")
		}
		// make an assumption about the Angular units - degrees.
        let primeMeridian: IPrimeMeridian = PrimeMeridian(longitude, AngularUnit.getDegrees(), name, authority, authorityCode, "", "", "")
		return primeMeridian
	}
	private class func readFittedCoordinateSystem(tokenizer: WktStreamTokenizer) -> IFittedCoordinateSystem {
		/*
         FITTED_CS[
         "Local coordinate system MNAU (based on Gauss-Krueger)",
         PARAM_MT[
         "Affine",
         PARAMETER["num_row",3],
         PARAMETER["num_col",3],
         PARAMETER["elt_0_0", 0.883485346527455],
         PARAMETER["elt_0_1", -0.468458794848877],
         PARAMETER["elt_0_2", 3455869.17937689],
         PARAMETER["elt_1_0", 0.468458794848877],
         PARAMETER["elt_1_1", 0.883485346527455],
         PARAMETER["elt_1_2", 5478710.88035753],
         PARAMETER["elt_2_2", 1],
         ],
         PROJCS["DHDN / Gauss-Kruger zone 3", GEOGCS["DHDN", DATUM["Deutsches_Hauptdreiecksnetz", SPHEROID["Bessel 1841", 6377397.155, 299.1528128, AUTHORITY["EPSG", "7004"]], TOWGS84[612.4, 77, 440.2, -0.054, 0.057, -2.797, 0.525975255930096], AUTHORITY["EPSG", "6314"]], PRIMEM["Greenwich", 0, AUTHORITY["EPSG", "8901"]], UNIT["degree", 0.0174532925199433, AUTHORITY["EPSG", "9122"]], AUTHORITY["EPSG", "4314"]], UNIT["metre", 1, AUTHORITY["EPSG", "9001"]], PROJECTION["Transverse_Mercator"], PARAMETER["latitude_of_origin", 0], PARAMETER["central_meridian", 9], PARAMETER["scale_factor", 1], PARAMETER["false_easting", 3500000], PARAMETER["false_northing", 0], AUTHORITY["EPSG", "31467"]]
         AUTHORITY["CUSTOM","12345"]
         ]
         */
		tokenizer.readToken(expectedToken: "[")
        let name: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		tokenizer.readToken(expectedToken: "PARAM_MT")
        let toBaseTransform: IMathTransform? = MathTransformWktReader.readMathTransform(tokenizer: tokenizer)
		tokenizer.readToken(expectedToken: ",")
		_ = tokenizer.nextToken()
        let baseCS: ICoordinateSystem = readCoordinateSystem(coordinateSystem: "", tokenizer)!
		var authority: String = ""
		var authorityCode: Int = -1
		var ct: TokenType = tokenizer.nextToken()
		while ct != TokenType.Eol && ct != TokenType.Eof {
            let token: String = tokenizer.getStringValue()
			if token == "," || token == "]" {
			} else if token == "AUTHORITY" {
                let auth: WktStreamTokenizer.Authority = tokenizer.readAuthority()
				authority = auth.authority
				authorityCode = auth.authorityCode
			}
			// tokenizer.ReadToken("]");
			ct = tokenizer.nextToken()
		}
        let fittedCS: IFittedCoordinateSystem = FittedCoordinateSystem(baseCS, toBaseTransform!, name, authority, authorityCode, "", "", "")
		return fittedCS
	}
}
