FROM ocaml/opam:debian-11-ocaml-4.14-afl

USER root

RUN apt-get update \
 && apt-get install -y m4 bmake cpio net-tools fswatch pkg-config \
 && rm -rf /var/lib/apt/lists/*

RUN git config --global --add safe.directory "*"

RUN cd /home/opam/opam-repository \
 && git pull origin master

RUN opam update \
 && opam install core \
                 merlin \
                 yaml \
                 ezjsonm \
                 mustache \
                 dune \
                 fpath \
                 ocamlfind \
                 ounit \
                 ounit2 \
                 qcheck \
                 react \
                 ppx_deriving \
                 ppx_let \
                 ppx_sexp_conv \
                 yojson \
                 ocp-indent \
                 calendar \
                 getopts \
                 stdio

ENV PATH="/home/opam/.opam/4.14/bin:${PATH}" \
    MAKESYSPATH=/usr/share/bmake/mk-bmake
