open Core

let run
  ~(templates_folder: string)
  ~(canonical_data_folder: string)
  ~(output_folder: string) =
    Files.find_files canonical_data_folder ~glob:["*canonical-data.json"]
    |> List.map ~f:Exercise_candidate.of_path
    |> List.filter ~f:(fun (e: Exercise_candidate.t) -> e.is_implemented ~tpl:templates_folder)
    |> List.map ~f:(Exercise.of_candidate ~tpl:templates_folder ~out:output_folder)
    |> List.concat_map ~f:(fun (e: Exercise.t) ->
      List.map e.templates ~f:(fun (t: Template.t) ->
        let path = Files.append_path output_folder t.relative_path |> Files.strip_ext in
        Template.render t ~data:e.canonical_data
        |> (fun r -> if String.((Files.ext path) = ".ml") then Template.format r else r)
        |> Files.write_file ~path
      ))
    |> Result.all


(* bin_data_checker calls this, but does not exist *)
let check_canonical_data _ = failwith "not implemented"
