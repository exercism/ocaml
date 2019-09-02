#!/bin/bash
set -e

eval $(opam env)

cd /repo
dune build @buildtest

cd /repo/tools/test-generator
dune runtest 

cd /repo/tools/test-generator/bin_test_gen
dune exec ./test_gen.exe --profile=release -- -w ../../../../

cd /repo
ocp-indent -i exercises/**/test.ml

if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
 echo "Tests are in sync."
else
 echo "Checked in test files diverged from generated files:"
 echo $output
 exit 1
fi

make test
