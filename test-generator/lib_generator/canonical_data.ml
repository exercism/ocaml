open Core
type json = Yojson.Basic.t

type t = {
  version: string;
  exercise: string;
  comments: string list;
  cases: json list;
}

let get_reimplemented_uuids (cases: Yojson.Basic.t list) : string list =
  List.filter_map cases ~f:(fun c ->
    match Yojson.Basic.Util.member "reimplements" c with
    | `String s -> Some s
    | _ -> None)

let of_string (s: string): t =
  let open Yojson.Basic in
  let mem = fun k -> Util.member k (from_string s) in
  let version = (mem "version") |> Util.to_string_option |> function Some x -> x | None -> "1.0" in
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

  let cases = (mem "cases") |> Util.to_list |> sanitize_cases in

  (* filter original cases whose UUID is referenced in "reimplements" *)
  let reimplemented_uuids = get_reimplemented_uuids cases in
  let filtered_cases =
    List.filter cases ~f:(fun c ->
      match Util.member "uuid" c with
      | `String uuid -> not (List.mem reimplemented_uuids uuid ~equal:String.equal)
      | _ -> true
    )
  in

  {
    version;
    exercise;
    comments = (try (mem "comments") |> Util.to_list |> List.map ~f:Util.to_string with _ -> []);
    cases = filtered_cases
  }

let rec yo_to_ez (j: Yojson.Basic.t): Ezjsonm.value =
  match j with
  | `Null -> `Null
  | `Bool b -> `Bool b
  | `Float f -> `String (Float.to_string f)
  | `Int i -> `String (Int.to_string i)
  | `List l -> `A (List.map l ~f:yo_to_ez)
  | `String s -> `String s
  | `Assoc l -> `O (List.map l ~f:(fun (k, v) -> (k, yo_to_ez v)))

let to_json (d: t): Mustache.Json.t =
  `O [
    ("name", `String d.exercise);
    ("version", `String d.version);
    ("comments", `A (List.map d.comments ~f:(fun c -> `String c)));
    ("cases", `A (List.map d.cases ~f:yo_to_ez))
  ]

let to_string (d: t): string =
  to_json d |> Ezjsonm.to_string ~minify:true
