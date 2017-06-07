open Core
open Yojson.Basic
include Ocaml_special_cases 

type language_config = {
  template_file_name: string;
  default_base_folder: string;
  test_start_marker: string;
  test_end_marker: string;
  version_printer: string -> string;
  edit_expected: stringify: (json -> string) -> slug: string -> value: json -> string;
}

let default_language_config = function
| "ocaml" -> {
    template_file_name = "test.ml"; 
    default_base_folder = "../..";
    test_start_marker = "(* TEST"; 
    test_end_marker = "END TEST";
    version_printer = (fun v -> "(* Test/exercise version: \"" ^ v ^ "\" *)\n\n");
    edit_expected = ocaml_edit_expected;
    }
| "purescript" ->  {
    template_file_name = "Main.purs"; 
    default_base_folder = "../../../xpurescript";
    test_start_marker = "--TEST"; 
    test_end_marker = "--END TEST";
    version_printer = (fun v -> "-- Test/exercise version: \"" ^ v ^ "\"\n\n");
    edit_expected = Purescript_special_cases.edit_expected;
    }
| x -> failwith @@ "unknown language " ^ x

