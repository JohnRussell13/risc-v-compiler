lexer: lexer.l
		flex lexer.l
		gcc lex.yy.c -o lexer

.PHONY: clean
clean:
	rm -f $(ODIR)/*.o lexer res.txt lex.yy.c

run:
	echo "----- 1 -----" > res.txt
	./lexer < ./../"Test Codes"/test1.c >> res.txt
	echo "----- 2 -----" >> res.txt
	./lexer < ./../"Test Codes"/test2.c >> res.txt
	echo "----- 3 -----" >> res.txt
	./lexer < ./../"Test Codes"/test3.c >> res.txt
	echo "----- 4 -----" >> res.txt
	./lexer < ./../"Test Codes"/test4.c >> res.txt
	echo "----- 5 -----" >> res.txt
	./lexer < ./../"Test Codes"/test5.c >> res.txt
	echo "----- 6 -----" >> res.txt
	./lexer < ./../"Test Codes"/test6.c >> res.txt
	echo "----- 7 -----" >> res.txt
	./lexer < ./../"Test Codes"/test7.c >> res.txt
	echo "----- 8 -----" >> res.txt
	./lexer < ./../"Test Codes"/test8.c >> res.txt
