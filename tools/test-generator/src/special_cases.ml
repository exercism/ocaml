open Core.Std

open Model

let optional_int ~(none: int) = function
  | Int n when n = none -> "None"
  | Int n -> "(Some " ^ Int.to_string n ^ ")"
  | _ -> failwith "can't handle non-int parameter"

let fixup ~(stringify: parameter -> string) ~(slug: string) ~(key: string) ~(value: parameter) = match (slug, key) with
  | ("hamming", "expected") -> optional_int (-1) value
  | _ -> stringify value
