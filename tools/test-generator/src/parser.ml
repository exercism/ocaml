open Core.Std
open Utils
open Yojson.Safe
open Yojson.Safe.Util
open Model

type error =
    TopLevelMustHaveKeyCalledCases | ExpectingListOfCases | ExpectingMapForCase |
    BadDescription | BadExpected
  [@@deriving eq]

let to_int_unsafe = function
  | `Int x -> x
  | _ -> failwith "need an int here"

let to_parameter (s: json) = match s with
  | `String x -> Some (String x)
  | `Float x -> Some (Float x)
  | `Int x -> Some (Int x)
  | `Bool x -> Some (Bool x)
  | `List x -> Some (StringList (List.map x ~f:to_string))
  | `Assoc x -> Some (IntStringMap (List.map x ~f:(fun (k,v) -> (k,to_int_unsafe v))))
  | _ -> None

let parse_parameters (parameters: (string * json) list): parameter elements =
  List.filter_map parameters ~f:(fun (k, v) -> Option.map ~f:(fun v -> (k, v)) (to_parameter v))

let parse_case_assoc (parameters: (string * json) list): (case, error) Result.t =
  let find name e = List.Assoc.find parameters name |> Result.of_option ~error:e in
  let test_parameters = List.Assoc.remove parameters "description" in
  let test_parameters = List.Assoc.remove test_parameters "expected" in
  let open Result.Monad_infix in
  find "description" BadDescription >>=
  to_string_note BadDescription >>= fun description ->
  find "expected" BadExpected >>= fun expectedJson ->
  to_parameter expectedJson |> Result.of_option ~error:BadExpected >>= fun expected ->
  Ok {description = description; parameters = parse_parameters test_parameters; expected = expected}

let parse_case (s: json): (case, error) Result.t = match s with
  | `Assoc assoc -> parse_case_assoc assoc
  | _ -> Error ExpectingMapForCase

let parse_cases (text: string): (json, error) Result.t =
  match from_string text |> member "cases" with
    | `Null -> Error TopLevelMustHaveKeyCalledCases
    | json -> Ok json

let parse_json_text (text: string): (case list, error) Result.t =
  let open Result.Monad_infix in
  parse_cases text >>=
  to_list_note ExpectingListOfCases >>=
  (sequence >> (List.map ~f:parse_case))

let show_error = function
  | TopLevelMustHaveKeyCalledCases -> "Cannot parse this json - " ^
      "expecting an object with a key: 'cases'"
  | ExpectingMapForCase -> "Expected a json map for a test case"
  | ExpectingListOfCases -> "Expected a top level map with key cases, " ^
      "and a list of cases as its value."
  | BadDescription -> "Case is missing a description or it is not a string."
  | BadExpected -> "Case is missing an expected key or it is not a string."
