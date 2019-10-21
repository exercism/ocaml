FROM ocaml/opam2:ubuntu-18.04-ocaml-4.07

RUN sudo apt-get update
RUN sudo apt-get install m4 bmake cpio -y

RUN cd /home/opam/opam-repository
RUN git pull
RUN git checkout c23c1a7071910f235d5bc173cbadb97cd450e9fb
RUN cd -

RUN opam update

ADD Makefile .
RUN make install_deps
RUN opam install merlin

RUN sudo apt-get install net-tools fswatch -y
RUN sudo apt-get install pkg-config -y

RUN opam install yaml
RUN opam install ezjsonm
RUN opam install mustache

USER root
RUN ln -s /home/opam/.opam /root/.opam
SHELL ["/bin/bash", "--login" , "-c"]
ENV OPAM_SWITCH_PREFIX='/home/opam/.opam/4.07'
ENV CAML_LD_LIBRARY_PATH='/home/opam/.opam/4.07/lib/stublibs:/home/opam/.opam/4.07/lib/ocaml/stublibs:/home/opam/.opam/4.07/lib/ocaml'
ENV OCAML_TOPLEVEL_PATH='/home/opam/.opam/4.07/lib/toplevel'
ENV MANPATH=':/root/.opam/4.07.1/man:/home/opam/.opam/4.07/man'
ENV PATH='/home/opam/.opam/4.07/bin:/root/.opam/4.07.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
