open! Core
open! Generator

(*
let home_dir = match Sys.getenv "HOME" with
  | Some x -> x
  | None -> failwith "Environment variable \"HOME\" not set"

(* This is not implemented at all *)
let () =
  Controller.run
    ~templates_folder:"../templates/ocaml"
    ~canonical_data_folder:"../../../../problem-specifications/exercises"
    ~generated_folder:(home_dir ^ "/.ocaml-generated")
    ~language_config:(Languages.default_language_config "ocaml")
    "../../exercises"
    (Some "beer-song")
*)
