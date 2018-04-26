open Base

let find_smallest_coins_list_meeting_target (cache: int list option array) (coins: int list) (target: int): int list option =
  let find_coins_meeting_target_minus_coin coin = 
    if target = coin
    then Some [coin]
    else cache.(target - coin) |> Option.map ~f:(List.cons coin) in
  List.filter coins ~f:(fun x -> x <= target)
  |> List.map ~f:find_coins_meeting_target_minus_coin 
  |> List.filter_map ~f:(Fn.id) 
  |> List.sort ~compare:(fun xs ys -> Int.compare (List.length xs) (List.length ys))
  |> List.hd

let make_change ~target ~coins = match target with
| 0 -> Some []
| _ when target < 0 -> None
| _ ->
  let cache = Array.create ~len:(target+1) None in
  for i = 1 to target do
    cache.(i) <- find_smallest_coins_list_meeting_target cache coins i
  done;
  cache.(target)