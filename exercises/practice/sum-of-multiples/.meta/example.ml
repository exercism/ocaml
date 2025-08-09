let sum factors limit =
  List.init (limit - 1) ((+) 1)
  |> List.filter (fun i -> List.exists (fun f -> f <> 0 && i mod f = 0) factors)
  |> List.fold_left ( + ) 0
