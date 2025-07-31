open Base

type nucleotide = A | C | G | T

let equal (x, y) = match (x, y) with
  | (A, A) | (C, C) | (G, G) | (T, T) -> true
  | _ -> false

let hamming_distance a b =
  match List.zip a b with
  | Unequal_lengths -> Error "strands must be of equal length"
  | Ok pairs -> Ok (List.count pairs ~f:(Fn.non equal))
