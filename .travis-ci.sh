if [$0 == "test"]; then
  sudo apk add m4 linux-headers
  opam pin add base v0.11.1
  opam install dune ocamlfind core ounit qcheck react ppx_deriving 
  eval $(opam env)
  make test
fi

if [$0 == "generate"]; then
  sudo apk add m4 linux-headers
  opam pin add jbuilder 1.0+beta20
  opam install core yojson ounit
  eval $(opam env)
  sudo make -C tools/test-generator
  sudo git clone https://github.com/exercism/problem-specifications.git ../problem-specifications
  cd tools/test-generator
  sudo ./test_gen.exe
fi 
