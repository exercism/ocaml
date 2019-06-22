open Base
open Base.List.Or_unequal_lengths

type nucleotide = A | C | G | T

let equal (x,y) = match (x, y) with
| (A, A) -> true
| (C, C) -> true
| (G, G) -> true
| (T, T) -> true
| _ -> false

let hamming_distance a b =
  List.zip a b 
  |> function 
     | Unequal_lengths -> None 
     | Ok x -> Some x
  |> Option.map ~f:(List.count ~f:(Fn.non equal))
