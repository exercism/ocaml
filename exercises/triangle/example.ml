open Base

let sort_sides a b c = 
  let side = List.nth_exn (List.sort ~cmp:Int.compare [a; b; c]) in
  (side 0, side 1, side 2)

let is_triangle a b c = 
  let (a, b, c) = sort_sides a b c in
  c > 0 && c <= a + b

let is_equilateral a b c = is_triangle a b c && a = b && b = c

let is_isosceles a b c = is_triangle a b c && (a = b || b = c || a = c)

let is_scalene a b c = is_triangle a b c && (a <> b && b <> c)