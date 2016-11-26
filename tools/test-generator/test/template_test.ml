open Core.Std
open OUnit2
open Codegen
open Template

let printer = Option.value_map ~f:show ~default:"None"

let template_tests = [
  "if there is no generated code marker in a string then find_template returns None" >:: (fun _ctx ->
      assert_equal None @@ find_template ~template_text:"some code block"
    );

  "if there is generated code marker in a string then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample_template.txt" in
      assert_equal ~printer (Some {start=7; finish=9; file_text=template_text; template="code"}) @@ find_template ~template_text
    );

  "fills in lines of a template" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample_template.txt" in
      let template = {start=7; finish=9; file_text=template_text;template="code"} in
      let filled = fill template [Subst "line1"; Subst "line2"] in
      let pattern = "  (* GENERATED-CODE\ncode\n     END GENERATED-CODE *)" in
      let expected = (String.substr_replace_all ~pattern ~with_:"line1\nline2" template_text) in
      assert_equal ~printer:Fn.id expected (filled ^ "\n")
    );
]
