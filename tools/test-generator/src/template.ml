open Core

open Codegen
open Utils

(* start and finish are the lines where the generated code should be copied *)
type template_part = {
  start: int;
  finish: int;
  template: string;
} [@@deriving eq, show]

type suite = {
  template_part: template_part;
  suite_name_line: int;
  suite_end: int;
} [@@deriving eq, show]

type template = 
  Single of template_part
| Multi of (suite list) [@@deriving eq, show]

type t = {file_text: string;
          template: template;
         } [@@deriving eq, show]

let find_template ~(template_text: string): t option =
  let open Option.Monad_infix in
  let lines = String.split_lines template_text |> List.to_array in
  let test_starts = Array.filter_mapi lines ~f:(fun i l -> if (String.is_substring l ~substring:"(* TEST") then Some i else None) in
  let test_ends = Array.filter_mapi lines ~f:(fun i l -> if (String.is_substring l ~substring:"END TEST") then Some i else None) in
  let test_starts_and_ends = Array.zip_exn test_starts test_ends in
  let template_lines = Array.map test_starts_and_ends ~f:(fun (s,e) -> Array.slice lines (s+1) e) in
  let suite_name_lines = Array.filter_mapi lines ~f:(fun i l -> if (String.is_prefix l ~prefix:"let (* SUITE ") then Some i else None) in
  let suite_ends = Array.filter_mapi lines ~f:(fun i l -> if (String.is_prefix l ~prefix:"(* END SUITE *)") then Some i else None) in
  if Array.is_empty suite_name_lines || Array.is_empty suite_ends
  then
    if Array.is_empty test_starts || Array.is_empty test_ends
    then None
    else
    Some {
      file_text = template_text;
      template = Single {start = test_starts.(0); finish = test_ends.(0); template = String.concat_array ~sep:"\n" (template_lines.(0))}
    }
  else
    let suites = Array.mapi suite_name_lines ~f:(fun i sn -> {
      template_part =
      {
        start = test_starts.(i); 
        finish = test_ends.(i);
        template = template_lines.(i) |> String.concat_array ~sep:"\n";
      };
      suite_name_line = suite_name_lines.(i);
      suite_end =suite_ends.(i);
    }) |> Array.to_list in
    Some {
      file_text = template_text;
      template = Multi suites
    }

let fill_tests (file_text: string) (template: template_part) (substs: subst list): string =
  let lines = String.split_lines file_text |> List.to_array in
  let before = Array.slice lines 0 template.start in
  let subst = Array.of_list (List.map ~f:subst_to_string substs) in
  let after = Array.slice lines (template.finish + 1) (Array.length lines) in
  let join = String.concat_array ~sep:"\n" in
  String.concat [join before; join subst; join after] ~sep:"\n"

let array_drop n xs =
  Array.slice xs n (Array.length xs)

let list_drop_right n xs =
  List.slice xs 0 (List.length xs - n)

let fill_single_suite (file_lines: string array) (suite: suite) (suite_substs: string * subst list): (string, string) Result.t =
  let open Result.Monad_infix in
  let (suite_name, substs) = suite_substs in
  let suite_name_line = suite.suite_name_line in
  let suite_end = suite.suite_end in
  let lines = array_drop suite_name_line file_lines in
  Array.replace lines 0 ~f:(String.substr_replace_all ~pattern:("(* SUITE " ^ suite_name ^ " *)") ~with_:"");
  let before = Array.slice lines 0 (suite.template_part.start - suite_name_line) in
  let subst = Array.of_list (List.map ~f:subst_to_string substs) in
  let after = Array.slice lines (suite.template_part.finish - suite_name_line + 1) (suite_end - suite_name_line) in
  let join = String.concat_array ~sep:"\n" in
  Result.return @@ (String.concat [join before; join subst; join after] ~sep:"\n") ^ "\n"

let matches_suite_name file_lines suite suite_name =
  let line = file_lines.(suite.suite_name_line) in
  String.is_substring line ~substring:suite_name

let to_single = function
| (Single s) -> s
| _ -> failwith "bug"

let to_multi = function
| Multi suites -> suites
| _ -> failwith "unexpected case"   

let fill_suite (template: t) (suite_substs: (string * subst list) list): (string, string) Result.t =
  let file_lines = String.split_lines template.file_text |> List.to_array in
  let open Result.Monad_infix in
  let suites = to_multi template.template in
  let fill_1_suite text (line, suite): (string, string) Result.t =
    let suite_subst = List.find_exn suite_substs ~f:(fun (suite_name,_) -> matches_suite_name file_lines suite suite_name) in
    fill_single_suite file_lines suite suite_subst >>= fun subst ->
    let suite_name_line = suite.suite_name_line in
    let before = Array.slice file_lines line suite_name_line |> String.concat_array ~sep:"\n" in
    let generated = before ^ "\n" ^ subst in
    Ok generated
  in 
  let lines = List.rev_map suites ~f:(fun s -> 1 + s.suite_end) |> List.tl_exn |> List.rev |> List.cons 0 in
  let lines_and_suites = List.zip_exn lines suites in
  List.map lines_and_suites ~f:(fill_1_suite template.file_text) |> sequence |> Result.map ~f:(String.concat ~sep:"\n") >>= fun all_but_last_part ->
  let last_suite_line = (List.last_exn suites).suite_end + 1 in
  let last_part = Array.slice file_lines last_suite_line (Array.length file_lines) |> String.concat_array ~sep:"\n" in
  Ok (all_but_last_part ^ last_part)
