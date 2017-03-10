open Core.Std
open Utils
open Yojson.Basic
open Yojson.Basic.Util
open Model

type error =
    TestMustHaveKeyCalledCases of string | ExpectingListOfCases | ExpectingMapForCase |
    NoDescription | BadDescription | NoExpected of string | BadExpected | UnrecognizedJson [@@deriving eq, show]

let parse_case_assoc (parameters: (string * json) list) (expected_key: string): (case, error) Result.t =
  let find name e = List.Assoc.find parameters name |> Result.of_option ~error:e in
  let test_parameters = List.Assoc.remove parameters "description" in
  let test_parameters = List.Assoc.remove test_parameters expected_key in
  let open Result.Monad_infix in
  find "description" NoDescription >>=
  to_string_note BadDescription >>= fun description ->
  find expected_key (NoExpected description) >>= fun expected ->
  Ok {description = description; parameters = test_parameters; expected = expected}

let parse_case (expected_key: string) (s: json): (case, error) Result.t = match s with
  | `Assoc assoc -> parse_case_assoc assoc expected_key
  | _ -> Error ExpectingMapForCase

let parse_cases (text: string) (cases_key: string): (json, error) Result.t =
  match from_string text |> member cases_key with
    | `Null -> Error (TestMustHaveKeyCalledCases cases_key)
    | json -> Ok json

let parse_single (text: string) (expected_key: string) (cases_key: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  parse_cases text cases_key >>=
  to_list_note ExpectingListOfCases >>=
  (sequence >> (List.map ~f:(parse_case expected_key))) >>= fun ts ->
  Result.return (Single ts)

let rec to_cases case: (case list, error) Result.t = 
  let open Result.Monad_infix in
  find_note case "description" NoDescription >>= to_string_note BadDescription >>= fun desc ->
  let cases = List.Assoc.find case "cases" in
  match cases with
  | Some cases -> to_list_note UnrecognizedJson cases >>= fun cases ->
      List.map cases ~f:(to_assoc_note UnrecognizedJson) |> sequence >>= fun x ->
      List.map x ~f:to_cases |> sequence |> Result.map ~f:List.concat
  | None -> 
      find_note case "expected" (NoExpected "expected") >>= fun expected ->
      Result.return [{description = desc; parameters = case; expected = expected}]

let convert_cases_description_to_name desc =
  String.lowercase desc |> String.substr_replace_all ~pattern:" " ~with_:"_"

let suite_case json: (test, error) Result.t = 
  let open Result.Monad_infix in
  to_assoc_note UnrecognizedJson json >>= fun case ->
  find_note case "description" NoDescription >>= to_string_note BadDescription >>= fun desc ->
  find_note case "cases" ExpectingListOfCases >>= to_list_note ExpectingListOfCases >>= fun case_assocs ->
  List.map ~f:(to_assoc_note ExpectingMapForCase) case_assocs |> sequence >>= fun cases -> 
  List.map cases ~f:to_cases |> sequence >>= fun cases ->
  Result.return {name = convert_cases_description_to_name desc; cases = List.concat cases}

let suite_cases (json: json) (cases_key: string): (test list, error) Result.t = 
  let open Result.Monad_infix in
  (member cases_key json |> to_list_note ExpectingListOfCases) >>= fun assoc_cases ->
  List.map ~f:suite_case assoc_cases |> sequence

let parse_cases_from_suite name suite expected_key cases_key =
  let open Result.Monad_infix in
  member_note (TestMustHaveKeyCalledCases name) cases_key suite >>=
  to_list_note ExpectingListOfCases >>= fun tests ->
  List.map tests ~f:(parse_case expected_key) |> sequence

let parse_json_text (text: string) (expected_key: string) (cases_key: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  let json = from_string text in
  match suite_cases json cases_key with
  | Ok suite_cases -> Ok (Suite suite_cases)
  | Error _ -> parse_single text expected_key cases_key

let show_error = function
  | TestMustHaveKeyCalledCases name -> "Test named '" ^ name ^ "' is expected to have an object with a key: 'cases'"
  | ExpectingMapForCase -> "Expected a json map for a test case"
  | ExpectingListOfCases -> "Expected a top level map with key cases, and a list of cases as its value."
  | NoDescription -> "Case is missing a description."
  | BadDescription -> "Description is not a string."
  | NoExpected s -> "Case '" ^ s ^ "' is missing an expected key."
  | BadExpected -> "Do not understand type of Expected key."
  | UnrecognizedJson -> "Cannot understand this json."
