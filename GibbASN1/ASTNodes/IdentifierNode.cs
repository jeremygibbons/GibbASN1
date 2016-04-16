using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GibbASN1.ASTNodes
{
    class IdentifierNode : NodeGenerator<IdentifierNode>
    {
        public IdentifierNode Accept(Token.TokenType tt)
        {
            throw new NotImplementedException();
        }
    }
}
