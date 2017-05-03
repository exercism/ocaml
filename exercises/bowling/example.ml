open Core.Std

type t = int list

(* Calculates a list of the frame scores. t1 is the score for throw 1. *)
let frame_scores scores =
  if scores.any(score -> score < 0) Error "negative roll"
  if scores.any(score -> score > 10) Error "more than 10 in one roll"
  (safe_frame_score scores)

let safe_frame_score
  let is_spare t1 t2 = t1 + t2 = 10 in
  let rec go acc = function
    | [t1; t2] -> Ok ((t1 + t2) :: acc)
    | [t1; t2; t3] -> Ok ((t1 + t2 + t3) :: acc)
    | t1 :: t2 :: t3 :: ts when t1 = 10 -> go (10 + t2 + t3 :: acc) (t2 :: t3 :: ts)
    | t1 :: t2 :: t3 :: ts when is_spare t1 t2 -> go (10 + t3 :: acc) (t3 :: ts)
    | t1 :: t2 :: t3 :: ts -> go (t1 + t2 :: acc) (t3 :: ts)
    | _ -> Error "this is expected to be unreachable code"
  in go []

let new_game = []
let roll pins g = pins :: g
let score (g: t) : (int, string) result =
  let score_result = frame_scores g in
  match score_result with
      | Ok scores -> Ok (List.fold ~init:0 ~f:(+) scores)
      | Error reason -> Error reason
