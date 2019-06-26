open Core
open Generator

let home_dir = Option.value_exn (Sys.getenv "HOME")

let () =
  Controller.run
    ~templates_folder:"./templates"
    ~canonical_data_folder:"../../../x-common/exercises"
    ~output_folder:"../../exercises"
    ~generated_folder:(home_dir ^ "/.xocaml-generated")
    (Some "beer-song")
