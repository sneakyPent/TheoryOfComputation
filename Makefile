LEX=flex
CC=gcc
FILENAME=$(basename $@)
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


FLEX: $(LEXERNAME).o

%.o: %.l *.in
	$(LEX)  -o $(FILENAME).yy.c $<
	$(CC) -o $(FILENAME) $(FILENAME).yy.c -lfl
	./$(FILENAME) < $(TESTFILE) > $(FILENAME).o
	$(RM) $(LEXERNAME)
	
clean:
		$(RM) *.o *.c

help: default

display:
	cat $(LEXERNAME).o
