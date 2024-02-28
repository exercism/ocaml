open Core
open Stdio

let file_exists dir =
  try
    Core_unix.access_exn dir [ `Exists ];
    true
  with Core_unix.Unix_error _ -> false

let is_directory dir =
  let s = Core_unix.stat dir in
  phys_equal s.st_kind Core_unix.S_DIR

let ls_dir dir =
  let rec f acc handle =
    match Core_unix.readdir_opt handle with
    | None ->
        Core_unix.closedir handle;
        acc
    | Some x -> f (x :: acc) handle
  in
  f [] (Core_unix.opendir dir)

let mkdir_if_not_present dir =
  if not (file_exists dir)
  then begin
    Core_unix.mkdir dir ~perm:0o750;
    print_endline @@ "Storing generated files in " ^ dir
  end
  else ()

let backup ~(base_folder: string) ~(slug: string) ~(contents: string): bool =
  mkdir_if_not_present base_folder;
  let path = Filename.concat base_folder slug in
  let matches_contents =
    Option.try_with (fun () -> In_channel.read_all path)
    |> Option.map ~f:(String.equal contents)
    |> Option.value ~default:false
  in
  if matches_contents
  then false
  else begin
    Out_channel.write_all path ~data:contents;
    true
  end

let path_exn (p: string): Fpath.t =
  Fpath.of_string p |> Result.map_error ~f:(function `Msg m -> m) |> Result.ok_or_failwith

let rec find_files (base: string) ~(glob: string list): string list =
  base
  |> ls_dir
  |> List.filter ~f:(fun p -> String.(p <> ".") && String.(p <> ".."))
  |> List.map ~f:(fun p -> base ^ "/" ^ p)
  |> List.concat_map ~f:(fun p ->
    if is_directory p then
      find_files p ~glob
    else if List.for_all glob ~f:(fun g -> Glob.matches g p) then
      [p]
    else
      [])

let is_broken (p: string): bool =
  match find_files p ~glob:[".broken"] with
  | [] -> false
  | _ -> true

let get_parent (p: string): Fpath.t =
  path_exn p |> Fpath.parent

let get_parent_name (p: string): string =
  get_parent p |> Fpath.basename

let get_parent_string (p: string): string =
  get_parent p |> Fpath.to_string

let group_by_parent (ps: string list): string list list =
  List.group ps ~break:(fun a b -> String.(get_parent_string a <> get_parent_string b))

let append_path (a: string) (b: string): string =
  (path_exn a |> Fpath.to_dir_path |> Fpath.to_string) ^ b

let relative_path (a: string) (b: string): string =
  Option.value_exn (Fpath.relativize ~root:(path_exn a) (path_exn b)) |> Fpath.to_string

let read_file (p: string): (string, exn) Result.t =
  let b = Buffer.create 0 in
  try
    let c = Stdio.In_channel.create p in
    while true do
      Buffer.add_string b (In_channel.input_line_exn c);
      Buffer.add_char b '\n';
    done;
    failwith "unreachable"
  with End_of_file -> Ok (Buffer.contents b)

let write_file ~(path: string) (data: string): (unit, exn) Result.t =
  Result.try_with (fun () ->
    mkdir_if_not_present (get_parent_string path);
    Stdio.Out_channel.write_all path ~data
  )

let strip_ext (path: string): string =
  path_exn path |> Fpath.rem_ext |> Fpath.to_string

let ext (path: string): string =
  path_exn path |> Fpath.get_ext ~multi:true
