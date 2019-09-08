(* hamming - 2.3.0 *)
open Base
open OUnit2
open Hamming

let printer = function
  | Error m -> "Error \"" ^ m ^ "\""
  | Ok x -> "Ok " ^ (Int.to_string x)

let ae exp got _test_ctxt = assert_equal ~printer exp got

let dna_of_string s =
  let f = function
    | 'A' -> A
    | 'C' -> C
    | 'G' -> G
    | 'T' -> T
    | _   -> failwith "Big news! New nucleotide discovered" in
  String.to_list s |> List.map ~f

let hamdist a b = hamming_distance (dna_of_string a) (dna_of_string b)

let tests = [
  "empty strands" >::
  ae (Ok 0) (hamdist "" "");
  "single letter identical strands" >::
  ae (Ok 0) (hamdist "A" "A");
  "single letter different strands" >::
  ae (Ok 1) (hamdist "G" "T");
  "long identical strands" >::
  ae (Ok 0) (hamdist "GGACTGAAATCTG" "GGACTGAAATCTG");
  "long different strands" >::
  ae (Ok 9) (hamdist "GGACGGATTCTG" "AGGACGGATTCT");
  "disallow first strand longer" >::
  ae  (Error "left and right strands must be of equal length") (hamdist "AATG" "AAA");
  "disallow second strand longer" >::
  ae  (Error "left and right strands must be of equal length") (hamdist "ATA" "AGTG");
  "disallow left empty strand" >::
  ae  (Error "left strand must not be empty") (hamdist "" "G");
  "disallow right empty strand" >::
  ae  (Error "right strand must not be empty") (hamdist "G" "");
]

let () =
  run_test_tt_main ("hamming tests" >::: tests)
