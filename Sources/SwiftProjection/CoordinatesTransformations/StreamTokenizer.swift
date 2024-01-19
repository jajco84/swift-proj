/// The StreamTokenizer class takes an input stream and parses it into "tokens", allowing the tokens to be read one at a time. The parsing process is controlled by a table and a number of flags that can be set to various states. The stream tokenizer can recognize identifiers, numbers, quoted strings, and various comment style
///
/// This is a crude c# implementation of Java's StreamTokenizer class.
public class StreamTokenizer {
	// private final NumberFormatInfo _nfi = CultureInfo.InvariantCulture.NumberFormat;
	private var _currentTokenType: TokenType = TokenType.Word
	private var _reader: StringReader
	private var _currentToken: String = String()
	private var _lineNumber: Int = 1
	private var _colNumber: Int = 1
	private var _ignoreWhitespace: Bool
	/* *
     * Initializes a new instance of the StreamTokenizer class.
     *
     * @param reader           A TextReader with some text to read.
     * @param ignoreWhitespace Flag indicating whether whitespace should be ignored.
     * @throws Exception the exception
     */
	init(_ reader: StringReader, _ ignoreWhitespace: Bool) {
		// if (reader == null)
		// throw new  Exception("reader");
		_reader = reader
		_ignoreWhitespace = ignoreWhitespace
	}
	/* *
     * Determines a characters type (e.g. number, symbols, character).
     *
     * @param character The character to determine.
     * @return The TokenType the character is.
     */
	func getType(character: Character) -> TokenType {
		if character.isNumber { return TokenType.Number }
		if character.isLetter { return TokenType.Word }
		if character.isNewline {  // == '\n'){
			return TokenType.Eol
		}
		if character.isWhitespace { return TokenType.Whitespace }
		return TokenType.Symbol
	}
	/* *
     * The current line number of the stream being read.
     *
     * @return the line number
     * @throws Exception the exception
     */
	public func getLineNumber() -> Int { return _lineNumber }
	/* *
     * The current column number of the stream being read.
     *
     * @return the column
     * @throws Exception the exception
     */
	public func getColumn() -> Int { return _colNumber }
	/* *
     * Gets ignore whitespace.
     *
     * @return the ignore whitespace
     * @throws Exception the exception
     */
	public func getIgnoreWhitespace() -> Bool { return _ignoreWhitespace }
	/* *
     * If the current token is a number, this field contains the value of that number.
     *
     * If the current token is a number, this field contains the value of that number. The current token is a number when the value of the ttype field is TT_NUMBER.
     *
     * FormatException Current token is not a number in a valid format.
     *
     * @return the numeric value
     * @throws Exception the exception
     */
	public func getNumericValue() -> Double {
		let number: String = getStringValue()
        if getTokenType() == TokenType.Number {
            return Double(number) ?? .nan
        }
		return Double.nan  // var s : String = String.format("The token '%s' is not a number at line %d column %d.", number, getLineNumber(), getColumn());
		// throwException() /* throw IllegalArgumentException(s); */
	}
	/* *
     * If the current token is a word token, this field contains a string giving the characters of the word token.
     *
     * @return the string value
     * @throws Exception the exception
     */
	public func getStringValue() -> String { return _currentToken }
	/* *
     * Gets the token type of the current token.
     *
     * @return token type
     * @throws Exception the exception
     */
	public func getTokenType() -> TokenType { return _currentTokenType }
	/* *
     * Returns the next token.
     *
     * @param ignoreWhitespace Determines is whitespace is ignored. True if whitespace is to be ignored.
     * @return The TokenType of the next token.
     * @throws Exception the exception
     */
	public func nextToken(ignoreWhitespace: Bool) -> TokenType { return ignoreWhitespace ? nextNonWhitespaceToken() : nextTokenAny() }
	/* *
     * Returns the next token.
     *
     * @return The TokenType of the next token.
     * @throws Exception the exception
     */
	public func nextToken() -> TokenType { return nextToken(ignoreWhitespace: getIgnoreWhitespace()) }
	private func nextTokenAny() -> TokenType {
		_currentToken = ""
		_currentTokenType = TokenType.Eof
		var finished: Character? = _reader.read()
		var isNumber: Bool = false
		var isWord: Bool = false
		while finished != nil {
			let currentCharacter: Character = finished!
			// char nextCharacter = (char)_reader.Peek();
			_reader.mark()
			let nextCharacter: Character = _reader.read() ?? " "
			_reader.reset()
			_currentTokenType = getType(character: currentCharacter)
			var nextTokenType: TokenType = getType(character: nextCharacter)
			// handling of words with _
			if isWord && currentCharacter == "_" { _currentTokenType = TokenType.Word }
			// handing of words ending in numbers
			if isWord && _currentTokenType == TokenType.Number { _currentTokenType = TokenType.Word }
			if !isNumber {
				if _currentTokenType == TokenType.Word && nextCharacter == "_" {
					//enable words with _ inbetween
					nextTokenType = TokenType.Word
					isWord = true
				}
				if _currentTokenType == TokenType.Word && nextTokenType == TokenType.Number {
					//enable words ending with numbers
					nextTokenType = TokenType.Word
					isWord = true
				}
			}
			// handle negative numbers
			if currentCharacter == "-" && nextTokenType == TokenType.Number && isNumber == false {
				_currentTokenType = TokenType.Number
				nextTokenType = TokenType.Number
			}
			// this handles numbers with a decimal point
			if isNumber && nextTokenType == TokenType.Number && currentCharacter == "." { _currentTokenType = TokenType.Number }
			if _currentTokenType == TokenType.Number && nextCharacter == "." && isNumber == false {
				nextTokenType = TokenType.Number
				isNumber = true
			}
			// this handles numbers with a scientific notation
			if isNumber {
				if _currentTokenType == TokenType.Number && nextCharacter == "E" { nextTokenType = TokenType.Number }
				if currentCharacter == "E" && (nextCharacter == "-" || nextCharacter == "+") {
					_currentTokenType = TokenType.Number
					nextTokenType = TokenType.Number
				}
				if (currentCharacter == "E" || currentCharacter == "-" || currentCharacter == "+") && nextTokenType == TokenType.Number { _currentTokenType = TokenType.Number }
			}
			_colNumber += 1
			if _currentTokenType == TokenType.Eol {
				_lineNumber += 1
				_colNumber = 1
			}
			_currentToken.append(currentCharacter)
			if _currentTokenType != nextTokenType {
				finished = nil
			} else if _currentTokenType == TokenType.Symbol && currentCharacter != "-" {
				finished = nil
			} else {
				finished = _reader.read()
			}
		}
		return _currentTokenType
	}
	/* *
     * Returns next token that is not whitespace.
     *
     * @return
     */
	private func nextNonWhitespaceToken() -> TokenType {
		var tokentype: TokenType = nextTokenAny()
		while tokentype == TokenType.Whitespace || tokentype == TokenType.Eol { tokentype = nextTokenAny() }
		return tokentype
	}
}
