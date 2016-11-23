open Core.Std

open Model

let fixup ~(slug: string) ~(key: string) ~(value: parameter) = match slug with
  | "hamming" -> if key = "expected" then match value with
      | Int (-1) -> "None"
      | Int n -> "(Some " ^ Int.to_string n ^ ")"
      | _ -> failwith "can't handle non-int parameter" else parameter_to_string value
  | _ -> parameter_to_string value
