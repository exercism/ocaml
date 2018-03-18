default: test

test: clean
	{ \
	mkdir tmp ; \
	cp src/* tmp; \
	cp test/* tmp; \
	cp jbuild tmp; \
	cd tmp; \
	jbuilder build test_gen.exe; \
	cd ..; \
	cp ./tmp/_build/default/test_gen.exe .; \
	}

clean:
	rm -rf tmp
	jbuilder clean

.PHONY: clean
