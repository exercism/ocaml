# Installation

To work on the exercises, you will need these pieces of software:

1. [`OPAM`, the OCaml Package manager](https://opam.ocaml.org/)

   See [Real World Ocaml, 2nd Ed.: Installation Instructions](https://dev.realworldocaml.org/install.html)
   for how to install and configure `OPAM` for your operating system.

2. The OCaml compiler

   See a list of available versions:

   ```bash
   opam switch
   ```

   If you already have a switch for OCaml 5.1, either load that by running `opam switch <switch-name>`, or create a new switch by running:

   ```bash
   opam switch create exercism 5.1.1
   ```

   The name `exercism` here is optional, but naming your switches is a good practice.

3. Install extended standard libraries and test libraries

   Run the script to install the dependencies required by this track:

   ```bash
   opam install dune fpath ocamlfind ounit qcheck react ppx_deriving ppx_let ppx_sexp_conv yojson ocp-indent calendar getopts
   ```

   Some exercises use only the OCaml standard library, and some use the extended libraries by Jane Street called Base and Core_kernel.
   The test library is called OUnit, and some exercises additionally use the QCheck library for property-based tests.

4. Install and use interactive shell (optional)

   A summary of [Setting up and using `utop`](https://dev.realworldocaml.org/install.html):

   ```bash
   opam install utop
   ```

   Place the following in the file `.ocamlinit` in your home directory should contain something like:

   ```ocaml
   #use "topfind";;
   #require "base";;
   open Base
   ```

5. Install IDE related tools (optional)

   The following relates to using VS Code as your code editor. Adjust accordingly.
   Install the OCaml language server from [here](https://github.com/ocaml/ocaml-lsp).
   Install the OCaml VS Code extension from [here](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform), or search for `OCaml Platform` by Ocaml Labs.
