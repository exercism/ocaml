type item = {
    weight : int;
    value : int;
}

let max_value (i: item) (prev_values: int list) (capacity: int): int =
  let value_without = List.nth prev_values capacity in
  match (i.weight, capacity) with
  | (w, c) when c < w -> value_without
  | (w, c) -> let value_with = (List.nth prev_values (c - w)) + i.value in
                Int.max value_with value_without

let next_values (i: item) (prev_values: int list): int list =
  List.mapi (fun capacity _v -> max_value i prev_values capacity) prev_values

let rec calculate_values (items: item list) (values: int list): int list =
  match items with
  | [] -> values
  | i :: next -> calculate_values next (next_values i values)

let rec last_value (v: int) (l: int list): int =
  match l with
  | [] -> v
  | n :: r -> last_value n r

let maximum_value (items: item list) (capacity: int): int =
  let size = capacity + 1 in
  let initial = List.init size (fun (_) -> 0) in
    calculate_values items initial
    |> last_value 0
