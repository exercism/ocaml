open Base

let transform data =
  let assign_value value character = ((Char.lowercase character), value) in
  let assign (value, characters) = List.map ~f:(assign_value value) characters in
  let compare (a, _) (b, _) = Char.compare a b in
  List.sort ~compare:compare (List.concat (List.map ~f:assign data))
