using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;

namespace GibbASN1
{
    public class Lexer
    {
        StreamReader input;

        Queue<Token> tokenQueue;

        //Per X.680 article 10.1
        char[] validChars = { '!', '"', '&', '\'', '(', ')', '*', ',', '-', '.',
            '/', ':', ';', '<', '=', '>', '@', '[', ']', '^', '_', '{', '}', '|'};

        int[] whiteSpaceChars = { 9, 10, 11, 12, 13, 32 };
        int[] newLineChars = { 10, 11, 12, 13 };

        string[] reservedWords =
        {
            "ABSENT", "ABSTRACT-SYNTAX", "ALL", "APPLICATION", "AUTOMATIC", "BEGIN",
            "BIT", "BMPString", "BOOLEAN", "BY", "CHARACTER", "CHOICE", "CLASS",
            "COMPONENT", "COMPONENTS", "CONSTRAINED", "CONTAINING", "DATE", "DATETIME",
            "DEFAULT", "DEFINITIONS", "EMBEDDED", "ENCODED", "ENCODING-CONTROL", "END",
            "ENUMERATED", "EXCEPT", "EXPLICIT", "EXPORTS", "EXTENSIBILITY", "EXTERNAL",
            "FALSE", "FROM", "GeneralizedTime", "GeneralString", "GraphicString",
            "IA5String", "IDENTIFIER", "IMPLICIT", "IMPLIED", "IMPORTS", "INCLUDES",
            "INSTANCE", "INSTRUCTIONS", "INTEGER", "INTERSECTION", "ISO646String", "MAX",
            "MIN", "MINUS-INFINITY", "NOT-A-NUMBER", "NULL", "NumericString", "OBJECT",
            "ObjectDescriptor", "OCTET", "OF", "OID-IRI", "OPTIONAL", "PATTERN", "PDV",
            "PLUS-INFINITY", "PRESENT", "PrintableString", "PRIVATE", "REAL",
            "RELATIVE-OID", "RELATIVE-OID-IRI", "SEQUENCE", "SET", "sETTINGS", "SIZE",
            "STRING", "SYNTAX", "T61String", "TAGS", "TeletexString", "TRUE",
            "TYPE-IDENTIFIER", "UNION", "UNIQUE", "UNIVERSAL", "UniversalString", "UTCTime",
            "UTF8String", "VideotexString", "VisibleString", "WITH"
        };

        public Lexer(StreamReader input)
        {
            this.input = input;
            tokenQueue = new Queue<Token>();
        }

        bool isWhiteSpace(int c) => whiteSpaceChars.Contains(c);
        bool isNewLine(int c) => newLineChars.Contains(c);

        //Per X.680 article 10.1
        int GetNextChar(bool arbitrary)
        {
            int next = input.Read();

            if (next == -1)
                return -1;

            if (arbitrary)
                return next;

            if (next >= 'A' && next <= 'Z')
                return next;

            if (next >= 'a' && next <= 'z')
                return next;

            if (next >= '0' && next <= '9')
                return next;

            if (validChars.Contains((char)next))
                return next;

            if (whiteSpaceChars.Contains(next))
                return next;

            throw new ArgumentOutOfRangeException(String.Format("invalid character in input : %1", next));
        }

        public Token GetNextToken()
        {
            while(tokenQueue.Count == 0)
            {
                bool b = EnqueueNextTokens();
                if (b == false)
                    return new Token(Token.TokenType.Empty, "");
            }
            return tokenQueue.Dequeue();
        }

        bool EnqueueNextTokens()
        {
            while (isWhiteSpace(input.Peek()))
                input.Read();

            int c = GetNextChar(false);                

            if(c == -1)
            {
                return false;
            }

            if(c == '.')
            {
                if(input.Peek() == '.') //ellipsis or range
                {
                    c = input.Read();
                    if(input.Peek() == '.') //ellipsis
                    {
                        input.Read();
                        tokenQueue.Enqueue(new Token(Token.TokenType.Ellipsis, "..."));
                        return true;
                    }
                    else
                    {
                        tokenQueue.Enqueue(new Token(Token.TokenType.RangeSeparator, ".."));
                        return true;
                    }
                }
                else
                {
                    tokenQueue.Enqueue(new Token(Token.TokenType.FullStop, "."));
                    return true;
                }
            }

            if(c == ':')
            {
                if(input.Peek() == ':') //possible Assignment
                {
                    input.Read();
                    if(input.Peek() == '=')
                    {
                        input.Read();
                        tokenQueue.Enqueue(new Token(Token.TokenType.Assignment, "::="));
                        return true;
                    }
                    tokenQueue.Enqueue(new Token(Token.TokenType.Colon, ":"));
                    tokenQueue.Enqueue(new Token(Token.TokenType.Colon, ":"));
                    return true;
                }
                else
                {
                    tokenQueue.Enqueue(new Token(Token.TokenType.Colon, ":"));
                    return true;
                }
            }

            if (c == '-')
            {
                if(input.Peek() == '-')
                {
                    input.Read();
                    ConsumeOneLineComment();
                    return EnqueueNextTokens();
                }
                tokenQueue.Enqueue(new Token(Token.TokenType.Minus, "-"));
                return true;
            }

            if(c == '[')
            {
                if(input.Peek() == '[')
                {
                    input.Read();
                    tokenQueue.Enqueue(new Token(Token.TokenType.LeftVersionBrackets, "[["));
                    return true;
                }
                tokenQueue.Enqueue(new Token(Token.TokenType.LeftBracket, "["));
                return true;
            }

            if(c == ']')
            {
                if (input.Peek() == ']')
                {
                    input.Read();
                    tokenQueue.Enqueue(new Token(Token.TokenType.RightVersionBrackets, "]]"));
                    return true;
                }
                tokenQueue.Enqueue(new Token(Token.TokenType.LeftBracket, "]"));
                return true;
            }

            if(c == '/' && input.Peek() == '*')
            {
                input.Read(); //consume '*'
                ConsumeMultiLineComment();
                return EnqueueNextTokens();
            }

            if(char.IsDigit((char) c))
            {
                tokenQueue.Enqueue(ParseIntOrDecimal(c));
                return true;
            }

            if(char.IsUpper((char) c))
            {
                string typeref = ParseTypeOrID(c);
                if(reservedWords.Contains(typeref))
                {
                    tokenQueue.Enqueue(new Token(Token.TokenType.ReservedWord, typeref));
                }
                else
                {
                    tokenQueue.Enqueue(new Token(Token.TokenType.TypeReference, typeref));
                }
                return true;
            }
            if(char.IsLower((char) c))
            {
                string id = ParseTypeOrID(c);
                tokenQueue.Enqueue(new Token(Token.TokenType.Identifier, id));
                return true;
            }

            new Token(Token.TokenType.Empty, "");
            return false;

        }

        private string ParseTypeOrID(int first)
        {
            string result = new string((char) first, 1);
            int c = input.Peek();
            while(c != -1 && (char.IsLetterOrDigit((char) c) || c == '-'))
            {
                input.Read();
                if(c == '-' && input.Peek() == '-')
                {
                    input.Read();
                    ConsumeOneLineComment();
                    return result;
                }
                result += (char)c;
                c = input.Peek();
            }
            return result;
            
        }

        private void ConsumeMultiLineComment()
        {
            int c = input.Read();
            while(!(c == '*' && input.Peek() == '/')) {
                if(c == '/' && input.Peek() == '*')
                {
                    input.Read(); //consume '*'
                    ConsumeMultiLineComment(); //per spec, nesting comments is allowed, but all opening /* must be closed by corresponding */
                }
                c = input.Read(); //move to next char
            }
            input.Read(); //Consume trailing '/'
        }

        private Token ParseIntOrDecimal(int FirstChar)
        {
            string intPart = ParseInt(FirstChar);

            //check if this is a RealNumber. If not return int as Number
            int peek = input.Peek();
            if (peek != '.' && peek != 'e' && peek != 'E')
                return new Token(Token.TokenType.Number, intPart);

            input.Read(); //consume '.'
            string decPart = "";

            if (char.IsDigit((char)input.Peek()))
            {
                decPart = ParseInt(input.Read());
            }

            if(input.Peek() == 'E' || input.Peek() == 'e')
            {
                input.Read();
                string exponent = "";
                if (input.Peek() == '-')
                {
                    input.Read();
                    exponent += '-';
                }
                //the exponent has no digits
                if (char.IsDigit((char)input.Peek()) == false)
                    throw new ArgumentException("Unexpected end of token when reading exponent");

                exponent += ParseInt(input.Read());
                return new Token(Token.TokenType.RealNumber, intPart + "." + decPart + "E" + exponent);

            }
            else
            {
                return new Token(Token.TokenType.RealNumber, intPart + "." + decPart);
            }

        }

        private string ParseInt(int firstChar)
        {
            string number = new string((char) firstChar, 1);
            while (char.IsDigit((char)input.Peek()))
            {
                number += (char) input.Read();
            }
            return number;
        }

        private void ConsumeOneLineComment()
        {
            while (newLineChars.Contains(input.Peek()) == false && input.Peek() != -1)
            {
                int c = input.Read();
                if(c == '-' && input.Peek() == '-')
                {
                    input.Read();
                    return;
                    
                }
            }
        }
    }
}
