(* Test/exercise version: "1.0.0" *)

open Core
open OUnit2

let printer n =
  Option.sexp_of_t Int.sexp_of_t n
  |> Sexp.to_string

let ae exp got _test_ctxt = assert_equal ~printer exp got

let dna_of_string s =
  let open Hamming in
  let f = function
    | 'A' -> A
    | 'C' -> C
    | 'G' -> G
    | 'T' -> T
    | _   -> failwith "Big news! New nucleotide discovered" in
  String.to_list s |> List.map ~f

let hamdist a b = Hamming.hamming_distance (dna_of_string a) (dna_of_string b)

let tests = [
   "identical strands" >::
      ae (Some 0) (hamdist "A" "A");
   "long identical strands" >::
      ae (Some 0) (hamdist "GGACTGA" "GGACTGA");
   "complete distance in single nucleotide strands" >::
      ae (Some 1) (hamdist "A" "G");
   "complete distance in small strands" >::
      ae (Some 2) (hamdist "AG" "CT");
   "small distance in small strands" >::
      ae (Some 1) (hamdist "AT" "CT");
   "small distance" >::
      ae (Some 1) (hamdist "GGACG" "GGTCG");
   "small distance in long strands" >::
      ae (Some 2) (hamdist "ACCAGGG" "ACTATGG");
   "non-unique character in first strand" >::
      ae (Some 1) (hamdist "AGA" "AGG");
   "non-unique character in second strand" >::
      ae (Some 1) (hamdist "AGG" "AGA");
   "same nucleotides in different positions" >::
      ae (Some 2) (hamdist "TAG" "GAT");
   "large distance" >::
      ae (Some 4) (hamdist "GATACA" "GCATAA");
   "large distance in off-by-one strand" >::
      ae (Some 9) (hamdist "GGACGGATTCTG" "AGGACGGATTCT");
   "empty strands" >::
      ae (Some 0) (hamdist "" "");
   "disallow first strand longer" >::
      ae None (hamdist "AATG" "AAA");
   "disallow second strand longer" >::
      ae None (hamdist "ATA" "AGTG");
]

let () =
  run_test_tt_main ("hamming tests" >::: tests)