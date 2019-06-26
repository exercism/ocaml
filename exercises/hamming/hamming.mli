open Base

type nucleotide = A | C | G | T

(** Compute the hamming distance between the two lists. *)
val hamming_distance : nucleotide list -> nucleotide list -> (int, string) Result.t
