test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -r -quiet -pkg oUnit -pkg re2 test.native

clean:
	rm -rf _build
	rm -f test.native

.PHONY: clean
