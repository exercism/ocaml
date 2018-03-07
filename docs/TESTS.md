Because OCaml is a compiled language you need to compile your submission and the test code before you can run the tests. 
We use [`jbuilder`](https://jbuilder.readthedocs.io/en/latest/) to build.
Each folder has a jbuild file specifying how to build and also a Makefile which delegates to jbuild.

To compile and run the tests, simply type from the exercise folder:
```bash
make
```

## Creating Your First OCaml Module

To create a module that can be used with the test in the `bob` exercise put the following in a file named `bob.ml`:

```ocaml
open Base 

let response_for input = failwith "TODO"
```
