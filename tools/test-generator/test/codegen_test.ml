open Core.Std
open OUnit2
open Codegen
open Model

let leap_template = "\"$name\" >:: ae $expected (leap_year $input);"

let fixup ~key ~value = parameter_to_string value
let assert_gen exp cases = assert_equal (Ok exp) ~printer:(fun (Ok xs) -> "[" ^ (String.concat ~sep:";" xs) ^ "]") (generate_code fixup leap_template cases)
let ae exp cases _test_ctxt = assert_gen exp cases

let codegen_tests = [
  "if there are no cases then generate an empty string" >::
    ae [] [];

  "generates one function based on leap year for one case" >::(fun ctxt ->
      let c = {name = "leap_year"; parameters = [("input", Int 1996)]; expected = Bool true} in
      assert_gen ["\"leap_year\" >:: ae true (leap_year 1996);"] [c]
    );
]
