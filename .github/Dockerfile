FROM ocaml/opam2:ubuntu-18.04-ocaml-4.07

USER root

RUN apt-get update \
 && apt-get install -y m4 bmake cpio net-tools fswatch pkg-config \
 && rm -rf /var/lib/apt/lists/*

RUN cd /home/opam/opam-repository \
 && git pull \
 && git checkout a7fc137299d8c9e0fa8cfbfe8c902698c7ec5628 \
 && cd -

RUN opam update \
 && opam install merlin \
                 yaml \
                 ezjsonm \
                 mustache \
                 dune \
                 fpath \
                 ocamlfind \
                 ounit \
                 qcheck \
                 react \
                 ppx_deriving \
                 ppx_let \
                 ppx_sexp_conv \
                 yojson \
                 ocp-indent \
                 calendar \
                 getopts \
 && ln -s /home/opam/.opam /root/.opam

SHELL ["/bin/bash", "--login" , "-c"]
ENV OPAM_SWITCH_PREFIX='/home/opam/.opam/4.07' \
    CAML_LD_LIBRARY_PATH='/home/opam/.opam/4.07/lib/stublibs:/home/opam/.opam/4.07/lib/ocaml/stublibs:/home/opam/.opam/4.07/lib/ocaml' \
    OCAML_TOPLEVEL_PATH='/home/opam/.opam/4.07/lib/toplevel' \
    MANPATH=':/root/.opam/4.07.1/man:/home/opam/.opam/4.07/man' \
    PATH='/home/opam/.opam/4.07/bin:/root/.opam/4.07.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
