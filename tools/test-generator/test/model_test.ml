open Core
open OUnit2
open Codegen
open Model

let ae exp got _ctxt = assert_equal ~printer:Fn.id exp got

let model_tests = [
  "json_to_string on list of strings" >::
    ae "[\"a\"; \"b\"; \"c\"]" @@ json_to_string (`List [`String "a"; `String "b"; `String "c"]);
]
