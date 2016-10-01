test: test.native
	@./test.native

test.native: *.ml *.ml
	@corebuild -r -quiet -pkg oUnit test.native

clean:
	rm -rf _build
	rm test.native

.PHONY: clean
