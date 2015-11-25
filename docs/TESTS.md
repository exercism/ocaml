Because OCaml is a compiled language you need to compile your submission and the test code before you can run the tests. Compile with

```bash
$ corebuild -quiet test.native
```

and when successful run the tests by running the `test.native` executable:

```bash
./test.native
```

Alternatively just type

```bash
make
```

## Creating Your First OCaml Module

To create a module that can be used with the test in the `bob` exercise put the following in a file named `bob.ml`:

```ocaml
open Core.Std let response_for input = failwith "TODO"
```
