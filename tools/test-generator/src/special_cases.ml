open Core.Std

open Model

let optional_int ~(none: int) = function
  | Int n when n = none -> "None"
  | Int n -> "(Some " ^ Int.to_string n ^ ")"
  | x -> parameter_to_string x

let optional_int_list = function
  | IntList xs -> "(Some [" ^ String.concat ~sep:"; " (List.map ~f:Int.to_string xs) ^ "])"
  | _ -> "None"

let optional_int_or_string ~(none: int) = function
  | String s -> "(Some \"" ^ s ^ "\")"
  | Int n when n = none -> "None"
  | x -> parameter_to_string x

let default_value ~(key: string) ~(value: string) (parameters: (string * string) list): (string * string) list =
  if List.exists ~f:(fun (k, _) -> k = key) parameters
  then parameters
  else (key, value) :: parameters

let optional_strings ~(f: string -> bool) (parameters: (string * string) list): (string * string) list =
  let replace parameter =
    let (k, v) = parameter in
    if f k
    then (k, "(Some \"" ^ v ^ "\")")
    else parameter in
  List.map ~f:replace parameters

let edit_expected ~(stringify: parameter -> string) ~(slug: string) ~(value: parameter) = match slug with
  | "hamming" -> optional_int ~none:(-1) value
  | "all-your-base" -> optional_int_list value
  | "say" -> optional_int_or_string ~none:(-1) value
  | _ -> stringify value

let edit_say (ps: (string * string) list) =
  let edit = function
    | ("input", v) -> ("input", if Int.of_string v >= 0 then "(" ^ v ^ "L)" else v ^ "L")
    | x -> x in
  List.map ps ~f:edit

let edit_all_your_base (ps: (string * string) list) =
  let edit = function
    | ("output_base", v) -> ("output_base", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
    | ("input_base", v) -> ("input_base", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
    | x -> x in
  List.map ps ~f:edit

let edit_parameters ~(slug: string) (parameters: (string * string) list) = match (slug, parameters) with
  | ("hello-world", ps) -> default_value ~key:"name" ~value:"None"
    @@ optional_strings ~f:(fun _x -> true)
    @@ parameters
  | ("say", ps) -> edit_say ps
  | ("all-your-base", ps) -> edit_all_your_base ps
  | (_, ps) -> ps
