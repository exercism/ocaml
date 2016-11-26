test: test_gen.native
	@./all_tests.native

test_gen.native: all_tests.native src/*.ml interfaces/*.mli test/*.ml
	@ocamlbuild -use-ocamlfind -tag thread -tag short_paths -cflags -strict-sequence -r -pkg core -pkg yojson -pkg ppx_deriving -pkg ppx_deriving.eq -pkg ppx_deriving.show -Is "src,interfaces" test_gen.native

all_tests.native: src/*.ml test/*.ml
	@ocamlbuild -use-ocamlfind -tag thread -tag short_paths -cflags -strict-sequence -r -pkg core -pkg oUnit -pkg yojson -pkg ppx_deriving -pkg ppx_deriving.eq -pkg ppx_deriving.show -Is "src,test" all_tests.native

clean:
	rm -rf _build
	rm -f test_gen.native
	rm -f all_tests.native

.PHONY: clean
