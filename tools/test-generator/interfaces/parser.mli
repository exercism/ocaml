open Core.Std
open Model

type error = TopLevelMustHaveKeyCalledCases | ExpectingListOfCases |
             ExpectingMapForCase | BadDescription | BadExpected

type test = {name: string; cases: case list} [@@deriving eq, show]

type tests =
  | Single of case list
  | Suite of test list [@@deriving eq, show]

val parse_json_text : string -> (tests, error) Result.t

val show_error : error -> string
