open Core.Std

let mkdir_if_not_present dir =
  if Sys.file_exists dir = `No then Unix.mkdir dir else ()

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
    Out_channel.write_all path contents; 
    true
  end