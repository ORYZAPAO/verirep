TOKEN_LIST       = TOKEN.list

TOKEN_ID_HEADER  = ../verilog_token.h
FLEX_FILE        = flex.lex

PRE_TARGET       = pre_verilog_lexer.cpp
HEADER_FLEX_FILE = ../verilog_lexer.h

TARGET_WINDOWS   = ../verilog_lexer_windows.cpp
TARGET_MACOS     = ../verilog_lexer_macos.cpp



$(TARGET_WINDOWS) : $(PRE_TARGET) header.lex
	@echo ""
	@echo '...Add  #include "stdafx.h"'
	cat header.lex  $(PRE_TARGET) > $(TARGET_WINDOWS)
	cp              $(PRE_TARGET) $(TARGET_MACOS)

##
## 1) TOKEN.list -->  flex.lex ................. Flex File
##                    verilog_token.h .......... Token list
## 
## 2) flex.lex   -->  pre_verilog_lexer.cpp  ... Generated Lexer
##                    verilog_lexer.h ..........           Lexer Header File (by flex)
##
$(PRE_TARGET) : $(TOKEN_LIST)
	@echo "...Generate "
	ruby genflex.rb $<  $(TOKEN_ID_HEADER) $(FLEX_FILE)
	@echo "...Run Flex "
	flex++ --c++ -B --header-file=$(HEADER_FLEX_FILE) --outfile=$(PRE_TARGET) < $(FLEX_FILE)

clean : 
	rm \
	   $(TOKEN_ID_HEADER)   \
	   $(FLEX_FILE)         \
	   \
	   $(PRE_TARGET)        \
	   $(HEADER_FLEX_FILE)  \
	   \
	   $(TARGET_WINDOWS)    \
	   $(TARGET_MACOS)	   
