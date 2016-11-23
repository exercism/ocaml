open Core.Std
open Parser
open Model
open Utils
open Codegen
open Special_cases

let find_template ~(template_text: string): (int * int * string) option =
  let open Option.Monad_infix in
  let str_contains pattern s = String.substr_index s ~pattern |> Option.is_some in
  let lines = String.split_lines template_text |> List.to_array in
  let start_index = find_arrayi lines ~f:(str_contains "(* GENERATED-CODE") |> Option.map ~f:fst in
  let finish_index = (start_index >>= (fun start -> find_arrayi ~start lines ~f:(str_contains "END GENERATED-CODE *"))) |> Option.map ~f:fst in
  let template_lines = Option.map2 start_index finish_index (fun s -> Array.slice lines (s+1)) in
  Option.map2 start_index template_lines ~f:(fun s l -> (s, s + 1 + Array.length l, String.concat_array l ~sep:"\n"))

let splice_in_filled_in_code (start: int) (finish: int) ~(template: string) (substs: string list): string =
  let lines = String.split_lines template |> List.to_array in
  let before = Array.slice lines 0 start in
  let subst = Array.of_list substs in
  let after = Array.slice lines (finish + 1) (Array.length lines) in
  let join = String.concat_array ~sep:"\n" in
  String.concat [join before; join subst; join after] ~sep:"\n"

type content = string

let find_nested_files (name: string) (base: string): (string * content) list =
  Sys.ls_dir base
    |> List.filter ~f:(fun slug -> Sys.is_directory_exn (base ^ "/" ^ slug))
    |> List.filter ~f:(fun slug -> Sys.file_exists_exn (base ^ "/" ^ slug ^ "/" ^ name))
    |> List.map ~f:(fun slug -> (slug, In_channel.read_all (base ^ "/" ^ slug ^ "/" ^ name)))

let find_templates = find_nested_files "template.ml"

let find_canonical_data_files = find_nested_files "canonical-data.json"

let combine_files (templates: (string * content) list) (canonical_data: (string * content) list): (string * content * content) list =
  List.filter_map templates ~f:(fun (n,t) -> (List.Assoc.find canonical_data ~equal:String.equal n |> Option.map ~f:(fun c -> (n,t,c))))

let generate_code ~slug ~template_file ~canonical_data_file =
  let template = find_template template_file in
  let template = Result.of_option template "cannot find a template" in
  let cases = parse_json_text canonical_data_file in
  let cases = Result.map_error cases show_error in
  let open Result.Monad_infix in
  template >>= fun (s,e,template) ->
  cases >>= fun cs ->
  let Ok substs = generate_code (fixup ~stringify:parameter_to_string ~slug) template cs in
  Result.return (splice_in_filled_in_code s e ~template:template_file substs)

let output_tests (files: (string * content * content) list) (output_folder: string): unit =
  let output_filepath name = output_folder ^ "/" ^ name ^ "/test.ml" in
  let output1 (slug,t,c) =
    let Ok code = generate_code slug t c in
    Out_channel.write_all (output_filepath slug) code in
  List.iter files ~f:output1

let run ~(templates_folder: string) ~(canonical_data_folder: string) ~(output_folder: string) =
  let templates = find_templates templates_folder in
  let canonical_data_files = find_canonical_data_files canonical_data_folder in
  let combined = combine_files templates canonical_data_files in
  output_tests combined output_folder
