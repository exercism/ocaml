open Core
open OUnit2
open Etl

let ae exp got _test_ctxt =
  let sexpr_of l = List.sexp_of_t (Tuple2.sexp_of_t Char.sexp_of_t Int.sexp_of_t) l in
  let printer l = Sexp.to_string (sexpr_of l) in
  assert_equal exp got ~printer

let tests = [
(* TEST
   "$description" >::
      ae $expected 
         (transform $input);
   END TEST *)
]

let () =
  run_test_tt_main ("etl tests" >::: tests)
