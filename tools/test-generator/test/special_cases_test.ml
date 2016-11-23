open Core.Std
open OUnit2
open Model
open Codegen
open Special_cases

let ae exp got _ctxt = assert_equal ~printer:Fn.id exp got

let special_cases_tests = [
  "for a non special cased slug convert the parameter to a string" >:: (fun _ctx ->
      let stringify (Bool true) = "stringified" in
      assert_equal ~printer:Fn.id "stringified" (fixup ~stringify ~slug:"some-slug" ~key:"key" ~value:(Bool true))
    );

  "an optional int parameter is converted to none if it matches the special value" >:: (fun _ctx ->
      assert_equal "None" (optional_int ~none:88 (Int 88))
    );

  "an optional int parameter is converted to (Some value) if it does not match the special value" >:: (fun _ctx ->
    assert_equal "(Some 0)" (optional_int ~none:88 (Int 0))
  )
]
