open Core_kernel
open React

let allowed_failures = 9

type progress =
    | Win
    | Lose
    | Busy of int

type t = {
    send_feed : ?step:React.step -> char -> unit;
    masked_word_s : string signal;
    progress_s : progress signal;
}

let feed c { send_feed; _ } = send_feed c
let masked_word { masked_word_s; _ } = masked_word_s
let progress { progress_s; _ } = progress_s

let calc_failures target tried =
    let rec go fails target' = function
        | h :: t when Char.Set.mem target' h ->
            go fails (Char.Set.remove target' h) t
        | _ :: t -> go (fails+1) target' t
        | [] -> fails
    in go 0 target tried

let mask_word word tried =
    let tried' = Char.Set.of_list tried in
    String.map ~f:(function c when Set.mem tried' c -> c | _ -> '_') word

let calc_progress masked_word failures =
    if failures > allowed_failures then
        Lose
    else if not (String.mem masked_word '_') then
        Win
    else
        Busy (allowed_failures - failures)

let create word =
    let target = String.to_list word |> Char.Set.of_list in
    let feed_e, send_feed = E.create () in
    let tried_s = S.fold (fun t h -> h :: t) [] feed_e in
    let failures_s = S.map (calc_failures target) tried_s in
    let masked_word_s = S.map (mask_word word) tried_s in
    let progress_s = S.l2 calc_progress masked_word_s failures_s in
    { send_feed; masked_word_s; progress_s }
