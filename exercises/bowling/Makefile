test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -quiet -pkg oUnit test.native

clean:
	rm -rf _build

.PHONY: clean
