module CanonicalData = struct 
  type json = Yojson.Basic.t

  type t = {
    version: string;
    exercise: string;
    comments: string list;
    cases: json list;
  }

  let of_string (s: string): t =
    let open Yojson.Basic in
    let open Base in
    let mem = fun k -> Util.member k (from_string s) in
    let version = (mem "version") |> Util.to_string in
    let exercise = (mem "exercise") |> Util.to_string in
    let rec sanitize_cases (c: Yojson.Basic.t list): Yojson.Basic.t list = 
      if List.for_all c ~f:(fun c -> Util.keys c |> List.exists ~f:(fun k -> String.(k = "cases"))) then
        c 
        |> List.map ~f:(fun group -> `Assoc [
          ("description", Util.member "description" group); 
          ("slug", `String ((Util.member "description" group) |> Util.to_string |> String.lowercase |> String.substr_replace_all ~pattern:" " ~with_:"_" |> String.substr_replace_all ~pattern:"-" ~with_:"_"));
          ("cases", `List (Util.member "cases" group |> Util.to_list |> sanitize_cases))
        ])
        |> List.map ~f:(Special_cases.edit_case ~slug:exercise)
      else 
        c
        |> List.filter_map ~f:(fun c -> 
          let c = Special_cases.edit_case ~slug:exercise c in
        (Util.member "input" c)
          |> (fun a -> try Some (Util.to_assoc a) with Util.Type_error _ -> None)
          |> Option.map ~f:(fun params -> ("expected", Util.member "expected" c) :: params) (* mix .expected onto .input.expected to retain backward compat *)
          |> Option.bind ~f:(Special_cases.edit_parameters ~slug:exercise)
          |> Option.map ~f:(fun l -> `Assoc (List.map l ~f:(fun (k, v) -> (k, `String v))))
          |> Option.map ~f:(fun i -> `Assoc (("input", i) :: (Util.to_assoc c |> List.filter ~f:(fun (k, _) -> String.(k <> "input" && k <> "expected"))))
        )
    )    
    in
    {
      version;
      exercise;
      comments = (try (mem "comments") |> Util.to_list |> List.map ~f:Util.to_string with _ -> []);
      cases = (mem "cases") |> Util.to_list |> sanitize_cases
    }

  let rec yo_to_ez (j: Yojson.Basic.t): Ezjsonm.value =
    let open Base in
    match j with
    | `Null -> `Null
    | `Bool b -> `Bool b
    | `Float f -> `String (Float.to_string f)
    | `Int i -> `String (Int.to_string i)
    | `List l -> `A (List.map l ~f:yo_to_ez)
    | `String s -> `String s
    | `Assoc l -> `O (List.map l ~f:(fun (k, v) -> (k, yo_to_ez v)))

  let to_json (d: t): Mustache.Json.t =
    let open Base in
    `O [ 
      ("name", `String d.exercise);
      ("version", `String d.version);
      ("comments", `A (List.map d.comments ~f:(fun c -> `String c)));
      ("cases", `A (List.map d.cases ~f:yo_to_ez))
    ]

  let to_string (d: t): string =
    to_json d |> Ezjsonm.to_string ~minify:true 
end

module Template = struct
  type t = {
    path: string;
    relative_path: string;
    content: string;
  }

  let of_path (path: string) ~(tpl: string): t = 
    let open Base in
    let content = Files.read_file path |> Result.ok_exn in
    let relative_path = Files.relative_path tpl path in
    {
      path;
      relative_path;
      content
    }

  let format (c: string): string =
    let b = Buffer.create (String.length c) in
    let o = { IndentPrinter.std_output with kind=(Print (fun s () -> Buffer.add_string b s)) } in
    IndentPrinter.proceed o (Nstream.of_string c) IndentBlock.empty ();
    Buffer.contents b

  let render (t: t) ~(data: CanonicalData.t): string =
    try 
      let open Base in
      Mustache.render (Mustache.of_string t.content) (CanonicalData.to_json data)
      |> String.substr_replace_all ~pattern:"&quot;" ~with_:"\""
      |> String.substr_replace_all ~pattern:"&apos;" ~with_:"\'"
      |> String.substr_replace_all ~pattern:"&amp;" ~with_:"&"
      |> String.substr_replace_all ~pattern:"&lt;" ~with_:"<"
      |> String.substr_replace_all ~pattern:"&gt;" ~with_:">"
    with exn ->
      Printf.printf "%s\n======\n%s" (t.relative_path) (t.content);
      raise exn

  let to_string (t: t): string =
    Printf.sprintf "Template { path = %s; relative_path = %s; content = %s }"
    t.path
    t.relative_path
    t.content
end

module ExerciseCandidate = struct
  type t = {
    name: string;
    directory: string;
    get_templates: tpl:string -> Template.t list;
    get_data: unit -> (CanonicalData.t, exn) result;
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
    let get_data = fun () -> Files.read_file p |> Result.map ~f:CanonicalData.of_string in
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
end

module Exercise = struct   
  type t = {
    name: string; (* unique name *)
    directory: string; (* target directory *)
    description: string option; (* description.md contents *)
    canonical_data: CanonicalData.t; (* canonical_data.json data *)
    templates: Template.t list; (* all templates *)
  }         

  let of_candidate ~(tpl: string) ~(out: string) (c: ExerciseCandidate.t): t =
    let open Base in
    {
      name = c.name;
      directory = Files.append_path out c.name;
      description = (c.get_description ());
      canonical_data = Result.ok_exn (c.get_data ());
      templates = (c.get_templates ~tpl)
    }

  let to_string (e: t): string =
    let open Base in
    let print_description = function
      | None -> "None"
      | Some d -> Caml.Printf.sprintf "%s" d 
    in
    Printf.sprintf "ExerciseCandidate { name = \"%s\"; directory = \"%s\"; description = \"%s\"; canonical_data = %s; templates = %s }" 
      e.name 
      e.directory 
      (print_description e.description)
      (CanonicalData.to_string e.canonical_data)
      (List.map e.templates ~f:Template.to_string |> String.concat ~sep:"; ")
end

open Base
open Types 

let run 
  ~(language_config: language_config) 
  ~(templates_folder: string) 
  ~(canonical_data_folder: string) 
  ~(output_folder: string) 
  ~(generated_folder: string) 
  (filter: string option) =
    Files.find_files canonical_data_folder ~glob:["*canonical-data.json"]
    |> List.map ~f:ExerciseCandidate.of_path
    |> List.filter ~f:(fun (e: ExerciseCandidate.t) -> e.is_implemented ~tpl:templates_folder)
    |> List.map ~f:(Exercise.of_candidate ~tpl:templates_folder ~out:output_folder)
    |> List.concat_map ~f:(fun (e: Exercise.t) ->
      List.map e.templates ~f:(fun (t: Template.t) -> 
        let path = Files.append_path output_folder t.relative_path |> Files.strip_ext in
        Template.render t ~data:e.canonical_data 
        |> (fun r -> if String.((Files.ext path) = ".ml") then Template.format r else r)
        |> Files.write_file ~path
      ))
    |> Result.all
