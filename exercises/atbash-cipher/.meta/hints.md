## Deprecation of String.lowercase
Depending on the version of OCaml you installed the use of `String.lowercase` is
frowned upon. Since version 4.03.0 `String.lowercase` is deprecated in favor of
`String.lowercase_ascii`. So instead of writing 

```ocaml
String.lowercase "Hello, World!"
```

use

```ocaml
String.lowercase_ascii "Hello, World!"
```

See [String documentation](http://caml.inria.fr/pub/docs/manual-ocaml/libref/String.html) 
for more useful functions.
