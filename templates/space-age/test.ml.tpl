(* {{name}} - {{version}} *)
open Base
open OUnit2
open Space_age

let ae ~delta:delta exp got _ctxt =
  let msg = Printf.sprintf "Expected %f got %f, difference is greater than %f"
                    exp got delta in
  assert_bool msg (cmp_float ~epsilon:delta exp got)

let tests = [
{{#cases}}
   "{{description}}" >::
      ae ~delta:0.05 {{#input}}{{expected}} (age_on {{planet}} {{seconds}}){{/input}};
   {{/cases}}
]

let () =
  run_test_tt_main ("space-age tests" >::: tests)