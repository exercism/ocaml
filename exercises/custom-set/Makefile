test: test.native
	@./test.native

test.native: *.ml
	@corebuild -quiet -pkg oUnit test.native

clean:
	rm -rf _build

.PHONY: clean
