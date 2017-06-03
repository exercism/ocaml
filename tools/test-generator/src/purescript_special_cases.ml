open Core

open Model
open Yojson.Basic

let optional_int ~(none: int) = function
| `Int n when n = none -> "Nothing"
| `Int n -> "(Just " ^ Int.to_string n ^ ")"
| x -> json_to_string x

let edit_expected ~(stringify: json -> string) ~(slug: string) ~(value: json) = match slug with
| "hamming" -> optional_int ~none:(-1) value
| _ -> stringify value
