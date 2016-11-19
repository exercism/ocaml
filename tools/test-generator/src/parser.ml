open Core.Std
open Utils
open Yojson.Safe
open Yojson.Safe.Util
open Model

type error =
  TopLevelMustHaveKeyCalledCases | ExpectingListOfCases | ExpectingMapForCase
  [@@deriving eq]

let to_expected (s: json) = match s with
  | `String x -> Some (String x)
  | `Float x -> Some (Float x)
  | `Bool x -> Some (Bool x)
  | _ -> None

let parse_int_fields (assoc: (string * json) list): int elements =
  List.filter_map assoc ~f:(fun (k, v) -> Option.map ~f:(fun v -> (k, v)) (safe_to_int_option v))

let parse_case_assoc (assoc: (string * json) list): case option =
  let find = List.Assoc.find assoc in
  let open Option.Monad_infix in
  find "description" >>=
  to_string_option >>= fun description ->
  find "expected" >>= fun expectedJson ->
  to_expected expectedJson >>= fun expected ->
  Some {name = description; int_assoc = parse_int_fields assoc; expected = expected}

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
