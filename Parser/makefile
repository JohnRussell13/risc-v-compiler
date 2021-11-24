bison: syntax.y
		bison -d syntax.y
		flex ../"Lexer"/lexer.flex
		gcc -o syntax syntax.tab.c lex.yy.c
		
.PHONY: clean
clean:
	rm -f $(ODIR)/*.o lexer res.txt lex.yy.c syntax

run:
	echo "----- 1 -----" > res.txt
	./syntax < ./../"Test Codes"/test1.c >> res.txt
	echo "----- 2 -----" >> res.txt
	./syntax < ./../"Test Codes"/test2.c >> res.txt
	echo "----- 3 -----" >> res.txt
	./syntax < ./../"Test Codes"/test3.c >> res.txt
	echo "----- 4 -----" >> res.txt
	./syntax < ./../"Test Codes"/test4.c >> res.txt
	echo "----- 5 -----" >> res.txt
	./syntax < ./../"Test Codes"/test5.c >> res.txt
	echo "----- 6 -----" >> res.txt
	./syntax < ./../"Test Codes"/test6.c >> res.txt
	echo "----- 7 -----" >> res.txt
	./syntax < ./../"Test Codes"/test7.c >> res.txt
	echo "----- 8 -----" >> res.txt
	./syntax < ./../"Test Codes"/test8.c >> res.txt
