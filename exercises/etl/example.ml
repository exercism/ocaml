open Core.Std

let transform data =
  let assign_value value character = (character, value) in
  let assign (value, characters) = List.map ~f:(assign_value value) characters in
  let compare (a, _) (b, _) = Char.compare a b in
  List.sort compare (List.concat (List.map ~f:assign data))
