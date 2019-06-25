#!/bin/bash
set -e

eval $(opam env)

sudo git clone https://github.com/exercism/problem-specifications.git /problem-specifications
cd /problem-specifications
sudo git checkout 2af3c9b0074f16c62366c5c533eaacd3ff27b583 
cd /repo/tools/test-generator
sudo dune exec ./test_gen.exe --profile=release
cd /repo
sudo ocp-indent -i exercises/**/test.ml

# Remove checkout line for tests with adapted 
# special cases and implementations
sudo git checkout -- exercises/acronym/test.ml
# sudo git checkout -- exercises/all-your-base/test.ml
# sudo git checkout -- exercises/anagram/test.ml
sudo git checkout -- exercises/atbash-cipher/test.ml
# sudo git checkout -- exercises/beer-song/test.ml
sudo git checkout -- exercises/binary-search/test.ml
sudo git checkout -- exercises/bob/test.ml
# sudo git checkout -- exercises/bowling/test.ml
sudo git checkout -- exercises/change/test.ml
# sudo git checkout -- exercises/connect/test.ml
sudo git checkout -- exercises/difference-of-squares/test.ml
sudo git checkout -- exercises/dominoes/test.ml
sudo git checkout -- exercises/etl/test.ml
sudo git checkout -- exercises/forth/test.ml
sudo git checkout -- exercises/hamming/test.ml
sudo git checkout -- exercises/hello-world/test.ml
# sudo git checkout -- exercises/leap/test.ml
sudo git checkout -- exercises/luhn/test.ml
# sudo git checkout -- exercises/minesweeper/test.ml
sudo git checkout -- exercises/palindrome-products/test.ml
sudo git checkout -- exercises/pangram/test.ml
sudo git checkout -- exercises/phone-number/test.ml
sudo git checkout -- exercises/prime-factors/test.ml
sudo git checkout -- exercises/raindrops/test.ml
sudo git checkout -- exercises/rectangles/test.ml
sudo git checkout -- exercises/roman-numerals/test.ml
sudo git checkout -- exercises/run-length-encoding/test.ml
sudo git checkout -- exercises/say/test.ml
sudo git checkout -- exercises/space-age/test.ml
sudo git checkout -- exercises/triangle/test.ml
sudo git checkout -- exercises/word-count/test.ml

# if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
#  echo "Tests are in sync."
# else
#  echo "Checked in test files diverged from generated files:"
#  echo $output
#   exit 1
# fi

make test
