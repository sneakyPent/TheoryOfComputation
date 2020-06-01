LEX=flex
CC=gcc
FILENAME=$(basename $@)
PRN=$(basename $(PARSERNAME) )
default:
	@ echo Give an argument and specify dependencies
	@ echo
	@ echo "-------------ARGUMENTS--------------"
	@ echo "lexerName.o 	--> (where lexerName is the name of .l file)"
	@ echo "clean  		--> clean directory"
	@ echo
	@ echo "-------------DEPENDENCIES--------------"
	@ echo " TESTFILE --> the Name of the .in file will be used as test."
	@ echo " LEXERNAME --> the Name of the .l file will be used."


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
	$(RM) $(TARGETNAME)


FLEX: $(LEXERNAME).o

%.o: %.l 
	$(LEX)  -o $(FILENAME).yy.c $<
	$(CC) -o $(FILENAME) $(FILENAME).yy.c -lfl
	./$(FILENAME) < $(TESTFILE) > $(FILENAME).o
	$(RM) $(LEXERNAME)
	

clean:
	@ rm *.tab.c *.tab.h *.yy.c *.output myprogram.c


help: default


display:
	cat $(LEXERNAME).o
