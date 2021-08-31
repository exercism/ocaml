# assignments
ASSIGNMENT ?= ""
ASSIGNMENTS = $(shell git ls-tree --name-only HEAD -- exercises/practice/ | awk -F/ '{print $$NF}' | sort)

default: testgenerator test

# output directories
TMPDIR ?= "/tmp/"
OUTDIR := $(shell mktemp -d "$(TMPDIR)$(ASSIGNMENT).XXXXXXXXXX")

# language specific config (tweakable per language)
FILEEXT := "ml"
EXAMPLE := ".meta/example.$(FILEEXT)"
SRCFILE := "$(shell echo $(ASSIGNMENT) | sed 's/-/_/g')"
TSTFILE := "$(SRCFILE)_test.$(FILEEXT)"
# Any additional arguments, such as -p for pretty output and others
ARGS ?= ""

# single test
test-assignment:
	@echo ""
	@echo ""
	@echo "----------------------------------------------------------------"
	@echo "running tests for: $(ASSIGNMENT)"
	@cp -r ./exercises/practice/$(ASSIGNMENT)/* $(OUTDIR)
	@cp ./exercises/practice/$(ASSIGNMENT)/$(EXAMPLE) $(OUTDIR)/$(SRCFILE).$(FILEEXT)
	@make -C $(OUTDIR)
	@rm -rf $(OUTDIR)

# all tests
test:
	@for assignment in $(ASSIGNMENTS); do \
		ASSIGNMENT=$$assignment $(MAKE) -s test-assignment || exit 1;\
	done

build_test:
	dune build @buildtest

generator:
	dune build --root=./test-generator/

test_generator:
	dune runtest --root=./test-generator/

generate_exercises:
	dune exec ./bin_test_gen/test_gen.exe --root=./test-generator/

install_deps:
	opam install dune fpath ocamlfind ounit qcheck react ppx_deriving ppx_let ppx_sexp_conv yojson ocp-indent calendar getopts

clean:
	dune clean --root=./test-generator/
	@for assignment in $(ASSIGNMENTS); do \
		dune clean --root=./exercises/practice/$$assignment;\
	done

.PHONY: clean
