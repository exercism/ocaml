open Base

open Model

type json = Yojson.Basic.t

type edit_parameters_function = (string * json) list -> (string * string) list option

type subst = Subst of string [@@deriving eq, show]

let subst_to_string (Subst s) = s

let map_subst (s: subst) ~(f: string -> string): subst =
  Subst (subst_to_string s |> f)

let replace_key (key: string) (value: string) (target: string): string =
  let replace = String.substr_replace_all ~with_:value in
  replace ~pattern:("$" ^ key) target |> replace ~pattern:("$(" ^ key ^ ")")

let replace_keys (s: string) (suite_name: string) (c: case) (parameter_strings: (string * string) list): subst =
  let s = replace_key "description" c.description s in
  let s = replace_key "suite-name" suite_name s in
  let s = replace_key "property" c.property s in
  List.fold parameter_strings ~init:(Subst s) ~f:(fun (Subst s) (k,v) -> Subst (replace_key k v s))

let fill_in_template (ed: edit_parameters_function) (test_template: string) (suite_name: string) (cases: case list) =
  cases
  |> List.filter_map ~f:(fun case -> ed case.parameters |> Option.map ~f:(fun p -> (case, p)))
  |> List.map ~f:(fun (case, parameter_strings) -> replace_keys test_template suite_name case parameter_strings)
