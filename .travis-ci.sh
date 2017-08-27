# Edit this for your own project dependencies
OPAM_DEPENDS="ocamlfind core ounit react ppx_deriving"

case "$OCAML_VERSION,$OPAM_VERSION" in
    4.05.0,1.2.2) ppa=avsm/ocaml42+opam12 ;;
    *) echo Unknown $OCAML_VERSION,$OPAM_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
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
