open Core.Std
open Model

type error = TopLevelMustHaveKeyCalledCases | ExpectingListOfCases |
             ExpectingMapForCase | BadDescription | BadExpected

val parse_json_text : string -> (case list, error) Result.t

val show_error : error -> string
