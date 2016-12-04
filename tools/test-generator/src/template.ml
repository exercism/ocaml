open Core.Std

open Codegen
open Utils

(* start and finish are the lines where the generated code should be copied *)
type t = {start: int;
          finish: int;
          file_text: string;
          template: string;
          suite_name_line: int option;
          suite_end: int option;
          suite_all_names_line: int option;
         } [@@deriving eq, show]

let find_template ~(template_text: string): t option =
  let open Option.Monad_infix in
  let str_contains pattern s = String.substr_index s ~pattern |> Option.is_some in
  let lines = String.split_lines template_text |> List.to_array in
  let suite_end = find_arrayi lines ~f:(str_contains "(* END SUITE *)") |> Option.map ~f:fst in
  let start_index = find_arrayi lines ~f:(str_contains "(* TEST") |> Option.map ~f:fst in
  let finish_index = (start_index >>= (fun start -> find_arrayi ~start lines ~f:(str_contains "END TEST *"))) |> Option.map ~f:fst in
  let template_lines = Option.map2 start_index finish_index (fun s -> Array.slice lines (s+1)) in
  let suite_name_line = find_arrayi lines ~f:(str_contains "(* SUITE *)$(suite_name)") |> Option.map ~f:fst in
  let suite_all_names_line = find_arrayi lines ~f:(str_contains "(* suite-all-names *)") |> Option.map ~f:fst in
  Option.map2 start_index template_lines ~f:(fun s l -> {start=s;
                                                         finish=(s + 1 + Array.length l);
                                                         file_text = template_text;
                                                         template=String.concat_array l ~sep:"\n";
                                                         suite_name_line = suite_name_line;
                                                         suite_end = suite_end;
                                                         suite_all_names_line = suite_all_names_line
                                                        })

let fill_tests (template: t) (substs: subst list): string =
  let lines = String.split_lines template.file_text |> List.to_array in
  let before = Array.slice lines 0 template.start in
  let subst = Array.of_list (List.map ~f:subst_to_string substs) in
  let after = Array.slice lines (template.finish + 1) (Array.length lines) in
  let join = String.concat_array ~sep:"\n" in
  String.concat [join before; join subst; join after] ~sep:"\n"

(* HACKS HERE *)
let fill_single_suite (template: t) (suite_substs: string * subst list): string =
  let (suite_name, substs) = suite_substs in
  let suite_name_line = Option.value_exn template.suite_name_line in
  let suite_end_line = Option.value_exn template.suite_end in
  let lines = String.split_lines template.file_text |> Fn.flip List.drop suite_name_line |> List.to_array in
  Array.replace lines 0 ~f:(String.substr_replace_all ~pattern:"(* SUITE *)$(suite_name)_tests" ~with_:(suite_name ^ "_tests"));
  let before = Array.slice lines 0 (template.start - suite_name_line) in
  let subst = Array.of_list (List.map ~f:subst_to_string substs) in
  let after = Array.slice lines (template.finish - suite_name_line + 1) (suite_end_line - suite_name_line) in
  let join = String.concat_array ~sep:"\n" in
  String.concat [join before; join subst; join after] ~sep:"\n"

(* HACKS HERE *)
let fill_suite (template: t) (suite_substs: (string * subst list) list): string =
  let fills = List.map suite_substs ~f:(fun x -> (fill_single_suite template x) ^ "\n") in
  let suite_name_line = Option.value_exn template.suite_name_line in
  let lines = String.split_lines template.file_text |> List.to_array in
  let before = Array.slice lines 0 suite_name_line in
  let subst = Array.of_list fills in
  let after = Array.slice lines (template.finish + 4) (Array.length lines) in
  let join = String.concat_array ~sep:"\n" in
  let generated = String.concat [join before; join subst; join after] ~sep:"\n" in
  let all_suite_names = String.concat ~sep:"; " @@ List.map ~f:(fun (s,_) -> s ^ "_tests") suite_substs in
  String.substr_replace_all generated ~pattern:"(* suite-all-names *)" ~with_:all_suite_names
