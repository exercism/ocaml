type t = {
  name: string;
  directory: string;
  get_templates: tpl:string -> Template.t list;
  get_data: unit -> (Canonical_data.t, exn) result;
  get_description: unit -> string option;
  is_implemented: tpl:string -> bool;
  has_data: unit -> bool;
  has_templates: tpl:string -> bool;
}

let of_path (p: string): t = 
  let open Base in
  let name = Files.get_parent_name p in
  let directory = Files.get_parent_string p in
  let get_template_files = fun ~tpl -> 
    try Files.find_files (Files.append_path tpl name) ~glob:["*.tpl*"]
    with Unix.Unix_error(Unix.ENOENT, _, _) -> [] 
  in
  let get_templates = fun ~tpl -> get_template_files ~tpl |> List.map ~f:(Template.of_path ~tpl) in
  let get_data = fun () -> Files.read_file p |> Result.map ~f:Canonical_data.of_string in
  let get_description = fun () -> try Files.read_file (Files.append_path directory "description.md") |> Result.ok with _ -> None in
  let has_data = fun () -> Files.read_file p |> Result.is_ok in
  let has_templates = fun ~tpl -> List.length (get_template_files ~tpl) > 0 in
  let is_implemented = fun ~tpl -> has_data () && has_templates ~tpl in
  { 
    name; 
    directory;
    get_templates;
    get_data;
    get_description;
    is_implemented;
    has_data;
    has_templates;
  }

let to_string (e: t): string = 
  Printf.sprintf "ExerciseCandidate { name = \"%s\"; directory = \"%s\"; }" e.name e.directory