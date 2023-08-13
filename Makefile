# assignments
ASSIGNMENT ?= ""
ASSIGNMENTS = $(shell git ls-tree --name-only HEAD -- exercises/practice/ | awk -F/ '{print $$NF}' | sort)
TEMPLATES = $(shell git ls-tree --name-only HEAD -- templates/ | awk -F/ '{print $$NF}' | sort)
ASSIGNMENTS_GEN = $(TEMPLATES:=.gen)
ASSIGNMENTS_DOCKER = $(ASSIGNMENTS:=.docker)

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

build_test: test test_generator

$(ASSIGNMENTS_DOCKER):
	@echo "running tests for: $(@:.docker=)"
	@./bin/run-in-docker.sh $(@:.docker=)

test-docker: $(ASSIGNMENTS_DOCKER)

generator:
	dune build --root=./test-generator/

test_generator: generator
	dune runtest --root=./test-generator/

$(ASSIGNMENTS_GEN): test_generator
	dune exec ./bin_test_gen/test_gen.exe --root=./test-generator/ -- --exercise $(@:.gen=) --filter-broken true

generate_exercises: $(ASSIGNMENTS_GEN)

install_deps:
	open update
	opam install core \
		core_unix \
		merlin \
		yaml \
		ezjsonm \
		mustache \
		dune \
		fpath \
		ocamlfind \
		ounit \
		ounit2 \
		qcheck \
		react \
		ppx_deriving \
		ppx_let \
		ppx_sexp_conv \
		yojson \
		ocp-indent \
		calendar \
		getopts \
		stdio

clean:
	dune clean --root=./test-generator/
	@for assignment in $(ASSIGNMENTS); do \
		dune clean --root=./exercises/practice/$$assignment;\
	done

.PHONY: clean
