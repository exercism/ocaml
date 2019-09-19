open Base
open OUnit2
open Generator.Special_cases

let ae exp got _ctxt = assert_equal ~printer:Fn.id exp got

let tuples_printer kvs =
  String.concat ~sep:";" @@ List.map ~f:(fun (k,v) -> "(" ^ k ^ "," ^ v ^ ")") kvs

let stringify = function
  | `Bool true -> "stringified"
  | _ -> failwith "Bad type for stringify"

let special_cases_test = [
  "an optional int parameter is converted to none if it matches the special value" >:: (fun _ctx ->
      assert_equal "None" @@ optional_int ~none:88 (`Int 88)
    );

  "an optional int parameter is converted to (Some value) if it does not match the special value" >:: (fun _ctx ->
      assert_equal "(Some 0)" @@ optional_int ~none:88 (`Int 0)
    );

  "default_value does not provide a default for a list that has the given key already" >:: (fun _ctx ->
      let ps = [("key", "value")] in
      assert_equal ps @@ default_value ~key:"key" ~value:"value2" ps
    );

  "default_value does provides a default for a list that does not have the given key" >:: (fun _ctx ->
      assert_equal [("key", "value")] @@ default_value ~key:"key" ~value:"value" []
    );

  "optional_strings replace value with Some(value)" >:: (fun _ctx ->
      assert_equal ~printer:tuples_printer [("key", "(Some \"value\")"); ("key2", "\"value2\"")]
        @@ optional_strings ~f:(fun x -> String.(x = "key")) [("key", `String "value"); ("key2", `String "value2")]
    );

  "option_of_null converts Null to None" >:: (fun _ctx ->
      assert_equal "None" @@ option_of_null `Null
    );
  
  "option_of_null converts String to Some" >:: (fun _ctx ->
      assert_equal "(Some \"abc\")" @@ option_of_null (`String "abc")
    );

  "option_of_null converts List to Some" >:: (fun _ctx ->
      assert_equal "(Some [1; 2; 3])" @@ option_of_null (`List [`Int 1;`Int 2;`Int 3])
    );
]
