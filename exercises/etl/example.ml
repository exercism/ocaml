open Base

let transform data =
  let assign points letter = (Char.lowercase letter, points) in
  let gather (points, letters) = List.map letters ~f:(assign points) in
  let compare (a, _) (b, _) = Char.compare a b in
  List.sort ~compare (List.concat_map data ~f:gather)
