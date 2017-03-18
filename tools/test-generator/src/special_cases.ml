open Core.Std

open Model
open Yojson.Basic

let map_elements (to_str: json -> string) (parameters: (string * json) list): (string * string) list =
  List.map parameters ~f:(fun (k,j) -> (k,to_str j))

let optional_int ~(none: int) = function
| `Int n when n = none -> "None"
| `Int n -> "(Some " ^ Int.to_string n ^ ")"
| x -> json_to_string x

let optional_int_list = function
| `List xs -> "(Some [" ^ String.concat ~sep:"; " (List.map ~f:json_to_string xs) ^ "])"
| _ -> "None"

let optional_int_or_string ~(none: int) = function
| `String s -> "(Some \"" ^ s ^ "\")"
| `Int n when n = none -> "None"
| x -> json_to_string x

let default_value ~(key: string) ~(value: string) (parameters: (string * string) list): (string * string) list =
  if List.exists ~f:(fun (k, _) -> k = key) parameters
  then parameters
  else (key, value) :: parameters

let optional_strings ~(f: string -> bool) (parameters: (string * json) list): (string * string) list =
  let replace parameter =
    let (k, v) = parameter in
    if f k
    then (k, "(Some " ^ json_to_string v ^ ")")
    else (k, json_to_string v) in
  List.map ~f:replace parameters

let option_of_null (value: json): string = match value with
| `Null -> "None"
| `String s -> "(Some \"" ^ s ^ "\")"
| _ -> failwith "cannot handle this type"

let is_empty_string (value: json): bool = match value with
| `String s -> String.is_empty s
| _ -> false

let edit_connect_expected = function
| `String "X" -> "(Some X)"
| `String "O" -> "(Some O)"
| `String "" -> "None"
| x -> failwith "Bad json value in connect " ^ json_to_string x

let edit_change_expected (value: json) = match value with
| `List xs -> "(Some [" ^ (String.concat ~sep:"; " (List.map ~f:json_to_string xs)) ^ "])"
| `Int (-1) -> "None"
| _ -> failwith "Bad json value in change"

let edit_expected ~(stringify: json -> string) ~(slug: string) ~(value: json) = match slug with
| "hamming" -> optional_int ~none:(-1) value
| "all-your-base" -> optional_int_list value
| "say" -> optional_int_or_string ~none:(-1) value
| "phone-number" -> option_of_null value
| "connect" -> edit_connect_expected value
| "change" -> edit_change_expected value
| _ -> stringify value

let edit_say (ps: (string * json) list) =
  let edit = function
  | ("input", v) -> ("input", let v = json_to_string v in if Int.of_string v >= 0 then "(" ^ v ^ "L)" else v ^ "L")
  | (k, ps) -> (k, json_to_string ps) in
  List.map ps ~f:edit

let edit_all_your_base (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("output_base", v) -> let v = json_to_string v in ("output_base", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
  | ("input_base", v) -> let v = json_to_string v in ("input_base", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_dominoes (ps: (string * json) list): (string * string) list =
  let two_elt_list_to_tuple (j: json): string = match j with
  | `List [`Int x1; `Int x2] -> sprintf "(%d,%d)" x1 x2
  | _ -> failwith "two element list expected, but got " ^ (json_to_string j) in 
  let edit (p: (string * json)) = match p with
  | ("input", `List j) -> ("input", "[" ^ (List.map ~f:two_elt_list_to_tuple j |> String.concat ~sep:"; ") ^ "]")
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_space_age (ps: (string * json) list): (string * string) list =
  let strip_quotes s = String.drop_prefix s 1 |> Fn.flip String.drop_suffix 1 in
  let edit = function
  | ("planet", v) -> ("planet", json_to_string v |> strip_quotes) 
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit
  
let edit_parameters ~(slug: string) (parameters: (string * json) list) = match (slug, parameters) with
| ("hello-world", ps) -> default_value ~key:"name" ~value:"None" (optional_strings ~f:(fun _x -> true) parameters)
| ("say", ps) -> edit_say ps
| ("all-your-base", ps) -> edit_all_your_base ps
| ("dominoes", ps) -> edit_dominoes ps
| ("space-age", ps) -> edit_space_age ps
| (_, ps) -> map_elements json_to_string ps

let expected_key_name slug = match slug with
| "dominoes" -> "can_chain"
| _ -> "expected"

let cases_name _slug = "cases"
