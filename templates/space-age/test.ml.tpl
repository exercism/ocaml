(* {{name}} - {{version}} *)
open Base
open OUnit2
open Space_age

let ae ~delta exp_result got_result _test_ctxt =
  match (exp_result, got_result) with
  | Ok exp, Ok got ->
      let diff = Float.abs (exp -. got) in
      let msg = Printf.sprintf "Expected %f, got %f (diff %f > delta %f)" exp got diff delta in
      assert_bool msg (Float.(diff <= delta))
  | Error exp_msg, Error got_msg ->
      assert_equal exp_msg got_msg ~printer:Fn.id
  | Ok _, Error m ->
      assert_failure (Printf.sprintf "Expected Ok, but got Error: %s" m)
  | Error m, Ok _ ->
      assert_failure (Printf.sprintf "Expected Error: %s, but got Ok" m)

let tests = [
{{#cases}}
   "{{description}}" >::
      ae ~delta:0.05 ({{#input}}{{expected}}) (age_on "{{planet}}" {{seconds}}){{/input}};
   {{/cases}}
]

let () =
  run_test_tt_main ("space-age tests" >::: tests)