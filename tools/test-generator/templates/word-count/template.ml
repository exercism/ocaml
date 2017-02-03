open Core.Std
open OUnit2
open Word_count

module SMap = String.Map

let ae exp got _test_ctxt =
  let printer m = SMap.sexp_of_t Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal (SMap.of_alist_exn exp) got ~cmp:(SMap.equal (=)) ~printer

let tests = [
(* TEST
   "$description" >::
      ae $expected
         (word_count $input);
   END TEST *)
]

let () =
  run_test_tt_main ("word_count tests" >::: tests)
