open Base

type player = O | X
type cell = O | X | Empty

let eq_cell c1 c2 = match (c1, c2) with
| (O, O) -> true
| (X, X) -> true
| _ -> false

module IntTuple = struct
  module T = struct
    type t = int * int
    let compare (x0, y0) (x1, y1) =
      match Int.compare x0 x1 with
        0 -> Int.compare y0 y1
      | c -> c
    let sexp_of_t (x, y) = Sexp.List [Sexp.Atom (Int.to_string x); Sexp.Atom (Int.to_string y)]
  end
  include T
  include Comparable.Make(T)
end

let emptyIntIntSet = Set.empty (module IntTuple)

let (>|>) f g = Fn.compose g f

let to_matrix (b: string list): cell array array =  
  let to_cell = function
  | 'X' -> Some X
  | 'O' -> Some O
  | '.'  -> Some Empty
  | _ -> None in
  List.map b ~f:(String.to_list >|> List.filter_map ~f:to_cell >|> Array.of_list) |> Array.of_list

let neighbouring_positions rows cols (r, c): (int * int) list = 
  let deltas = [
          -1,0; -1,1;
     0,-1;       0,1;
     1,-1; 1,0;
  ] in
  List.filter_map deltas ~f:(fun (dr, dc) -> 
    if r + dr < 0 || r + dr >= rows || c + dc < 0 || c + dc >= cols 
    then None 
    else Some (r+dr, c+dc)
  )

let neighbours board rows cols (r,c) =
  let cell = board.(r).(c) in
  let positions = neighbouring_positions rows cols (r,c) in
  List.filter positions ~f:(fun (r1,c1) -> eq_cell cell board.(r1).(c1))

let search successors initial ~matches = 
  let rec go visited node = 
    if matches node then (true, visited)
    else 
    if not (Set.mem visited node) then
      begin
        let visited = Set.add visited node in
        let successor_nodes = successors node in
        if List.is_empty successor_nodes 
        then (false, visited)
        else 
          List.fold_left successor_nodes 
            ~f:(fun (fnd, v) n -> if fnd then (true, v) else go v n) 
            ~init:(false, visited)
      end
    else (false, visited)
  in
  Array.exists initial ~f:(go emptyIntIntSet >|> fst)

let connect board: player option = 
  let board = to_matrix board in
  let rows = Array.length board in
  let cols = Array.length board.(0) in
  let search = search (neighbours board rows cols) in
  let initials_x = Array.filter_mapi board ~f:(fun row cell -> if eq_cell cell.(0) X then Some (row, 0) else None) in
  if search initials_x ~matches:(fun (r,c) -> (c = cols - 1) && eq_cell board.(r).(c) X)
  then Some X
  else 
  begin
    let initials_o = Array.filter_mapi board.(0) ~f:(fun col cell -> if eq_cell cell O then Some (0, col) else None) in
    if search initials_o ~matches:(fun (r,c) -> (r = rows - 1) && eq_cell board.(r).(c) O)
      then Some O
      else None 
  end