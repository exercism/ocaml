open Base

let rec range a b =
  if a > b then
    []
  else
    a :: (range (a + 1) b)

let square_of_sum n =
  let numbers = (range 1 n) in
  let sum = (List.fold ~init:0 ~f:(fun s t -> s + t) numbers) in
  sum * sum

let sum_of_squares n =
  let numbers = (range 1 n) in
  let square m = m * m in
  let squares = (List.map ~f:square numbers) in
  List.fold ~init:0 ~f:(fun s t -> s + t) squares

let difference_of_squares n =
  (square_of_sum n) - (sum_of_squares n)
