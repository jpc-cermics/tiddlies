include ../Path.incl 

.SUFFIXES: .dia .tst .vl

TESTS= lp.dia rls.dia arch0.dia

VL=$(TESTS:.dia=.vl) 

all : $(TESTS) 

tests: all

.tst.dia :
	@echo -n "testing $*: "
	@$(SCIDIR)/bin/nsp -nw -e "exec('../loader.sce');nsptest('$*.tst');quit"

.tst.vl :
	@echo -n "valgrind $*: "
	@valgrind --leak-check=full  $(SCIDIR)/bin/scilex -nw -e "exec('../loader.sce');exec('$*.tst');quit" >& $*.vl
	@echo  " $*.vl"

distclean	:
	@echo cleaning tests
	@$(RM) $(TESTS) 

clean:	distclean


