# Edit this for your own project dependencies
OPAM_DEPENDS="ocamlfind core ounit qcheck react ppx_deriving"

echo "Downloading OPAM install"
wget https://github.com/ocaml/opam/releases/download/2.0.0/opam-full-2.0.0.tar.gz
echo "Unzipping OPAM package"
gzip -d opam-full-2.0.0.tar.gz
tar -xf opam-full-2.0.0.tar 
echo "WHERE ARE WE"
ls
pwd

sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam
export OPAMYES=1
export OPAMVERBOSE=1
echo OCaml version
ocaml -version
echo OPAM versions
opam --version

opam init
opam switch $OCAML_VERSION
eval `opam config env`
opam install ${OPAM_DEPENDS}

make test
