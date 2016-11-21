open Core.Std
open OUnit2
open Codegen
open Test_generator

let test_generator_tests = [
  "finds a template" >::(fun ctxt ->
      let template_text = "open Core.Std\nopen OUnit2\nopen Leap\n\nlet ae exp got _test_ctxt = assert_equal exp got\n\nlet tests = [\n(* GENERATED-CODE\n  \"$name\" >::\n    ae $expected (leap_year $input)\nEND GENERATED-CODE *)\n]\n\nlet () =\n  run_test_tt_main (\"leap tests\" >::: tests)\n" in
      assert_equal (Some (7, 10, "  \"$name\" >::\n    ae $expected (leap_year $input)")) (find_template ~template_text)
    );
]
