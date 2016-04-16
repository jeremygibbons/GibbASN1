﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GibbASN1.ASTNodes
{
    interface NodeGenerator<T>
    {
        T Accept(Token.TokenType tt);
    }
}
