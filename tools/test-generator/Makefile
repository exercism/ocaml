test: all_tests.native
	@./all_tests.native

all_tests.native: src/*.ml src/*.mli test/*.ml
	@ocamlbuild -use-ocamlfind -tag thread -tag short_paths -cflags -strict-sequence -r -pkg core -pkg oUnit -pkg yojson -pkg ppx_deriving.eq -pkg ppx_deriving.show -Is "src,test" all_tests.native

clean:
	rm -rf _build

.PHONY: clean
