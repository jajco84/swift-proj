// Creates an math transform based on the supplied Well Known Text (WKT).
public class MathTransformWktReader {
	/* *
     * Reads and parses a WKT-formatted projection string.
     *
     * @param wkt String containing WKT.
     * @return Object representation of the WKT.
     * @throws Exception the exception
     */
	public class func parse(wkt: String) -> IMathTransform? {
        if wkt.isEmpty { return nil }
        let reader: StringReader = StringReader(string: wkt)
		// , encoding);
		let tokenizer: WktStreamTokenizer = WktStreamTokenizer(reader)
		_ = tokenizer.nextToken()
		let objectName: String = tokenizer.getStringValue()
		if objectName == "PARAM_MT" {
			return readMathTransform(tokenizer: tokenizer)
		} else {
			return nil
		}
	}
	/* *
     * Reads math transform from using current token from the specified tokenizer
     *
     * @param tokenizer the tokenizer
     * @return math transform
     * @throws Exception the exception
     */
	public class func readMathTransform(tokenizer: WktStreamTokenizer) -> IMathTransform? {
		if tokenizer.getStringValue() != "PARAM_MT" { tokenizer.readToken(expectedToken: "PARAM_MT") }
		tokenizer.readToken(expectedToken: "[")
		let transformName: String = tokenizer.readDoubleQuotedWord()
		tokenizer.readToken(expectedToken: ",")
		let str: String = transformName.uppercased()
		if str == "AFFINE" {
			return readAffineTransform(tokenizer: tokenizer)
		} else {
			return nil
		}
	}
	private class func readParameters(tokenizer: WktStreamTokenizer) -> IParameterInfo {
		var paramList: [Parameter] = [Parameter]()
		while tokenizer.getStringValue() == "PARAMETER" {
			tokenizer.readToken(expectedToken: "[")
			let paramName: String = tokenizer.readDoubleQuotedWord()
			tokenizer.readToken(expectedToken: ",")
			_ = tokenizer.nextToken()
			let paramValue: Double = tokenizer.getNumericValue()
			tokenizer.readToken(expectedToken: "]")
			// test, whether next parameter is delimited by comma
			_ = tokenizer.nextToken()
			if tokenizer.getStringValue() != "]" {
                _ = tokenizer.nextToken()
            }
			paramList.append(Parameter(paramName, paramValue))
		}
		let info: IParameterInfo = ParameterInfo()
		info.setParameters(value: paramList)
		return info
	}
	private class func readAffineTransform(tokenizer: WktStreamTokenizer) -> IMathTransform? {
		/*
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
         PARAMETER["elt_2_2", 1]
         ]
         */// tokenizer stands on the first PARAMETER
		if tokenizer.getStringValue() != "PARAMETER" { tokenizer.readToken(expectedToken: "PARAMETER") }
		let paramInfo: IParameterInfo = readParameters(tokenizer: tokenizer)
		// manage required parameters - row, col
//		let rowParam: Parameter? = paramInfo.getParameterByName(name: "num_row")
//		let colParam: Parameter? = paramInfo.getParameterByName(name: "num_col")
//		if rowParam == nil { return nil }
//		if colParam == nil { return nil }
        guard let rowParam = paramInfo.getParameterByName(name: "num_row"),
            let colParam = paramInfo.getParameterByName(name: "num_col") else { return nil }

		let rowVal: Int = Int(rowParam.getValue())
        let colVal: Int = Int(colParam.getValue())
		if rowVal <= 0 { return nil }
		if colVal <= 0 { return nil }
		// creates working matrix;
		var matrix: [[Double]] = [[Double]]()
		for param: Parameter in paramInfo.getParameters()! {
			// simply process matrix values - no elt_ROW_COL parsing
            let __dummyScrutVar2: String = param.getName()
			if __dummyScrutVar2 == "num_row" || __dummyScrutVar2 == "num_col" {
			} else if __dummyScrutVar2 == "elt_0_0" {
				matrix[0][0] = param.getValue()
			} else if __dummyScrutVar2 == "elt_0_1" {
				matrix[0][1] = param.getValue()
			} else if __dummyScrutVar2 == "elt_0_2" {
				matrix[0][2] = param.getValue()
			} else if __dummyScrutVar2 == "elt_0_3" {
				matrix[0][3] = param.getValue()
			} else if __dummyScrutVar2 == "elt_1_0" {
				matrix[1][0] = param.getValue()
			} else if __dummyScrutVar2 == "elt_1_1" {
				matrix[1][1] = param.getValue()
			} else if __dummyScrutVar2 == "elt_1_2" {
				matrix[1][2] = param.getValue()
			} else if __dummyScrutVar2 == "elt_1_3" {
				matrix[1][3] = param.getValue()
			} else if __dummyScrutVar2 == "elt_2_0" {
				matrix[2][0] = param.getValue()
			} else if __dummyScrutVar2 == "elt_2_1" {
				matrix[2][1] = param.getValue()
			} else if __dummyScrutVar2 == "elt_2_2" {
				matrix[2][2] = param.getValue()
			} else if __dummyScrutVar2 == "elt_2_3" {
				matrix[2][3] = param.getValue()
			} else if __dummyScrutVar2 == "elt_3_0" {
				matrix[3][0] = param.getValue()
			} else if __dummyScrutVar2 == "elt_3_1" {
				matrix[3][1] = param.getValue()
			} else if __dummyScrutVar2 == "elt_3_2" {
				matrix[3][2] = param.getValue()
			} else if __dummyScrutVar2 == "elt_3_3" {
				matrix[3][3] = param.getValue()
			} else {
			}
		}
		// unknown parameter
		// read rest of WKT
		if tokenizer.getStringValue() != "]" { tokenizer.readToken(expectedToken: "]") }
		// use "matrix" constructor to create transformation matrix
        let affineTransform: IMathTransform = AffineTransform(m: matrix)
		return affineTransform
	}
}
