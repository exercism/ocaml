sudo apk add m4 linux-headers
opam pin add base v0.11.1
opam install dune ocamlfind core ounit qcheck react ppx_deriving 
eval $(opam env)
make test
