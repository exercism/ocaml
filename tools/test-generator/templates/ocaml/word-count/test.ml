open Base
open OUnit2
open Word_count

let ae exp got _test_ctxt =
  let cmp = Map.equal (=) in
  let sexp_of_map = Map.sexp_of_m__t (module String) in
  let printer m = sexp_of_map Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal ((Map.of_alist_exn (module String)) exp) got ~cmp ~printer

let tests = [
(* TEST
   "$description" >::
      ae $expected
         (word_count $sentence);
   END TEST *)
]

let () =
  run_test_tt_main ("word_count tests" >::: tests)
