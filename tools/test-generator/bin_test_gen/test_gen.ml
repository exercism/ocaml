open Base
open Generator
open Yojson.Basic

let home_dir = Unix.getenv "HOME"

let template_value = ref None
let data_folder_value = ref None
let output_folder_value = ref None
let generated_folder_value = ref None
let filter_value = ref None

let spec = Getopts.spec 
  "[-l string]"
  "Generates test code from canonical data."
  [
    Getopts.string 't' (fun t _ -> template_value := Some t) "directory containing templates";
    Getopts.string 'c' (fun c _ -> data_folder_value := Some c) "directory containing templates";
    Getopts.string 'o' (fun c _ -> output_folder_value := Some c) "directory to output generated tests";
    Getopts.string 'o' (fun c _ -> generated_folder_value := Some c) "directory to backup generated tests";
    Getopts.string 'f' (fun c _ -> filter_value := Some c) "filter out files not matching this string";
  ] 
  (fun _ _ -> ())
  []

type language_config = {
  template_file_name: string;
  default_base_folder: string;
  test_start_marker: string;
  test_end_marker: string;
  edit_parameters: slug: string -> (string * json) list -> (string * string) list option;
}

let language_config = {
  template_file_name = "test.ml"; 
  default_base_folder = "../..";
  test_start_marker = "(* TEST"; 
  test_end_marker = "END TEST";
  edit_parameters = ocaml_edit_parameters
}

let () =
  Getopts.parse_argv spec ();
  let templates_folder = (!template_value |> Option.value ~default:"../templates") ^ "/" in
  let canonical_data_folder = !data_folder_value |> Option.value ~default:"../../../../problem-specifications/exercises" in
  let output_folder = !output_folder_value |> Option.value ~default:(language_config.default_base_folder ^ "/../exercises") in
  let generated_folder = !generated_folder_value |> Option.value ~default:(home_dir ^ "/.exercism-ocaml-generated") in
  let filter = !filter_value in
  Controller.run 
    ~language_config 
    ~templates_folder
    ~canonical_data_folder 
    ~output_folder 
    ~generated_folder 
    filter;
