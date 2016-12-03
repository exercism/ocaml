open Core.Std
open OUnit2
open Codegen
open Template

let printer = Option.value_map ~f:show ~default:"None"
let int_option_printer = Option.value_map ~f:Int.to_string ~default:"None"

let template_tests = [
  "if there is no test marker in a string then find_template returns None" >:: (fun _ctx ->
      assert_equal None @@ find_template ~template_text:"some code block"
    );

  "if there is a test marker in a string then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample_template.txt" in
      assert_equal ~printer (Some {start=7; finish=9;
                                   file_text=template_text; template="code";
                                   suite_description_line= None;
                                   suite_all_descriptions_line = None}) @@ find_template ~template_text
    );

  "if there is a suite description line then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample-suite-template.txt" in
      let template = find_template ~template_text in
      match template with
      | None -> assert_failure "Could not find a template at all"
      | Some template -> assert_equal ~printer:int_option_printer (Some 6) template.suite_description_line
    );

  "if there is a suite all descriptions line then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample-suite-template.txt" in
      let template = find_template ~template_text in
      match template with
      | None -> assert_failure "Could not find a template at all"
      | Some template -> assert_equal ~printer:int_option_printer (Some 14) template.suite_all_descriptions_line
    );

  "fills in lines of a template" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample_template.txt" in
      let template = {start=7; finish=9; file_text=template_text;template="code";
                      suite_description_line= None; suite_all_descriptions_line = None} in
      let filled = fill template [Subst "line1"; Subst "line2"] in
      let pattern = "  (* TEST\ncode\n     END TEST *)" in
      let expected = (String.substr_replace_all ~pattern ~with_:"line1\nline2" template_text) in
      assert_equal ~printer:Fn.id expected (filled ^ "\n")
    );
]
