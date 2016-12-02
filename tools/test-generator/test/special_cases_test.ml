open Core.Std
open OUnit2
open Model
open Codegen
open Special_cases

let ae exp got _ctxt = assert_equal ~printer:Fn.id exp got

let tuples_printer kvs =
  String.concat ~sep:";" @@ List.map ~f:(fun (k,v) -> "(" ^ k ^ "," ^ v ^ ")") kvs

let stringify = function
  | Bool true -> "stringified"
  | _ -> failwith "Bad type for stringify"

let special_cases_tests = [
  "for a non special cased slug convert the parameter to a string" >:: (fun _ctx ->
      assert_equal ~printer:Fn.id "stringified" @@ edit_expected ~stringify ~slug:"some-slug" ~value:(Bool true)
    );

  "an optional int parameter is converted to none if it matches the special value" >:: (fun _ctx ->
      assert_equal "None" @@ optional_int ~none:88 (Int 88)
    );

  "an optional int parameter is converted to (Some value) if it does not match the special value" >:: (fun _ctx ->
      assert_equal "(Some 0)" @@ optional_int ~none:88 (Int 0)
    );

  "default_value does not provide a default for a list that has the given key already" >:: (fun _ctx ->
      let ps = [("key", "value")] in
      assert_equal ps @@ default_value ~key:"key" ~value:"value2" ps
    );

  "default_value does provides a default for a list that does not have the given key" >:: (fun _ctx ->
      assert_equal [("key", "value")] @@ default_value ~key:"key" ~value:"value" []
    );

  "optional_strings replace value with Some(value)" >:: (fun _ctx ->
      assert_equal ~printer:tuples_printer [("key", "(Some \"value\")"); ("key2", "value2")]
        @@ optional_strings ~f:(fun x -> x = "key") [("key", "value"); ("key2", "value2")]
    );
]
