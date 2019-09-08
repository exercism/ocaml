open Base
open Generator

let home_dir = Unix.getenv "HOME"

let cwd = ref (Caml.Sys.getcwd ())
let template_value = ref None
let data_folder_value = ref None
let output_folder_value = ref None
let filter_value = ref None

let normalize_path (d: string): string =
    d |> Fpath.of_string
      |> Result.map_error ~f:(function `Msg m -> m)
      |> Result.ok_or_failwith
      |> Fpath.normalize
      |> Fpath.to_string

let get_path r d = 
   let r' = Option.value !r ~default:d in
   if Char.(d.[0] = '/') then d
   else if Char.(r'.[0] = '/') then r'
   else !cwd ^ "/" ^ r' |> normalize_path

let spec = Getopts.spec 
  "[-l string]"
  "Generates test code from canonical data."
  [
    Getopts.string 'w' (fun w _ -> cwd := !cwd ^ w |> normalize_path) "directory to assume as cwd";
    Getopts.string 't' (fun t _ -> template_value := Some t) "directory containing templates";
    Getopts.string 'c' (fun c _ -> data_folder_value := Some c) "directory containing data";
    Getopts.string 'o' (fun c _ -> output_folder_value := Some c) "directory to output generated tests";
    Getopts.string 'f' (fun c _ -> filter_value := Some c) "filter out files not matching this string";
  ] 
  (fun _ _ -> ())
  []

let () =
  Getopts.parse_argv spec ();
  let templates_folder = get_path template_value "./templates" in
  let canonical_data_folder = get_path data_folder_value "./problem-specifications/exercises" in
  let output_folder = get_path output_folder_value "./exercises" in
  ignore (Controller.run 
    ~templates_folder
    ~canonical_data_folder 
    ~output_folder 
  |> Result.ok_exn);
