## Error: No implementations provided for the following modules:
         Str referenced from bob.cmx

### Message
```
+ ocamlfind ocamlopt -linkpkg -g -thread -package oUnit -package core bob.cmx test.cmx -o test.native
File "_none_", line 1:
Error: No implementations provided for the following modules:
         Str referenced from bob.cmx
Command exited with code 2.
```

### Reason
You are using a module in your solution, in this case the `Str` module, and the
OCaml build tool is not aware of this.

### Solution
Add the module you are trying to use to the `ocamlbuild` build options.

Modify the `test.native` directive of the Makefile to be:

```
test.native: *.ml *.mli
    @corebuild -quiet -pkg oUnit -pkg str test.native
```

Note the additional `-pkg str` option.
