1. Install the OCaml compiler (`ocaml`) and package manager (`opam`).

   The excellent [Real World OCaml](https://realworldocaml.org/) book has
   [installation
   instructions](https://github.com/realworldocaml/book/wiki/Installation-Instructions)
   for a variety of operating systems.

2. If you followed the instructions from Real World OCaml, it is likely that
   your system's OCaml compiler is not the latest version.

   To see a list of available versions and the one you have currently installed,
   run:

   ```bash
   opam switch
   ```

   Note which version is the latest and install it by running:

   ```bash
   opam switch <version-number>
   ```

   For example, if the latest version is 4.06.1, you will run:

   ```bash
   opam switch 4.06.1
   ```

3. Install the Core_kernel and [OUnit](http://ounit.forge.ocamlcore.org/) packages,
   which are necessary in order to run the exercise tests:

   ```bash
   opam install core_kernel ounit
   ```

