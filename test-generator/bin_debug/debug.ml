open Base
open Generator

let home_dir = Unix.getenv "HOME"

let () =
  Controller.run
    ~templates_folder:"../templates/ocaml"
    ~canonical_data_folder:"../../../../problem-specifications/exercises"
    ~output_folder:"../../exercises"
    ~generated_folder:(home_dir ^ "/.ocaml-generated")
    ~language_config:(Languages.default_language_config "ocaml")
    (Some "beer-song")
