open Base

open Model
open Yojson.Basic

let map_elements (to_str: json -> string) (parameters: (string * json) list): (string * string) list =
  List.map parameters ~f:(fun (k,j) -> (k,to_str j))

let optional_int ~(none: int) = function
| `Int n when n = none -> "Nothing"
| `Int n -> "(Just " ^ Int.to_string n ^ ")"
| x -> json_to_string x

let rec edit_expected ~(f: json -> string) (parameters: (string * json) list) = match parameters with
| [] -> []
| ("expected", v) :: rest -> ("expected", f v) :: edit_expected f rest
| (k, v) :: rest -> (k, json_to_string v) :: edit_expected f rest

let purescript_edit_parameters ~(slug: string) (parameters: (string * json) list) = match (slug, parameters) with
| ("hamming", ps) -> edit_expected ~f:(optional_int ~none:(-1)) ps |> Option.return
| (_, ps) -> map_elements json_to_string ps |> Option.return
