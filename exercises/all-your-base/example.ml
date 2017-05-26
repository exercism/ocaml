open Core

type base = int

let rec to_digits (b: base) (acc: int list) = function
  | 0 -> acc
  | n -> to_digits b (n % b :: acc) (n / b)

let convert_bases ~from ~digits ~target =
  if from <= 1 || target <= 1 || List.is_empty digits
  then None
  else
    let open Option.Monad_infix in
    let digits = List.fold_left digits ~init:(Some 0) ~f:(fun acc d ->
        if d < 0 || d >= from
        then None
        else acc >>= (fun acc -> Some (acc * from + d))
      ) in
    Option.map digits ~f:(to_digits target [])
    |> Option.map ~f:(fun xs -> if List.is_empty xs then [0] else xs)
