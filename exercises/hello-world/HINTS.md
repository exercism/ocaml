## Use of `option`
The type signature of the `greet` function reads `string option -> string`. It
could be that this is your first time to encounter an Option type.

An option type is an explicit way to signal that a value could be missing for a
legitimate reason.

In OCaml Options types are implemented as
a [variant type](https://realworldocaml.org/v1/en/html/variants.html) something
like

```ocaml
type 'a option =
    | None
    | Some of 'a
```

In the case of `string option` you provide an argument using one of the
following snippets

1. `None` to signal that no subject is passed.
2. `Some("Alice")` to provide an actual subject.

Just like other variants types you can match on an option. The example below
demonstrates how this can be done. Here `x` is an `string option`.

```ocaml
match x with 
    | None           -> "no argument passed"
    | Some(argument) -> "argument passed"
```
