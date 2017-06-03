open Core

open Yojson.Basic
open Ocaml_special_cases
open Purescript_special_cases

let edit_expected ~(language: string) ~(stringify: json -> string) ~(slug: string) ~(value: json) = match language with
| "ocaml" -> Ocaml_special_cases.ocaml_edit_expected ~stringify ~slug ~value
| "purescript" -> Purescript_special_cases.edit_expected ~stringify ~slug ~value
| _ -> failwith "unknown language"

include Ocaml_special_cases 