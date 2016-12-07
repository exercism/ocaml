open Core.Std
open OUnit2
open Codegen
open Model

let ae exp got _ctxt = assert_equal ~printer:Fn.id exp got

let model_tests = [
  "int parameter to string" >::
    ae "8" @@ parameter_to_string (Int 8);
  "bool parameter to string" >::
    ae "true" @@ parameter_to_string (Bool true);
  "string parameter to string" >::
    ae "xyz" @@ parameter_to_string (String "xyz");
  "string parameter containing escaped characters to string" >::
    ae "x\\t\\ny" @@ parameter_to_string (String "x\t\ny");
  "float parameter to string" >::
    ae "3.14" @@ parameter_to_string (Float 3.14);
  "string list parameter to string" >::
    ae "[\"a\"; \"bc\"; \"def\"]"  @@ parameter_to_string (StringList ["a"; "bc"; "def"]);
  "string list parameter with escaped characters to string" >::
    ae "[\"a\\r\"; \"b\\nc\"; \"d\\tef\"]"  @@ parameter_to_string (StringList ["a\r"; "b\nc"; "d\tef"]);
  "int list parameter to string" >::
    ae "[1; 2; 3; 4]"  @@ parameter_to_string (IntList [1; 2; 3; 4]);
  "int string map parameter to string" >::
    ae "[(\"one\", 1); (\"two\", 1)]"  @@ parameter_to_string (IntStringMap [("one", 1); ("two", 1)]);
  "int string map parameter to string with escaped characters in the keys" >::
    ae "[(\"\\t\\r\", 1); (\"two\\n\", 1)]"  @@ parameter_to_string (IntStringMap [("\t\r", 1); ("two\n", 1)]);
]
