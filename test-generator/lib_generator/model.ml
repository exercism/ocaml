open Base

type json = Yojson.Basic.t

type case = {
  description: string;
  parameters: (string * json) list;
  property: string;
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

let list_to_string = String.concat ~sep:"; " 

let json_assoc_to_string (xs: (string * json) list): string =
  List.map xs ~f:(fun (k, j) -> k ^ ": " ^ (json_to_string j))
  |> list_to_string

let case_to_string {description; parameters; property}: string =
  "{description: " ^ description ^ "; parameters: " ^ (json_assoc_to_string parameters) ^ "; property: " ^ (property) ^ "}"

let cases_to_string cases = list_to_string (List.map ~f:case_to_string cases)

let test_to_string {name; cases}: string =
  "{name: " ^ name ^ "; cases: " ^ (cases_to_string cases) ^ "}"

let tests_to_string tests: string =
  "[" ^ list_to_string (List.map tests ~f:test_to_string) ^ "]"
  
let tests_to_string = function
| Single case -> cases_to_string case
| Suite tests -> tests_to_string tests