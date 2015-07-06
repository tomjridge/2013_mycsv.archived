include ../Makefile.common

SHELL:=bash

IGNORE_WARNINGS:=-w -3 # Warning 3: deprecated: String.create
OCAMLOPT=ocamlfind ocamlopt $(IGNORE_WARNINGS) -package unix,str $(P1_PKG:.cma=.cmxa)

all: before_all
	$(OCAMLOPT) -c mycsv_lib.mli mycsv_lib.ml
	$(OCAMLOPT) -linkpkg -o mycsv.native mycsv_lib.cmx mycsv.ml

before_all:
	ln -sf ../src/*.ml ../src/*.mli .

clean: FORCE
	rm -f *.ml *.mli *.cmi *.cmx *.o mycsv.native

FORCE:

