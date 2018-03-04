test: test.native
	@./test.native

test.native: *.ml *.mli
	@ocamlbuild -r -quiet -pkg oUnit -pkg base test.native

clean:
	rm -rf _build
	rm -f test.native

.PHONY: clean
