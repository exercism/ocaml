test: test.native
	@./test.native

test.native: *.ml
	@corebuild -r -quiet -pkg oUnit test.native

clean:
	rm -rf _build

.PHONY: clean
