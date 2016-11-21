open Core.Std

open Model

let replace_key (key: string) (value: string) (target: string): string =
  String.substr_replace_all target ~pattern:("$" ^ key) ~with_:value

let rec replace_keys (s: string) (c: case): string =
  let s = replace_key "name" c.name s in
  let s = replace_key "expected" (parameter_to_string c.expected) s in
  List.fold c.parameters ~init:s ~f:(fun s (k,v) -> replace_key k (parameter_to_string v) s)

let generate_code template cases =
  Ok (List.map cases ~f:(replace_keys template))
