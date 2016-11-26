open Core.Std

open Codegen
open Utils

(* start and finish are the lines where the generated code is *)
type t = {start: int; finish: int; file_text: string; template: string} [@@deriving eq, show]

let find_template ~(template_text: string): t option =
  let open Option.Monad_infix in
  let str_contains pattern s = String.substr_index s ~pattern |> Option.is_some in
  let lines = String.split_lines template_text |> List.to_array in
  let start_index = find_arrayi lines ~f:(str_contains "(* GENERATED-CODE") |> Option.map ~f:fst in
  let finish_index = (start_index >>= (fun start -> find_arrayi ~start lines ~f:(str_contains "END GENERATED-CODE *"))) |> Option.map ~f:fst in
  let template_lines = Option.map2 start_index finish_index (fun s -> Array.slice lines (s+1)) in
  Option.map2 start_index template_lines ~f:(fun s l -> {start=s; finish=(s + 1 + Array.length l); file_text = template_text; template=String.concat_array l ~sep:"\n"})

let fill (template: t) (substs: subst list): string =
  let lines = String.split_lines template.file_text |> List.to_array in
  let before = Array.slice lines 0 template.start in
  let subst = Array.of_list (List.map ~f:subst_to_string substs) in
  let after = Array.slice lines (template.finish + 1) (Array.length lines) in
  let join = String.concat_array ~sep:"\n" in
  String.concat [join before; join subst; join after] ~sep:"\n"
