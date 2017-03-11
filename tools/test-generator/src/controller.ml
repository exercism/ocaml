open Core.Std
open Parser
open Model
open Utils
open Codegen
open Special_cases
open Template
open Files

type content = string

let find_nested_files (name: string) (base: string): (string * content) list =
  Sys.ls_dir base
  |> List.filter ~f:(fun slug -> Sys.is_directory_exn (base ^ "/" ^ slug))
  |> List.filter ~f:(fun slug -> Sys.file_exists_exn (base ^ "/" ^ slug ^ "/" ^ name))
  |> List.map ~f:(fun slug -> (slug, In_channel.read_all (base ^ "/" ^ slug ^ "/" ^ name)))

let find_template_files base filter = 
  let all_files = find_nested_files "template.ml" base in
  let filter = Option.value filter ~default:"" in
  List.filter all_files ~f:(fun (slug,_) -> String.is_substring slug ~substring:filter)

let find_canonical_data_files = find_nested_files "canonical-data.json"

let combine_files (template_files: (string * content) list) (canonical_data_files: (string * content) list): (string * content * content) list =
  List.filter_map template_files ~f:(fun (n,t) -> (List.Assoc.find canonical_data_files ~equal:String.equal n |> Option.map ~f:(fun c -> (n,t,c))))

(* pangram in the canonical data is a suite but it does not really need to be as there's only one group. Convert a Suite to
   a Single test in this case, to simplify the template. *)
let simplify_single_test_suite (tests: tests): tests = match tests with
| Suite [{name = name; cases = cases}] -> Single cases
| x -> x

let generate_code ~(slug: string) ~(template_file: content) ~(canonical_data_file: content): (content, content) Result.t =
  let open Result.Monad_infix in
  Result.of_option ~error:("cannot recognize file for " ^ slug ^ " as a template") @@ find_template template_file >>= fun template ->
  let edit_expected = edit_expected ~stringify:json_to_string ~slug in
  let edit_parameters = edit_parameters ~slug in
  let fill_in_template = fill_in_template edit_expected edit_parameters in
  let file_text = template.file_text in
  let file_lines = String.split_lines file_text |> List.to_array in
  parse_json_text canonical_data_file (expected_key_name slug) (cases_name slug)
  |> Result.map_error ~f:show_error >>| simplify_single_test_suite >>= (function
      | Single cases ->
        let template = to_single template.template in
        fill_in_template template.template slug cases
        |> fill_tests file_text template
        |> Result.return
      | Suite tests ->
        let suites = to_multi template.template in
        let suites_by_line = List.map suites ~f:(fun s -> (file_lines.(s.suite_name_line), s)) in
        let find_suite name = List.find suites_by_line ~f:(fun (l,s) -> String.is_substring l ~substring:name) |> Option.map ~f:snd in
        let fill_suite_tests {name; cases} = 
          let suite = Result.of_option ~error:("cannot find template for suite " ^ name) (find_suite name) in
          Result.map suite ~f:(fun suite -> (name, fill_in_template suite.template_part.template name cases))
        in
        List.map tests ~f:fill_suite_tests |> sequence >>=
        fill_suite template
    )

let output_tests (files: (string * content * content) list) (output_folder: string) ~(generated_folder: string): unit =
  let output_filepath name = output_folder ^ "/" ^ name ^ "/test.ml" in
  let output1 (slug,t,c) =
    match generate_code slug t c with
    | Ok code -> 
        if backup ~base_folder:generated_folder ~slug ~contents:code
        then Out_channel.write_all (output_filepath slug) code
        else print_endline @@ "not generating " ^ slug ^ " as unchanged from previous generated file."
    | Error e -> print_endline ("Failed when generating " ^ slug ^ ", error: " ^ e) in
  List.iter files ~f:output1

let run ~(templates_folder: string) ~(canonical_data_folder: string) ~(output_folder: string) ~(generated_folder: string) (filter: string option) =
  let template_files = find_template_files templates_folder filter in
  let canonical_data_files = find_canonical_data_files canonical_data_folder in
  let combined = combine_files template_files canonical_data_files in
  output_tests combined output_folder generated_folder

let check_canonical_data canonical_data_folder =
  let ok_count = ref 0 in
  let canonical_data_files = find_canonical_data_files canonical_data_folder in
  let canonical_data_files = List.sort canonical_data_files ~cmp:(fun (s1, _) (s2, _) -> String.compare s1 s2) in
  let total_count = List.length canonical_data_files in
  List.iter canonical_data_files ~f:(fun (slug, text) ->
    match parse_json_text text (expected_key_name slug) (cases_name slug) with
    | Error e -> print_endline @@ slug ^ ": " ^ (show_error e)
    | _ -> ok_count := !ok_count + 1
  );
  print_endline @@ "There are " ^ (Int.to_string total_count) ^ " exercises with canonical data, " ^ (Int.to_string !ok_count) ^ " can be parsed."
