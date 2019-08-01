open Core
open Generator

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
    ~summary:"Reports errors in canonical data."
    Command.Spec.(
      empty
      +> flag "-c" (optional_with_default "../../../x-common/exercises" is_directory) ~doc:"string Directory containing canonical data."
    )
    (fun canonical_data_folder () -> Controller.check_canonical_data canonical_data_folder)

let () =
  Command.run ~version:"0.1" command
