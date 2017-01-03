open Core.Std
open OUnit2
open Dominoes

let print_dominoe (d1, d2) = sprintf "(%d,%d)" d1 d2

let option_printer = function
  | None -> "None"
  | Some xs -> "Some [" ^ String.concat ~sep:";" (List.map xs ~f:print_dominoe) ^ "]"

let drop_1_right xs = List.rev xs |> List.tl_exn |> List.rev

let check_chain (chained: dominoe list) = 
  let assert_dominoes_match d1 d2 =
    if snd d1 <> fst d2 then failwith @@ sprintf "%s and %s cannot be chained together" (print_dominoe d1) (print_dominoe d2) else () in
  let consecutives = List.zip_exn (drop_1_right chained) (List.tl_exn chained) in
  List.iter consecutives ~f:(fun (d1, d2) -> assert_dominoes_match d1 d2)

let assert_empty c = if List.is_empty c then () else failwith "Expected 0 length chain"

let assert_valid_chain input _ctxt =
  match chain input with
  | None -> failwith "Expecting a chain"
  | Some(c) -> (if List.is_empty input then assert_empty else check_chain) c  

let assert_no_chain input _ctxt =
  assert_equal None (chain input) ~printer:option_printer

let assert_chain input hasChain =
  if hasChain then assert_valid_chain input else assert_no_chain input

let tests = [
(* TEST
  "$description" >::
    assert_chain $input $expected;
END TEST *)
]

let () =
  run_test_tt_main ("dominoes tests" >::: tests)
