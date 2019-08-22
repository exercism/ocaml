FROM ocaml/opam2:ubuntu-18.04-ocaml-4.07

RUN sudo apt-get update
RUN sudo apt-get install m4 bmake cpio -y

RUN cd /home/opam/opam-repository
RUN git pull
RUN git checkout c23c1a7071910f235d5bc173cbadb97cd450e9fb
RUN cd -

RUN opam update
RUN opam install dune ocamlfind ounit qcheck react ppx_deriving yojson ounit ocp-indent calendar

RUN sudo apt-get install net-tools fswatch -y

USER root
RUN ln -s /home/opam/.opam /root/.opam
SHELL ["/bin/bash", "--login" , "-c"]
ENV OPAM_SWITCH_PREFIX='/root/.opam/4.07.1'
ENV CAML_LD_LIBRARY_PATH='/root/.opam/4.07.1/lib/stublibs:/root/.opam/4.07.1/lib/ocaml/stublibs:/root/.opam/4.07.1/lib/ocaml'
ENV OCAML_TOPLEVEL_PATH='/root/.opam/4.07.1/lib/toplevel'
ENV MANPATH=':/root/.opam/4.07.1/man'
ENV PATH='/root/.opam/4.07.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
