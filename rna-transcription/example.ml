open Core.Std

type dna = [ `A | `C | `G | `T ]
type rna = [ `A | `C | `G | `U ]

let to_rna = List.map ~f:(function
    | `A -> `U
    | `C -> `G
    | `G -> `C
    | `T -> `A)
