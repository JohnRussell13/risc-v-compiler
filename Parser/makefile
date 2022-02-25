parser: parser.y lexer.l
		flex lexer.l
		bison -d parser.y
		gcc parser.tab.c symtab.c lex.yy.c -o parser

.PHONY: clean
clean:
	rm -f $(ODIR)/*.o parser res.txt lex.yy.c parser.tab.h parser.tab.c

run:
	echo "----- 0 -----" > res.txt
	./parser < ./../"Test Codes"/test0.c >> res.txt
	echo "----- 1 -----" >> res.txt
	./parser < ./../"Test Codes"/test1.c >> res.txt
	echo "----- 2 -----" >> res.txt
	./parser < ./../"Test Codes"/test2.c >> res.txt
	echo "----- 3 -----" >> res.txt
	./parser < ./../"Test Codes"/test3.c >> res.txt
	echo "----- 4 -----" >> res.txt
	./parser < ./../"Test Codes"/test4.c >> res.txt
	echo "----- 5 -----" >> res.txt
	./parser < ./../"Test Codes"/test5.c >> res.txt
	echo "----- 6 -----" >> res.txt
	./parser < ./../"Test Codes"/test6.c >> res.txt
	echo "----- 7 -----" >> res.txt
	./parser < ./../"Test Codes"/test7.c >> res.txt
	echo "----- 8 -----" >> res.txt
	./parser < ./../"Test Codes"/test8.c >> res.txt

test: parser.y lexer.l
	rm -f $(ODIR)/*.o parser res.txt lex.yy.c parser.tab.h parser.tab.c
	flex lexer.l
	bison -d parser.y
	gcc parser.tab.c symtab.c lex.yy.c -o parser
	./parser < ./../"Test Codes"/test0.c > res.txt