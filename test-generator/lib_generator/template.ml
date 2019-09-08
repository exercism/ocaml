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

let render (t: t) ~(data: Canonical_data.t): string =
  try 
    let open Base in
    Mustache.render (Mustache.of_string t.content) (Canonical_data.to_json data)
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