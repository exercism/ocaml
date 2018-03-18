open Base
open OUnit2
open Hamming

let printer = function
| None -> "None"
| Some x -> Int.to_string x

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
(* TEST
   "$description" >::
      ae $expected (hamdist $strand1 $strand2);
   END TEST *)
]

let () =
  run_test_tt_main ("hamming tests" >::: tests)
