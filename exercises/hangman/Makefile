test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -r -use-ocamlfind -pkg oUnit -quiet -pkg react test.native

clean:
	rm -rf _build
	rm -f test.native

.PHONY: clean
