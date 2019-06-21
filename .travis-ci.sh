set -e

if [ $1 == "test" ]; then
  sudo apk add m4 linux-headers
  opam pin add base v0.11.1
  opam install dune ocamlfind core ounit qcheck react ppx_deriving 
  eval $(opam env)
  make test
fi

if [ $1 == "generate" ]; then
  sudo apk add m4 linux-headers
  opam install dune core yojson ounit ocp-indent ppx_deriving
  eval $(opam env)
  sudo git clone https://github.com/exercism/problem-specifications.git ../problem-specifications
  cd ../problem-specifications
  sudo git checkout 2af3c9b0074f16c62366c5c533eaacd3ff27b583 
  cd -
  cd tools/test-generator
  sudo dune exec ./test_gen.exe --profile=release 
  cd -
  sudo ocp-indent -i ../../exercises/**/test.ml
  if output=$(git status --porcelain -- "exercises/**/test.ml") && [ -z "$output" ]; then
    echo "Tests are in sync."
  else
    echo "Checked in test files diverged from generated files:"
    echo $output
    exit 1
  fi
fi 
