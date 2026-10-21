SHELL = /bin/sh

include ../Path.incl 
include $(SCIDIR)/Makefile.incl

all	:: Makelib job 
	make -f Makelib

Makelib : builder.sce
	@echo running builder 
	@$(SCIDIR)/bin/scilab -nw -e "exec('builder.sce');quit"


job	: 
	make -f Makelib

tests	: all
	make -f Makelib tests 

clean	::
	@echo Cleaning 
	@$(RM) -f -r *.o *.lo *.la *.so *.sl *.a *.dia .job.sce so_locations
	@$(RM) -f -r .libs

distclean:: clean 
	@$(RM) -f *.dia  *_gateway.c 
	@$(RM) -f Makelib 








