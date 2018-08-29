open Core
open Yojson.Basic
include Ocaml_special_cases 
include Purescript_special_cases 

type language_config = {
  template_file_name: string;
  default_base_folder: string;
  test_start_marker: string;
  test_end_marker: string;
  edit_parameters: slug: string -> (string * json) list -> (string * string) list;
}

let default_language_config = function
| "ocaml" -> {
    template_file_name = "test.ml"; 
    default_base_folder = "../..";
    test_start_marker = "(* TEST"; 
    test_end_marker = "END TEST";
    edit_parameters = ocaml_edit_parameters
    }
| "purescript" ->  {
    template_file_name = "Main.purs"; 
    default_base_folder = "../../../xpurescript";
    test_start_marker = "--TEST"; 
    test_end_marker = "--END TEST";
    edit_parameters = purescript_edit_parameters
    }
| x -> failwith @@ "unknown language " ^ x

