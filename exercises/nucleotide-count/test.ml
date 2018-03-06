open Core_kernel
open OUnit2

module CMap = Char.Map

(* Assert Int Equals *)
let aie exp got _test_ctxt =
  let printer = Int.to_string in
  assert_equal exp got ~printer
(* Assert Map Equals *)
let ame exp got =
  let printer m = CMap.sexp_of_t Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~cmp:(CMap.equal (=)) ~printer

let tests =
  ["empty dna string has no adenine">::
    aie 0 (Nucleotide_count.count "" 'A');
   "empty dna string has no nucleotides">:: (fun _ ->
    let exp = CMap.empty in
    ame exp (Nucleotide_count.nucleotide_counts ""));
   "repetitive cytosine gets counted">::
    aie 5 (Nucleotide_count.count "CCCCC" 'C');
   "repetitive sequence has only guanine">:: (fun _ ->
    let exp = CMap.singleton 'G' 8 in
    ame exp (Nucleotide_count.nucleotide_counts "GGGGGGGG"));
   "counts only thymine">::
    aie 1 (Nucleotide_count.count "GGGGGTAACCCGG" 'T');
   "dna has no uracil">::
    aie 0 (Nucleotide_count.count "GATTACA" 'U');
   "counts all nucleotides">:: (fun _ ->
    let s = "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC" in
    let exp = CMap.of_alist_exn [('A', 20); ('T', 21); ('C', 12); ('G', 17)] in
    ame exp (Nucleotide_count.nucleotide_counts s))
  ]

let () =
  run_test_tt_main ("nucleotide-counts tests" >::: tests)
