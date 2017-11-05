type position = Start | UpperSide | RightSide | LowerSide | LeftSide

let count_rectangles pic =
  let maxY = Array.length pic in
  let maxX = if maxY > 0 then String.length pic.(0) else 0 in
  let rec go count x y xStart yStart pos = 
    let on_side_fn dx dy next_pos () = 
      go count (x+dx) (y+dy) xStart yStart next_pos in
    let on_corner_fn dx1 dy1 dx2 dy2 next_pos () = 
      go count (x+dx1) (y+dy1) xStart yStart next_pos + go count (x+dx2) (y+dy2) xStart yStart pos in
    let progress side_ch on_side on_corner = 
      try
        match pic.(y).[x] with
        | c when c = side_ch -> on_side ()
        | '+' -> on_corner ()
        | _ -> count
      with Invalid_argument _ -> count in
    match pos with
    | Start -> 
        if y = maxY then count
        else if x = maxX then go count 0 (y+1) 0 (y+1) Start
        else (match pic.(y).[x] with
        | '+' -> go count (x+1) y x y UpperSide + go count (x+1) y x y Start
        | _ -> go count (x+1) y (x+1) y Start 
        )
    | UpperSide -> progress '-' (on_side_fn 1 0 UpperSide)    (on_corner_fn 0 1 1 0 RightSide)
    | RightSide -> progress '|' (on_side_fn 0 1 RightSide)    (on_corner_fn (-1) 0 0 1 LowerSide)
    | LowerSide -> progress '-' (on_side_fn (-1) 0 LowerSide) (on_corner_fn 0 (-1) (-1) 0 LeftSide)
    | LeftSide ->  progress '|' (on_side_fn 0 (-1) LeftSide)  (fun () -> if x = xStart && y = yStart then count+1 else go count x (y-1) xStart yStart LeftSide)
  in go 0 0 0 0 0 Start