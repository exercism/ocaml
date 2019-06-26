open Base
open Generator

let home_dir = Unix.getenv "HOME"

let language_value = ref None
let template_value = ref None
let data_folder_value = ref None
let output_folder_value = ref None
let generated_folder_value = ref None
let filter_value = ref None

let spec = Getopts.spec 
  "[-l string]"
  "Generates test code from canonical data."
  [
    Getopts.string 'l' (fun l _ -> language_value := Some l) "language to generate tests for";
    Getopts.string 't' (fun t _ -> template_value := Some t) "directory containing templates";
    Getopts.string 'c' (fun c _ -> data_folder_value := Some c) "directory containing templates";
    Getopts.string 'o' (fun c _ -> output_folder_value := Some c) "directory to output generated tests";
    Getopts.string 'o' (fun c _ -> generated_folder_value := Some c) "directory to backup generated tests";
    Getopts.string 'f' (fun c _ -> filter_value := Some c) "filter out files not matching this string";
  ] 
  (fun _ _ -> ())
  []

let () =
  Getopts.parse_argv spec ();
  let language = !language_value |> Option.value ~default:"ocaml" in
  let language_config = Languages.default_language_config language in
  let templates_folder = !template_value |> Option.value ~default:"../templates" in
  let templates_folder = templates_folder ^ "/" ^ language in
  let canonical_data_folder = !data_folder_value |> Option.value ~default:"../../../../problem-specifications/exercises" in
  let output_folder = !output_folder_value |> Option.value ~default:(language_config.default_base_folder ^ "/../exercises") in
  let generated_folder = !generated_folder_value |> Option.value ~default:(home_dir ^ "/.exercism-" ^ language ^ "-generated") in
  let filter = !filter_value in
  Controller.run 
    ~language_config 
    ~templates_folder
    ~canonical_data_folder 
    ~output_folder 
    ~generated_folder 
    filter;
