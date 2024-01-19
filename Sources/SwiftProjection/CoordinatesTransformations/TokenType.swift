/// The enum Token type.
public enum TokenType {
	/**
     * Represents the type of token created by the StreamTokenizer class.
     *
     * Indicates that the token is a word.
     */
	case Word, /**
     * Indicates that the token is a number.
     */
		Number, /**
     * Indicates that the end of line has been read. The field can only have this value if the eolIsSignificant method has been called with the argument true.
     */
		Eol, /**
     * Indicates that the end of the input stream has been reached.
     */
		Eof, /**
     * Indictaes that the token is white space (space, tab, newline).
     */
		Whitespace, /**
     * Characters that are not whitespace, numbers, etc...
     */
		Symbol
}
