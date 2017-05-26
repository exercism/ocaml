open Core

type nucleotide = A | C | G | T

let hamming_distance a b =
  List.zip a b |> Option.map ~f:(List.count ~f:(Tuple2.uncurry (<>)))
