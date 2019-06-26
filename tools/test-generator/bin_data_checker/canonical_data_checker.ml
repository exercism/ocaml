open Base
open Generator

let data_folder_value = ref None

let spec = Getopts.spec 
  "[-c string]"
  "Reports errors in canonical data."
  [
    Getopts.string 'c' (fun c _ -> data_folder_value := Some c) "Directory containing canonical data."
  ] 
  (fun _ _ -> ())
  []

let () =
  Getopts.parse_argv spec ();
  !data_folder_value 
  |> Option.value ~default:"../../../../problem-specifications/exercises"
  |> Controller.check_canonical_data;
