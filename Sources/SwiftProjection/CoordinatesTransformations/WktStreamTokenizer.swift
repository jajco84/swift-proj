/// Reads a stream of Well Known Text (wkt) string and returns a stream of tokens.
public class WktStreamTokenizer: StreamTokenizer {
	/**
     * Initializes a new instance of the WktStreamTokenizer class.
     * The WktStreamTokenizer class ais in reading WKT streams.
     *
     * @param reader A TextReader that contains
     * @throws Exception the exception
     */
	init(_ reader: StringReader) { super.init(reader, true) }
	/**
     * Reads a token and checks it is what is expected.
     *
     * @param expectedToken The expected token.
     * @throws Exception the exception
     */
	public func readToken(expectedToken: String) {
		_ = nextToken() /*if (!getStringValue().equals(expectedToken)) {
            var s : String = String.format("Expecting ('%s') but got a '%s' at line %d column %d.", expectedToken, getStringValue(), getLineNumber(), getColumn());
            throwException() /* throw IllegalArgumentException(s); */
        }*/
	}
	/**
     * Reads a string inside double quotes.
     *
     * White space inside quotes is preserved.
     *
     * @return The string inside the double quotes.
     * @throws Exception the exception
     */
	public func readDoubleQuotedWord() -> String {
		var word: String = ""
		if getStringValue() != "\"" { readToken(expectedToken: "\"") }
		_ = nextToken(ignoreWhitespace: false)
		while getStringValue() != "\"" {
			word += getStringValue()
			_ = nextToken(ignoreWhitespace: false)
		}
		return word
	}
	/**
     * Reads the authority and authority code.
     *
     * @return the authority
     * @throws Exception the exception
     */
	public func readAuthority() -> Authority {
		// AUTHORITY["EPGS","9102"]]
		if getStringValue() != "AUTHORITY" { readToken(expectedToken: "AUTHORITY") }
		var aut: Authority = Authority()
		readToken(expectedToken: "[")
		aut.authority = readDoubleQuotedWord()
		readToken(expectedToken: ",")
		_ = nextToken()
		if getTokenType() == TokenType.Number {
			aut.authorityCode = Int(getNumericValue())
		} else {
			// RefSupport<long> refVar___0 = new RefSupport<long>();
			// long.TryParse(readDoubleQuotedWord(), NumberStyles.Any, _nfi, refVar___0);
			// authorityCode.setValue(refVar___0.getValue());
			aut.authorityCode = Int(readDoubleQuotedWord())!
		}
		readToken(expectedToken: "]")
		return aut
	}
	/**
     * The type Authority.
     */
	public struct Authority {
		/**
         * The Authority.
         */
		public var authority: String = ""
		/**
         * The Authority code.
         */
		public var authorityCode: Int = 0
	}
}
