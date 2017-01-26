open Core.Std

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

let command =
  Command.basic
    ~summary:"Generates test code from canonical data."
    Command.Spec.(
      empty
      +> flag "-t" (optional_with_default "./templates" is_directory) ~doc:"string Directory containing templates."
      +> flag "-c" (optional_with_default "../../../x-common/exercises" is_directory) ~doc:"string Directory containing canonical data."
      +> flag "-o" (optional_with_default "../../exercises" is_directory) ~doc:"string Directory to output generated tests."
      +> flag "-g" (optional_with_default (home_dir ^ "/.xocaml-generated") is_directory) ~doc:"string Directory to backup generated tests."
    )
    (fun templates_folder canonical_data_folder output_folder generated_folder () -> Controller.run templates_folder canonical_data_folder output_folder generated_folder)

let () =
  Command.run ~version:"0.1" command
