## with sexp
The file `tree.ml` use the following expression: `with sexp`. Using this
expression is [deprecated](https://github.com/janestreet/pa_sexp_conv). The
alternative is using `[@@deriving sexp]`.

Although at the moment `with sexp` can still be used, in could be removed in the
future. So make sure to use the newer form in your own code.
