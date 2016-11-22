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

let command =
  Command.basic
    ~summary:"Generates test code from canonical data."
    Command.Spec.(
      empty
      +> flag "-t" (optional_with_default "./templates" is_directory) ~doc:"string Directory containing templates."
      +> flag "-c" (optional_with_default "../../../x-common/exercises" is_directory) ~doc:"string Directory containing canonical data."
      +> flag "-o" (optional_with_default "../../exercises" is_directory) ~doc:"string Directory to output generated tests."
    )
    (fun templates_folder canonical_data_folder output_folder () -> Test_generator.run templates_folder canonical_data_folder output_folder)

let () =
  Command.run ~version:"0.1" command
