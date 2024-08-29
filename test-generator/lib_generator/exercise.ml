open Core

type t = {
  name: string; (* unique name *)
  directory: string; (* target directory *)
  description: string option; (* description.md contents *)
  canonical_data: Canonical_data.t; (* canonical_data.json data *)
  templates: Template.t list; (* all templates *)
}

let of_candidate ~(tpl: string) ~(out: string) (c: Exercise_candidate.t): t =
  {
    name = c.name;
    directory = Files.append_path out c.name;
    description = (c.get_description ());
    canonical_data = Result.ok_exn (c.get_data ());
    templates = (c.get_templates ~tpl)
  }

let to_string (e: t): string =
  let print_description = function
    | None -> "None"
    | Some d -> Printf.sprintf "%s" d
  in
  Printf.sprintf "ExerciseCandidate { name = \"%s\"; directory = \"%s\"; description = \"%s\"; canonical_data = %s; templates = %s }"
    e.name
    e.directory
    (print_description e.description)
    (Canonical_data.to_string e.canonical_data)
    (List.map e.templates ~f:Template.to_string |> String.concat ~sep:"; ")
