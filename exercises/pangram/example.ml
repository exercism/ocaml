open Core

let string_to_set s = Char.Set.of_list (String.to_list s)

let alphabet_set = string_to_set "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

let is_pangram s = 
  let normalize s = String.filter ~f:Char.is_alpha s |> String.uppercase in
  Set.equal alphabet_set (string_to_set @@ normalize s)