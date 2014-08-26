test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -quiet test.native

clean:
	rm -rf _build
	rm test.native

.PHONY: clean
