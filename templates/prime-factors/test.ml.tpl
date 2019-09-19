(* {{name}} - {{version}} *)
open Base
open OUnit2
open Prime_factors

(* Assert Equals *)
let ae exp got _test_ctxt =
  let printer xs = List.map xs ~f:Int64.to_string |> String.concat ~sep:";" in
  assert_equal exp got ~printer

let to_int64s = List.map ~f:Int64.of_int

(* 64 bits integers are needed for the last number.
 *
 * If you happen to use a 64 bits machine normal ints would do as well, but this
 * works for everybody.
 *)
let tests = [
   {{#cases}}
      {{#cases}}
         "{{description}}" >::
            ae (to_int64s {{#input}}{{expected}}) (factors_of {{value}}L){{/input}};
      {{/cases}}
   {{/cases}}
]

let () =
  run_test_tt_main ("prime-factors tests" >::: tests)
