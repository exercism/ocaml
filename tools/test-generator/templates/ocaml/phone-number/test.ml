open Base
open OUnit2
open Phone_number

let result_to_string ~f = function
  | Error m   -> m |> Printf.sprintf "Error \"%s\""
  | Ok x -> f x |> Printf.sprintf "Some %s"

let ae exp got _test_ctxt =
  assert_equal ~printer:(result_to_string ~f:Fn.id) exp got

let tests = [
(* TEST
  "$description" >::
    ae $expected (number $phrase);
END TEST *)
]

let () =
  run_test_tt_main ("phone-number tests" >::: tests)
