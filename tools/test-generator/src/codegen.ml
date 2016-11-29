open Core.Std

open Model

type fixup_parameter_function = key: string -> value: parameter -> string

type edit_parameters_function = (string * string) list -> (string * string) list

type subst = Subst of string [@@deriving eq, show]

let subst_to_string (Subst s) = s

let replace_key (key: string) (value: string) (target: string): string =
  let replace = String.substr_replace_all ~with_:value in
  replace ~pattern:("$" ^ key) target |> replace ~pattern:("$(" ^ key ^ ")")

let rec replace_keys (f: fixup_parameter_function) (ed: edit_parameters_function) (s: string) (c: case): subst =
  let s = replace_key "description" c.description s in
  let expected = f ~key:"expected" ~value:c.expected in
  let s = replace_key "expected" expected s in
  let parameter_strings = ed @@ List.map ~f:(fun (k,p) -> (k,parameter_to_string p)) c.parameters in
  List.fold parameter_strings ~init:(Subst s) ~f:(fun (Subst s) (k,v) -> Subst (replace_key k v s))

let generate_code (f: fixup_parameter_function) (ed: edit_parameters_function) template cases =
  Ok (List.map cases ~f:(replace_keys f ed template))
