#!/bin/bash
set -e

function prepare () {
  sudo apk add m4 linux-headers
  opam install dune ocamlfind core ounit qcheck react ppx_deriving yojson ounit ocp-indent
  eval $(opam env)
}

function run_generator () {
  sudo git clone https://github.com/exercism/problem-specifications.git ../problem-specifications
  cd ../problem-specifications
  sudo git checkout 2af3c9b0074f16c62366c5c533eaacd3ff27b583 
  cd -
  cd tools/test-generator
  sudo dune exec ./test_gen.exe --profile=release 
  cd -
  # sudo ocp-indent -i exercises/**/test.ml
  sudo ocp-indent -i exercises/{connect,etl,minesweeper,rectangles}/test.ml
  if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
    echo "Tests are in sync."
  else
    echo "Checked in test files diverged from generated files:"
    echo $output
    # exit 1
  fi
}

function run_tests () {
  make test
}

prepare && run_generator && run_tests