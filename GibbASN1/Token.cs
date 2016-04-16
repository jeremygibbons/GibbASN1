namespace GibbASN1
{
    public class Token
    {
        public enum TokenType
        {
            Empty = 0,
            ReservedWord,
            TypeReference,
            Identifier,
            ValueReference,
            ModuleReference,
            Comment,
            Number,
            RealNumber,
            BinaryString,
            XMLBinaryString,
            HString,
            XMLHString,
            CString,
            XMLCString,
            SimpleString,
            TString,
            XMLTString,
            PSName,
            Assignment,
            RangeSeparator,
            Ellipsis,
            LeftVersionBrackets,
            RightVersionBrackets,
            EncodingReference,
            IntegerUnicodeLabel,
            NonIntegerUnicodeLabel,
            XMLEndTagStartItem ,
            XMLSingleTagEndItem,
            XMLBooleanTrueItem,
            XMLBooleanExtendedTrueItem,
            XMLBooleanFalseItem,
            XMLBooleanExtendedFalseItem,
            XMLRealNaN,
            XMLInf,
            XMLASN1TypeName,
            LeftBrace,
            RightBrace,
            LessThan,
            GreaterThan,
            Comma,
            FullStop,
            LeftParenthis,
            RightParenthis,
            LeftBracket,
            RightBracket,
            Minus,
            Colon,
            Equals,
            QuotationMark,
            Apostrophe,
            Space,
            SemiColon,
            At,
            Bar,
            Exclamation ,
            Power
        }

        public Token(TokenType type, string value)
        {
            this.Type = type;
            this.Value = value;
        }

        public TokenType Type { get; set; }
        public string Value { get; set; }
    }
}