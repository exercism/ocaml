open Core.Std

open Model

let optional_int ~(none: int) = function
  | Int n when n = none -> "None"
  | Int n -> "(Some " ^ Int.to_string n ^ ")"
  | _ -> failwith "can't handle non-int parameter"

let default_value ~(key: string) ~(value: string) (parameters: (string * string) list): (string * string) list =
  if List.exists ~f:(fun (k, _) -> k = key) parameters
  then parameters
  else (key, value) :: parameters

let optional_string ~(f: string -> bool) (parameters: (string * string) list): (string * string) list =
  let replace parameter =
    let (k, v) = parameter in
    if f k
    then (k, "(Some \"" ^ v ^ "\")")
    else parameter in
  List.map ~f:replace parameters

let fixup ~(stringify: parameter -> string) ~(slug: string) ~(key: string) ~(value: parameter) = match (slug, key) with
  | ("hamming", "expected") -> optional_int (-1) value
  | _ -> stringify value

let edit ~(slug: string) (parameters: (string * string) list) = match (slug, parameters) with
  | ("hello-world", ps) -> default_value ~key:"name" ~value:"None"
    @@ optional_string ~f:(fun _x -> true)
    @@ parameters
  | (_, ps) -> ps
