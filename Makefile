# assignments
ASSIGNMENT ?= ""
ASSIGNMENTS = $(shell git ls-tree --name-only HEAD -- exercises/ | awk -F/ '{print $$NF}' | sort)

default: testgenerator test

# output directories
TMPDIR ?= "/tmp/"
OUTDIR := $(shell mktemp -d "$(TMPDIR)$(ASSIGNMENT).XXXXXXXXXX")

# language specific config (tweakable per language)
FILEEXT := "ml"
EXAMPLE := "example.$(FILEEXT)"
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
	@cp -r ./exercises/$(ASSIGNMENT)/* $(OUTDIR)
	@cp ./exercises/$(ASSIGNMENT)/$(EXAMPLE) $(OUTDIR)/$(SRCFILE).$(FILEEXT)
	@make -C $(OUTDIR)
	@rm -rf $(OUTDIR)

testgenerator:
	make -C ./tools/test-generator

# all tests
test:
	@for assignment in $(ASSIGNMENTS); do \
		ASSIGNMENT=$$assignment $(MAKE) -s test-assignment || exit 1;\
	done

clean:
	make -C ./tools/test-generator clean
	@for assignment in $(ASSIGNMENTS); do \
		make -C ./exercises/$$assignment clean;\
	done

.PHONY: clean
