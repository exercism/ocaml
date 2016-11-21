open Core.Std
open OUnit2
open Codegen
open Model

let model_tests = [
  "int parameter to string" >::(fun ctxt ->
      assert_equal "8" @@ parameter_to_string (Int 8)
    );

  "bool parameter to string" >::(fun ctxt ->
      assert_equal "true" @@ parameter_to_string (Bool true)
    );

  "string parameter to string" >::(fun ctxt ->
      assert_equal "xyz" @@ parameter_to_string (String "xyz")
    );

  "float parameter to string" >::(fun ctxt ->
      assert_equal "3.14" @@ parameter_to_string (Float 3.14)
    );

  "string list parameter to string" >::(fun ctxt ->
      assert_equal "[\"a\"; \"bc\"; \"def\"]" ~printer:Fn.id @@ parameter_to_string (StringList ["a"; "bc"; "def"])
    );
]
