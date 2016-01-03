using System;
using System.IO;
using GibbASN1;

namespace GibbASN1TestApp
{
    class Program
    {
        static void Main(string[] args)
        {
            string test = "Test ::= /*/**/*/12345";
            using (Stream s = GenerateStreamFromString(test))
            {
                Lexer asn1parser = new Lexer(new StreamReader(s));
                while (true)
                {
                    Token t = asn1parser.GetNextToken();
                    if (t.Type == Token.TokenType.Empty)
                        break;
                    Console.WriteLine("Next token of type {0}, value is {1}", t.Type.ToString(), t.Value);
                }
                Console.ReadLine();
            }

        }

        public static Stream GenerateStreamFromString(string s)
        {
            MemoryStream stream = new MemoryStream();
            StreamWriter writer = new StreamWriter(stream);
            writer.Write(s);
            writer.Flush();
            stream.Position = 0;
            return stream;
        }
    }
}
