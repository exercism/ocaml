#!/bin/bash
set -e

eval $(opam env)

cd /repo
dune build @buildtest

cd /repo/test-generator
dune runtest 

cd /repo/test-generator/bin_test_gen
dune exec ./test_gen.exe --profile=release -- -w ../../../../

cd /repo

if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
 echo "Tests are in sync."
else
 echo "Checked in test files diverged from generated files:"
 echo $output
 exit 1
fi

make test
