#include <iostream>
#include <fstream>

#include "verilog_lexer.h"
using namespace std;


int main(int argc, char *argv[]){
  void usage();

  usage();
  

  FlexLexer* lexer = new yyFlexLexer();
  //ifstream in("hoge.input");
  //lexer->switch_streams(&in);  
  //lexer->parse();
}

  
