open Core.Std
open OUnit2
open Say

let ae exp got _ctx = assert_equal ~printer:(Option.value ~default:"None") exp got

let tests = [
(* TEST
   "$description" >:: (
      ae $expected
         (in_english $input));
   END TEST *)
  "all numbers from 1 to 10_000 can be spelt">::(fun _ ->
      assert_bool "range test" (Sequence.range 0 10_000
                                |> Sequence.map ~f:(fun n -> Int64.of_int n |> in_english)
                                |> Sequence.filter ~f:(Option.is_none)
                                |> Sequence.is_empty));
]

let () =
  run_test_tt_main ("say tests" >::: tests)
