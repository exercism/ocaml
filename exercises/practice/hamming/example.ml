open Base

type nucleotide = A | C | G | T

let equal (x,y) = match (x, y) with
| (A, A) -> true
| (C, C) -> true
| (G, G) -> true
| (T, T) -> true
| _ -> false

let to_result (l: 'a List.Or_unequal_lengths.t): ('a, string) Result.t = 
  let open List.Or_unequal_lengths in
  match l with 
  | Unequal_lengths -> Error "left and right strands must be of equal length" 
  | Ok x -> Ok x

let hamming_distance a b =
  match (List.is_empty a, List.is_empty b) with
  | (true, false) -> Error "left strand must not be empty" 
  | (false, true) -> Error "right strand must not be empty"
  | _ -> List.zip a b |> to_result |> Result.map ~f:(List.count ~f:(Fn.non equal))

