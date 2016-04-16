using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GibbASN1.ASTNodes;

namespace GibbASN1
{
    class Parser
    {
        public Parser(Lexer lex)
        {

        }

        public ModuleDefinitionNode parseModuleDefinition()
        {
            ModuleDefinitionNode mdn = new ModuleDefinitionNode();

            //IdentifierNode moduleName = IdentifierNode.Accept(Token.TokenType.Identifier);

            return mdn;
        }
    }
}
