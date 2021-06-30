open Base

type palindrome_products = {
  value : int option;
  factors : (int * int) list;
} [@@deriving show, eq]

let is_palindrome n =
  let n = Int.to_string n in String.(rev n = n)

let to_palindrome_products (xs : (int * (int * int)) list): palindrome_products =
  let value = List.hd xs |> Option.map ~f:fst in
  let factors = List.map ~f:snd xs in
  {value; factors}

let seq stride = Sequence.range ~start:`inclusive ~stop:`inclusive ~stride

let empty = Ok {value=None; factors=[]}

let smallest ~min ~max =
  if min > max
  then Error "min must be <= max"
  else 
    let open Sequence.Monad_infix in
    let seq = seq 1 in
    let products = 
      seq min max >>= fun x -> 
      seq x max >>= fun y -> 
      Sequence.singleton (x * y, (x, y)) 
      |> Sequence.filter ~f:(fun (n, _) -> is_palindrome n) in
    products
      |> Sequence.to_list
      |> List.sort ~compare:(fun (x,_) (y,_) -> Int.compare x y)
      |> List.group ~break:(fun (x, _) (y, _) -> x <> y)
      |> List.hd
      |> Option.value_map ~default:(empty) ~f:(fun x -> Ok (to_palindrome_products x))

let largest ~min ~max = 
  if min > max
  then Error "min must be <= max"
  else 
    let open Sequence.Monad_infix in
    let seq = seq (-1) in
    let products = 
      seq max min >>= fun x -> 
      seq x min >>= fun y -> 
      Sequence.singleton (x * y, (y, x)) 
      |> Sequence.filter ~f:(fun (n, _) -> is_palindrome n) in
    products
      |> Sequence.to_list
      |> List.sort ~compare:(fun (x,_) (y,_) -> Int.compare y x)
      |> List.group ~break:(fun (x, _) (y, _) -> x <> y)
      |> List.hd
      |> Option.value_map ~default:(empty) ~f:(fun x -> Ok (to_palindrome_products x))

  