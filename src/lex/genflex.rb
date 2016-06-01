#!/bin/ruby


class GenFlex
   @infile             ## Input File
   @c_header_file      ## Output C/++ Header File
   @lex_file           ## Output Flex File
     
   @in                 ##
   @out_c_header       ##
   @out_lex_header     ##

   @count
   @@max_lexngth = 30


  ######
  def OpenFiles( _infile, _c_header_file, _lex_file)
     @infile        = _infile
     @c_header_file = _c_header_file
     @lex_file      = _lex_file

     @in             = File.open(@infile,       "r")
     @out_c_header   = File.open(@c_header_file,"w")
     @out_lex_header = File.open(@lex_file,     "w")

     @count  = 0
  end


  ######
  def Output_Flex_Head
     @out_lex_header.print <<'END'
%option c++
%{

#include <iostream>
//#include "../include/verilog_token.h"
#include "verilog_token.h"

%}

TRAIL  ([\t \n]|"#"[^\n]*"\n")*

%%
END
  end


  #####
  def main
     offset = 0
     
     while line = @in.gets

        ## Space Line  :: 
        if( line =~ /^(\s+)/ )
           @out_c_header.print   "\n"
           @out_lex_header.print "\n"
           next
        end
        line.gsub!(/\n/,"") 

        ##
        ## "#" or "//" :: Comment Line 
        ##
        if (line =~ /^#(.+)/) 
           @out_c_header.printf  "//%s\n",$1
           next
        end

        ## "#" or "//" ::
        ##   Remove Comment
        line.gsub!(/#(.+)/,"")

        ##
        ## "@based"    :: Command
        ##
        if line =~ /@based\s+(.+)/ || line =~ /@BASED\s+(.+)/
           offset = $1.to_i      
           @out_c_header.printf "// Based = %d\n",offset           
           ### @out_lex_header.printf "/* Based = %d */\n",offset
           next 
        end
        
        ##
        ## <keyword>  <"C/C++" define Name>
        ##
        if line =~ /^(\S+)\s+(\S+)/ 
           token_name = $1
           c_define_name   = $2

           #           
           if( token_name.length > @@max_lexngth ) 
              @out_c_header.printf "#define  %s %d   // %s\n",       c_define_name, offset, token_name
           else
              @out_c_header.printf "#define  %-30s %d   // %s\n",    c_define_name, offset, token_name
           end

           ## 
           @out_lex_header.printf  "%s{TRAIL} \t\t{ return %s; }\n", token_name, c_define_name
           
           ## Count up
           @count = @count + 1
        end

        offset = offset + 1
     end ## while line = infile.gets...

  end


  ######
  def Output_Flex_Foot
     ## Output Flex Footer ...
     @out_lex_header.print <<'END'

%%

int yyFlexLexer::yywrap(void){ 
  std::cout << "...fin";
  return -1;
}
END
  end


  #####
  def CloseFiles
     @in.close
     @out_c_header.close
     @out_lex_header.close
  end


  #####
  def Report
     print "  Output C/++ Header File : \""+@c_header_file+"\"\n"
     print "  Output Flex pre File    : \""+@lex_file+"\"\n"
     printf"  Number of Tokens        : %d\n", @count
  end


end ### ...class GenFlex


##########################################
## Main Routine
##########################################

genflex = GenFlex.new

genflex.OpenFiles( ARGV[0], ARGV[1], ARGV[2])
genflex.Output_Flex_Head
genflex.main
genflex.Output_Flex_Foot
genflex.CloseFiles
genflex.Report
