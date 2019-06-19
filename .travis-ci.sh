sudo apk add m4 linux-headers
opam install dune ocamlfind core ounit qcheck react ppx_deriving 
eval $(opam env)
make test
