open Core.Std

let sort_sides = function
| [_; _; _] as sides ->
    let side = List.nth_exn (List.sort sides ~cmp:Int.compare) in
    (side 0, side 1, side 2)
| _ -> failwith "not at triangle"

let is_triangle f sides = 
  let (a, b, c) = sort_sides sides in
  c > 0 && c <= a + b && f a b c

let is_equilateral = is_triangle (fun a b c -> a = b && b = c)

let is_isoceles = is_triangle (fun a b c -> a = b || b = c)

let is_scalene = is_triangle (fun a b c -> a <> b && b <> c)