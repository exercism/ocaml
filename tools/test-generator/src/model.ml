open Core.Std

open Utils
open Yojson.Basic

type case = {
  description: string;
  parameters: (string * json) list;
  expected: json;
}

type test = {name: string; cases: case list}

type tests =
  | Single of case list
  | Suite of test list

type canonical_data = {
  version: string option;
  tests: tests
}

let rec json_to_string (j: json): string = match j with
  | `Null -> "null"
  | `String s -> "\"" ^ (String.escaped s) ^ "\""
  | `Float f -> Float.to_string f
  | `Int n -> Int.to_string n
  | `Bool b -> Bool.to_string b
  | `List xs -> "[" ^ String.concat ~sep:"; " (List.map ~f:json_to_string xs) ^ "]"
  | `Assoc xs -> "[" ^ String.concat ~sep:"; "
                         (List.map xs ~f:(fun (k,v) -> "(\"" ^ String.escaped k ^ "\", " ^ json_to_string v ^ ")")) ^ "]"
