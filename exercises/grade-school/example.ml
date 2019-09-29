open Base

module Int_map = Map.M(Int)
type school = string list Int_map.t

let empty_school = Map.empty (module Int)

let add s g school = Map.add_multi ~key:g ~data:s school

let grade g school = Map.find school g |> Option.value ~default:[]

let sorted school = Map.map ~f:(List.sort ~compare:(Fn.flip String.compare)) school

let roster school =
  school
  |> Map.keys
  |> List.sort ~compare:Int.compare
  |> List.concat_map ~f:(fun g -> grade g (sorted school) |> List.rev)
