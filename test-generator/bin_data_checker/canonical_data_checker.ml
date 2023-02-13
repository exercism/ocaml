open Core
open Generator

let command =
  Command.basic ~summary:"Reports errors in canonical data."
    [%map_open.Command
      let data_folder_value =
        flag "c" (optional string) ~doc:"Directory containing canonical data."
      in
      fun () ->
        data_folder_value
        |> Option.value ~default:"../../../../problem-specifications/exercises"
        |> Controller.check_canonical_data]

let () = Command_unix.run command
