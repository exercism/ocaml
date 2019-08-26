open Base
open Stdio

let mkdir_if_not_present dir =
  if not (Utils.file_exists dir)
  then begin
    Unix.mkdir dir 0o640;
    print_endline @@ "Storing generated files in " ^ dir
  end 
  else ()

let backup ~(base_folder: string) ~(slug: string) ~(contents: string): bool =
  mkdir_if_not_present base_folder;
  let path = Caml.Filename.concat base_folder slug in
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