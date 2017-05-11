test: test.native
	@./test.native

test.native: *.ml *.ml
	@corebuild -r -quiet -pkg oUnit test.native

clean:
	rm -rf _build
	rm -f test.native

.PHONY: clean
