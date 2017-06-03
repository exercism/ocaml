open Core

type language_config = {
  name: string;
  template_file_name: string;
  default_base_folder: string;
  test_start_marker: string;
  test_end_marker: string;
  version_printer: string -> string
}

let default_language_config = function
| "ocaml" -> {
    name = "ocaml";
    template_file_name = "template.ml"; 
    default_base_folder = "../..";
    test_start_marker = "(* TEST"; 
    test_end_marker = "END TEST";
    version_printer = fun v -> "(* Test/exercise version: \"" ^ v ^ "\" *)\n\n";
    }
| "purescript" ->  {
    name = "purescript";
    template_file_name = "Main.purs"; 
    default_base_folder = "../../../xpurescript";
    test_start_marker = "--TEST"; 
    test_end_marker = "--END TEST";
    version_printer = fun v -> "-- Test/exercise version: \"" ^ v ^ "\"\n\n";
    }
| x -> failwith @@ "unknown language " ^ x

