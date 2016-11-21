open Core.Std
open Utils
open Yojson.Safe
open Yojson.Safe.Util
open Model

type error =
  TopLevelMustHaveKeyCalledCases | ExpectingListOfCases | ExpectingMapForCase
  [@@deriving eq]

let to_parameter (s: json) = match s with
  | `String x -> Some (String x)
  | `Float x -> Some (Float x)
  | `Int x -> Some (Int x)
  | `Bool x -> Some (Bool x)
  | `List x -> Some (StringList (List.map x ~f:to_string))
  | _ -> None

let parse_parameters (parameters: (string * json) list): parameter elements =
  List.filter_map parameters ~f:(fun (k, v) -> Option.map ~f:(fun v -> (k, v)) (to_parameter v))

let parse_case_assoc (parameters: (string * json) list): case option =
  let find = List.Assoc.find parameters in
  let test_parameters = List.Assoc.remove parameters "description" in
  let test_parameters = List.Assoc.remove test_parameters "expected" in
  let open Option.Monad_infix in
  find "description" >>=
  to_string_option >>= fun description ->
  find "expected" >>= fun expectedJson ->
  to_parameter expectedJson >>= fun expected ->
  Some {name = description; parameters = parse_parameters test_parameters; expected = expected}

let parse_case (s: json): (case, error) Result.t = match s with
  | `Assoc assoc -> Result.of_option (parse_case_assoc assoc) ExpectingMapForCase
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
