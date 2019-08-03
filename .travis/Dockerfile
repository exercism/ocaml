FROM ocaml/opam2:ubuntu-18.04-ocaml-4.07

RUN sudo apt-get update
RUN sudo apt-get install m4 bmake cpio -y
RUN opam install dune ocamlfind core ounit qcheck react ppx_deriving yojson ounit ocp-indent calendar

RUN sudo apt-get install net-tools