test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -use-ocamlfind -quiet -package react test.native

clean:
	rm -rf _build

.PHONY: clean
