open Core.Std
open OUnit2
open Codegen
open Model

let leap_template = "\"$description\" >:: ae $expected (leap_year $input);"

let edit_expected ~value = parameter_to_string value
let edit_parameters = Fn.id
let assert_fill_in_template exp cases = assert_equal exp
    ~printer:(fun xs -> "[" ^ (String.concat ~sep:";" xs) ^ "]")
    (fill_in_template edit_expected edit_parameters leap_template "suite-name" cases |> List.map ~f:subst_to_string)
let ae exp cases _test_ctxt = assert_fill_in_template exp cases

let codegen_tests = [
  "if there are no cases then generate an empty string" >::
  ae [] [];

  "generates one function based on leap year for one case" >::(fun ctxt ->
      let c = {description = "leap_year"; parameters = [("input", Int 1996)]; expected = Bool true} in
      assert_fill_in_template ["\"leap_year\" >:: ae true (leap_year 1996);"] [c]
    );
]
