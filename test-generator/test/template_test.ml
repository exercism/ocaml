open Base
open Stdio
open OUnit2
open Generator.Template

let printer = Option.value_map ~f:show ~default:"None"
let int_option_printer = Option.value_map ~f:Int.to_string ~default:"None"
let find_template = find_template "(* TEST" "END TEST"


let template_tests = [
  "if there is no test marker in a string then find_template returns None" >:: (fun _ctx ->
      assert_equal None @@ find_template ~template_text:"some code block"
    );

  "if there is a test marker in a string then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "fixtures/sample_template.txt" in
      let expected_single = Single {
        start = 7;
        finish = 9;
        template = "code";
      } in
      assert_equal ~printer (Some {file_text = template_text; template = expected_single}) @@ find_template ~template_text
    );

  (*"if there is a suite description line then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample-suite-template.txt" in
      let template = find_template ~template_text in
      match template with
      | None -> assert_failure "Could not find a template at all"
      | Some template -> assert_equal ~printer:int_option_printer (Some 6) template.suite_name_line
    );

  "if there is a suite all descriptions line then find_template returns where it is" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample-suite-template.txt" in
      let template = find_template ~template_text in
      match template with
      | None -> assert_failure "Could not find a template at all"
      | Some template -> assert_equal ~printer:int_option_printer (Some 15) template.suite_all_names_line
    );

  "fills in lines of a template" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample_template.txt" in
      let template = {start=7; finish=9; file_text=template_text;template="code";
                      suite_name_line= None; suite_end = None; suite_all_names_line = None} in
      let filled = fill_tests template [Subst "line1"; Subst "line2"] in
      let pattern = "  (* TEST\ncode\n     END TEST *)" in
      let expected = (String.substr_replace_all ~pattern ~with_:"line1\nline2" template_text) in
      assert_equal ~printer:Fn.id expected (filled ^ "\n")
    );

  "fills in a single suite in a suite template" >:: (fun _ctx ->
      let template_text = In_channel.read_all "test/sample-suite-template.txt" in
      let template = {start=7; finish=9; file_text=template_text;template="code";
                      suite_name_line=Some 6; suite_end = Some 14; suite_all_names_line = None} in
      let subst = ("tests1", [Subst "line1"; Subst "line2"]) in
      let filled = Result.ok_or_failwith @@ fill_single_suite template subst in
      assert_equal ~printer:Bool.to_string true (String.substr_index filled ~pattern:"let tests1_tests = [" |> Option.is_some);
      assert_equal ~printer:Bool.to_string true (String.substr_index filled ~pattern:"line1" |> Option.is_some);
      assert_equal ~printer:Bool.to_string true (String.substr_index filled ~pattern:"line2" |> Option.is_some);
      assert_equal ~printer:Int.to_string 7 (String.count ~f:(fun ch -> ch = '\n') filled);
    );*)
]
