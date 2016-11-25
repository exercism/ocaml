open Core.Std

module SMap = String.Map

let add_to_map wcs w =
  SMap.update wcs w ~f:(fun k -> Option.value_map k ~default:1 ~f:((+) 1))

let normalize = function
  | ch when Char.is_alphanum ch || ch = '\'' -> Char.lowercase ch
  | _ -> ' '

let word_count s =
  let s = String.substr_replace_all s ~pattern:" \'" ~with_:" " in
  let s = String.substr_replace_all s ~pattern:"\' " ~with_:" " in
  let s = String.map s ~f:normalize in
  let split = List.filter (String.split s ~on:' ') ~f:(Fn.non String.is_empty) in
  List.fold ~init:SMap.empty ~f:add_to_map split
