test: test.native
	@./test.native

test.native: *.ml *.mli
	@corebuild -r -quiet -pkg oUnit test.native

main.byte: clean
	@corebuild -r -quiet main.byte

clean:
	rm -rf _build
	rm -f test.native
	rm -f main.byte

.PHONY: clean
