open Core.Std
open Utils
open Yojson.Safe
open Yojson.Safe.Util
open Model

type error =
    TestMustHaveKeyCalledCases of string | ExpectingListOfCases | ExpectingMapForCase |
    BadDescription | BadExpected | UnrecognizedJson [@@deriving eq, show]

let to_int_safe = function
  | `Int x -> Some x
  | _ -> None

let to_list_safe xs = let open Option.Monad_infix in match xs with
  | [] -> Some (StringList [])
  | `String x :: _ -> Some (StringList (List.map xs ~f:to_string))
  | `Int x :: _ -> List.map xs ~f:to_int_safe |> sequence_option >>= (fun xs -> Some (IntList xs))
  | _ -> None

let q xs = let open Option.Monad_infix in
  List.map xs ~f:(fun (k,v) -> (to_int_safe v |> Option.map ~f:(fun v -> (k,v))))

let to_parameter (s: json) = match s with
  | `Null -> Some (Null)
  | `String x -> Some (String x)
  | `Float x -> Some (Float x)
  | `Int x -> Some (Int x)
  | `Bool x -> Some (Bool x)
  | `List x -> to_list_safe  x
  | `Assoc xs -> let open Option.Monad_infix in
      let xs = List.map xs ~f:(fun (k,v) -> (to_int_safe v |> Option.map ~f:(fun v -> (k,v)))) in
      sequence_option xs >>= fun xs -> Some (IntStringMap xs)
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
    | `Null -> Error (TestMustHaveKeyCalledCases "xx")
    | json -> Ok json

let parse_single (text: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  parse_cases text >>=
  to_list_note ExpectingListOfCases >>=
  (sequence >> (List.map ~f:parse_case)) >>= fun ts ->
  Result.return (Single ts)

let is_suite (json: json) =
  let keys = List.sort (keys json) ~cmp:String.compare in
  not (List.is_empty keys || keys = ["cases"] || keys = ["#"; "cases"])

let merge_result = function
  | (_, Error x) -> Error x
  | (n, Ok c) -> Ok {name = n; cases = c}

let parse_cases_from_suite name suite =
  let open Result.Monad_infix in
  member_note (TestMustHaveKeyCalledCases name) "cases" suite >>=
  to_list_note ExpectingListOfCases >>= fun tests ->
  List.map tests ~f:parse_case |> sequence

let parse_json_text (text: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  let json = from_string text in
  if is_suite json
  then
    to_assoc_note UnrecognizedJson json >>= fun tests ->
    let tests = List.filter tests ~f:(fun (n, _) -> n <> "#") in
    let tests = List.map tests ~f:(fun (name, suite) -> merge_result (name, parse_cases_from_suite name suite)) in
    sequence tests >>= fun tests ->
    Ok (Suite tests)
  else
    parse_single text

let show_error = function
  | TestMustHaveKeyCalledCases name -> "Test named '" ^ name ^ "' is expected to have an object with a key: 'cases'"
  | ExpectingMapForCase -> "Expected a json map for a test case"
  | ExpectingListOfCases -> "Expected a top level map with key cases, " ^
      "and a list of cases as its value."
  | BadDescription -> "Case is missing a description or it is not a string."
  | BadExpected -> "Case is missing an expected key or it is not an understood type."
  | UnrecognizedJson -> "Cannot understand this json."
