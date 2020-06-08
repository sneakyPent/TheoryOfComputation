LEX=flex
CC=gcc
FILENAME=$(basename $@)
PRN=$(basename $(PARSERNAME) )
default:
	@ echo Give an argument and specify dependencies
	@ echo example for bison \"make MBISON \"TARGETNAME=myprogram\" \"LEXERNAME=lexer.l\" \"PARSERNAME=parser.y\" \"TESTFILE=prime.ms\"\"
	@ echo "for .c file execution run make exec"


BISON: *.l *.y 
	bison -d -v -r all $(word 2,$^)
	$(LEX) -o $(TARGETNAME).yy.c $(word 1,$^)
	$(CC) -o $(TARGETNAME) $(TARGETNAME).yy.c $(basename $(word 2,$^)).tab.c cgen.c -lfl
	./$(TARGETNAME) < $(TESTFILE) > $(TARGETNAME).c
	$(RM) $(TARGETNAME)


MBISON: *.l *.y 
	bison -d -v -r all $(PARSERNAME)
	$(LEX) -o $(TARGETNAME).yy.c $(LEXERNAME)
	$(CC) -o $(TARGETNAME) $(TARGETNAME).yy.c $(PRN).tab.c cgen.c -lfl
	./$(TARGETNAME) < $(TESTFILE) > $(TARGETNAME).c


FLEX: $(LEXERNAME).o

%.o: %.l 
	$(LEX)  -o $(FILENAME).yy.c $<
	$(CC) -o $(FILENAME) $(FILENAME).yy.c -lfl
	./$(FILENAME) < $(TESTFILE) > $(FILENAME).o
	$(RM) $(LEXERNAME)
	

clean:
	@ rm *.tab.c *.tab.h *.yy.c *.output myprogram.c


help: default

exec: 
	gcc -std=c99 -o exe  myprogram.c
display:
	cat $(LEXERNAME).o
