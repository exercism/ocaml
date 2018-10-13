# Edit this for your own project dependencies
OPAM_DEPENDS="ocamlfind core ounit qcheck react ppx_deriving"

echo "yes" | sudo add-apt-repository ppa:avsm/ocaml42+opam12
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
export OPAMVERBOSE=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version
opam --git-version

opam init
opam switch $OCAML_VERSION
eval `opam config env`
opam install ${OPAM_DEPENDS}

make test
