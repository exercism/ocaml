open Core.Std
open Utils
open Yojson.Basic
open Yojson.Basic.Util
open Model

type error =
    TestMustHaveKeyCalledCases of string | ExpectingListOfCases | ExpectingMapForCase |
    NoDescription | BadDescription | NoExpected of string | BadExpected | UnrecognizedJson [@@deriving eq, show]

let to_int_safe = function
| `Int x -> Some x
| _ -> None

let to_tuple_safe xs = match xs with
| `List [`Int x; `Int y] -> Some (x,y)
| _ -> None

let rec to_list_safe xs: parameter option = let open Option.Monad_infix in match xs with
| [] -> Some (StringList [])
| `String x :: _ -> Some (StringList (List.map xs ~f:to_string))
| `Int x :: _ -> List.map xs ~f:to_int_safe |> sequence_option >>= (fun xs -> Some (IntList xs))
| `List x :: _ -> List.map xs ~f:to_tuple_safe |> sequence_option >>= (fun xs -> Some (IntTupleList xs))
| _ -> None

let q xs = let open Option.Monad_infix in
  List.map xs ~f:(fun (k,v) -> (to_int_safe v |> Option.map ~f:(fun v -> (k,v))))

let to_parameter (s: json) = match s with
| `Null -> Some (Null)
| `String x -> Some (String x)
| `Float x -> Some (Float x)
| `Int x -> Some (Int x)
| `Bool x -> Some (Bool x)
| `List x -> to_list_safe x
| `Assoc xs -> let open Option.Monad_infix in
    let xs = List.map xs ~f:(fun (k,v) -> (to_int_safe v |> Option.map ~f:(fun v -> (k,v)))) in
    sequence_option xs >>= fun xs -> Some (IntStringMap xs)

let parse_parameters (parameters: (string * json) list): parameter elements =
  List.filter_map parameters ~f:(fun (k, v) -> Option.map ~f:(fun v -> (k, v)) (to_parameter v))

let parse_case_assoc (parameters: (string * json) list) (expected_key: string): (case, error) Result.t =
  let find name e = List.Assoc.find parameters name |> Result.of_option ~error:e in
  let test_parameters = List.Assoc.remove parameters "description" in
  let test_parameters = List.Assoc.remove test_parameters expected_key in
  let open Result.Monad_infix in
  find "description" NoDescription >>=
  to_string_note BadDescription >>= fun description ->
  find expected_key (NoExpected description) >>= fun expectedJson ->
  to_parameter expectedJson |> Result.of_option ~error:BadExpected >>= fun expected ->
  Ok {description = description; parameters = parse_parameters test_parameters; expected = expected}

let parse_case (expected_key: string) (s: json): (case, error) Result.t = match s with
  | `Assoc assoc -> parse_case_assoc assoc expected_key
  | _ -> Error ExpectingMapForCase

let parse_cases (text: string) (cases_key: string): (json, error) Result.t =
  match from_string text |> member cases_key with
    | `Null -> Error (TestMustHaveKeyCalledCases "xx")
    | json -> Ok json

let parse_single (text: string) (expected_key: string) (cases_key: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  parse_cases text cases_key >>=
  to_list_note ExpectingListOfCases >>=
  (sequence >> (List.map ~f:(parse_case expected_key))) >>= fun ts ->
  Result.return (Single ts)

let is_suite (json: json) (cases_key: string) =
  let keys = List.filter (keys json) ~f:(fun k -> k <> "methods") in
  let keys = List.sort keys ~cmp:String.compare in
  not (List.is_empty keys || keys = [cases_key] || keys = ["#"; cases_key])

let merge_result = function
  | (_, Error x) -> Error x
  | (n, Ok c) -> Ok {name = n; cases = c}

let parse_cases_from_suite name suite expected_key cases_key =
  let open Result.Monad_infix in
  member_note (TestMustHaveKeyCalledCases name) cases_key suite >>=
  to_list_note ExpectingListOfCases >>= fun tests ->
  List.map tests ~f:(parse_case expected_key) |> sequence

let parse_json_text (text: string) (expected_key: string) (cases_key: string): (tests, error) Result.t =
  let open Result.Monad_infix in
  let json = from_string text in
  if is_suite json cases_key
  then
    to_assoc_note UnrecognizedJson json >>= fun tests ->
    let tests = List.filter tests ~f:(fun (n, _) -> n <> "#") in
    let tests = List.map tests ~f:(fun (name, suite) -> merge_result (name, parse_cases_from_suite name suite expected_key cases_key)) in
    sequence tests >>= fun tests ->
    Ok (Suite tests)
  else
    parse_single text expected_key cases_key

let show_error = function
  | TestMustHaveKeyCalledCases name -> "Test named '" ^ name ^ "' is expected to have an object with a key: 'cases'"
  | ExpectingMapForCase -> "Expected a json map for a test case"
  | ExpectingListOfCases -> "Expected a top level map with key cases, and a list of cases as its value."
  | NoDescription -> "Case is missing a description."
  | BadDescription -> "Description is not a string."
  | NoExpected s -> "Case '" ^ s ^ "' is missing an expected key."
  | BadExpected -> "Do not understand type of Expected key."
  | UnrecognizedJson -> "Cannot understand this json."
