open Core.Std
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

let tests =
  ["no difference between empty strands">::
     ae (Some 0) (hamdist "" "");
   "no difference between identical strands">::
     ae (Some 0) (hamdist "GGACTAGA"
                    "GGACTAGA");
   "hamming distance in off by one strand">::
     ae (Some 19) (hamdist "GGACGGATTCTGACCTGGACTAATTTTGGGGG"
                     "AGGACGGATTCTGACCTGGACTAATTTTGGGG");
   "small hamming distance in middle somewhere">::
     ae (Some 1) (hamdist "GGACG"
                    "GGTCG");
   "larger distance">::
     ae (Some 2) (hamdist "ACCAGGG"
                    "ACTATGG");
   "disallow first strand longer">::
     ae None (hamdist "GACTACGGACAGGGTAGGGAAT"
                "GACATCGCACACC");
   "disallow second strand longer">::
     ae None (hamdist "AAACTAGGGG"
                "AGGCTAGCGGTAGGAC")
  ]

let () =
  run_test_tt_main ("point-mutations tests" >::: tests)
