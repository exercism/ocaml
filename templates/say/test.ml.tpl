(* {{name}} - {{version}} *)
open Base
open OUnit2
open Say

let printer = function
  | Error m -> m |> Printf.sprintf "Error \"%s\""
  | Ok v -> v |> Printf.sprintf "Ok %s"

let ae exp got _ctx = assert_equal ~printer exp got

let tests = [
{{#cases}}
   "{{description}}" >::
      ae {{#input}}{{expected}} (in_english {{number}}){{/input}};
   {{/cases}}
  "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
      assert_bool "range test" (Sequence.range 0 10_000
                                |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
                                |> Sequence.filter ~f:Result.is_error
                                |> Sequence.is_empty));
]

let () =
  run_test_tt_main ("say tests" >::: tests)
