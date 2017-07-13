open Core
open Languages

let is_directory =
  Command.Spec.Arg_type.create
    (fun n ->
       match Sys.is_directory n with
       | `Yes -> n
       | `No | `Unknown ->
         eprintf "'%s' is not a regular folder.\n%!" n;
         exit 1
    )

let home_dir = Option.value_exn (Sys.getenv "HOME")

let default_generated name = Option.value ~default:(home_dir ^ "/.x" ^ name ^ "-generated")

let command =
  Command.basic
    ~summary:"Generates test code from canonical data."
    Command.Spec.(
      empty
      +> flag "-l" (optional string) ~doc:"language to generate tests for"
      +> flag "-t" (optional_with_default "./templates" is_directory) ~doc:"string Directory containing templates."
      +> flag "-c" (optional_with_default "../../../problem-specifications/exercises" is_directory) ~doc:"string Directory containing canonical data."
      +> flag "-o" (optional string) ~doc:"string Directory to output generated tests."
      +> flag "-g" (optional string) ~doc:"string Directory to backup generated tests."
      +> flag "-f" (optional string) ~doc:"string Filter out files not matching this string."
    )
    (fun language templates_folder canonical_data_folder output_folder generated_folder filter () -> 
      let language = Option.value language ~default:"ocaml" in
      let lc = default_language_config language in
      let generated_folder = default_generated language generated_folder in
      let templates_folder = templates_folder ^ "/" ^ language in
      let output_folder = Option.value output_folder ~default:(lc.default_base_folder ^ "/exercises") in
      Controller.run lc templates_folder canonical_data_folder output_folder generated_folder filter)

let () =
  Command.run ~version:"0.1" command
