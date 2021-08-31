#!/bin/bash
set -e

eval $(opam env)

cd /repo

make build_test
make test_generator
make generate_exercises

if output=$(git status --porcelain -- "exercises/practice/**/test.ml") && [ -z "$output" ]; then
 echo "Tests are in sync."
else
 echo "Checked in test files diverged from generated files:"
 echo $output
 exit 1
fi

make test
