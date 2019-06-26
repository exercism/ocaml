open Core
open OUnit2
open Generator.Codegen
open Generator.Model
open Yojson.Basic

let leap_template = "\"$description\" >:: ae $expected (leap_year $input);"

let edit_parameters (j: (string * json) list): (string * string) list = 
    List.map ~f:(fun (k,v) -> (k,to_string v)) j
let assert_fill_in_template exp cases = assert_equal exp
    ~printer:(fun xs -> "[" ^ (String.concat ~sep:";" xs) ^ "]")
    (fill_in_template edit_parameters leap_template "suite-name" cases |> List.map ~f:subst_to_string)
let ae exp cases _test_ctxt = assert_fill_in_template exp cases

let codegen_tests = [
  "if there are no cases then generate an empty string" >::
  ae [] [];

  "generates one function based on leap year for one case" >::(fun _ctx ->
      let c = {description = "leap_year"; property = "p1"; parameters = [("input", `Int 1996); ("expected", `Bool true)];} in
      assert_fill_in_template ["\"leap_year\" >:: ae true (leap_year 1996);"] [c]
    );
]
