open Core
open Generator

let command =
  Command.basic ~summary:"Generates test code from canonical data."
    [%map_open.Command
      let cwd =
        flag_optional_with_default_doc "w" string Sexp.of_string
          ~default:(Caml.Sys.getcwd ()) ~doc:"directory to assume as cwd"
      and templates_folder =
        flag_optional_with_default_doc "t" string Sexp.of_string
          ~default:"./templates" ~doc:"directory containing templates"
      and canonical_data_folder =
        flag_optional_with_default_doc "c" string Sexp.of_string
          ~default:"./problem-specifications/exercises"
          ~doc:"directory containing data"
      and output_folder =
        flag_optional_with_default_doc "o" string Sexp.of_string
          ~default:"./exercises/practice"
          ~doc:"directory to output generated tests"
      and _ =
        flag "f" (optional string)
          ~doc:"filter out files not matching this string"
      in
      fun () ->
        Sys_unix.chdir cwd;
        ignore
          (Controller.run ~templates_folder ~canonical_data_folder
             ~output_folder
          |> Result.ok_exn)]

let () = Command_unix.run command
