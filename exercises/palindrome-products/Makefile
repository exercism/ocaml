test: test.native
	@./test.native

test.native: *.ml *.mli
	@ocamlbuild -use-ocamlfind -tag thread -r -quiet -pkg core -pkg oUnit -pkg ppx_deriving.std test.native

clean:
	rm -rf _build
	rm -f test.native

.PHONY: clean
