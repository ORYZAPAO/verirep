#ifndef __VERILEX_H
#define __VERILEX_H


#include "verilog_lexer.h"

class VeriFlex{
 private:
  FlexLexer* lexer;

  void VeriFlex : lexer( new yyFlexLexer() ){
  }


};


#endif ///__VERILEX_H
