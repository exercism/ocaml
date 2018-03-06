open Core_kernel

type callback_id = int

let latest_callback_id: callback_id ref = ref 0
let latest_cell_id = ref 0

type 'a cell_type = 
  InputCell
| ComputeCell of {one: 'a cell; f: 'a -> 'a;}
| ComputeCell2 of {one: 'a cell; two: 'a cell; f: 'a -> 'a -> 'a;}
and 'a cell = {
  cell_id: int;
  eq: 'a -> 'a -> bool;
  value: 'a ref;
  callbacks: (callback_id, ('a -> unit)) Hashtbl.t; 
  cell_type: 'a cell_type;
  observers: 'a cell list ref;
  }

let next_cell_id () =
  let cell_id = !latest_cell_id in
  latest_cell_id := succ !latest_cell_id;
  cell_id

let apply x f = f x

let callbacks_tbl = Int.Table.create

let value_of {value; _}: 'a = !value

let create_input_cell ~(value: 'a) ~eq = 
  let cell_id = next_cell_id () in
  latest_cell_id := succ !latest_cell_id;
  {
    cell_id;
    eq = eq;
    value = ref value;
    callbacks = callbacks_tbl (); 
    cell_type = InputCell;
    observers = ref [];
  }

let add_callback cell ~k = 
  let id = !latest_callback_id in
  Hashtbl.set cell.callbacks ~key:id ~data:k;
  latest_callback_id := succ id;
  id
  
let remove_callback cell id = 
  Hashtbl.remove cell.callbacks id;;

let call_callbacks cell =
  Hashtbl.iter cell.callbacks ~f:(apply !(cell.value));;

let dedup_cells (cells: 'a cell list): 'a cell list = 
  List.dedup_and_sort cells ~compare:(fun c1 c2 -> Int.compare c1.cell_id c2.cell_id)

let update_compute_cell_value (cell: 'a cell) = 
  let computed = match cell.cell_type with
  | ComputeCell {one; f} -> f !(one.value)
  | ComputeCell2 {one; two; f} -> f !(one.value) !(two.value)
  | InputCell -> failwith "cannot call update_compute_cell on an input cell";
  in
  if cell.eq !(cell.value) computed
  then false
  else begin
    cell.value := computed;
    true
  end

let breadth_first_update_compute_cells (cell: 'a cell): 'a cell list =
  let update c = List.filter !(c.observers) ~f:update_compute_cell_value in
  let rec go cells acc =
    let updates = dedup_cells (List.concat_map ~f:update cells) in
    if List.is_empty updates
    then acc
    else go updates (updates @ acc)
  in
  go [cell] [cell]

let set_value (cell: 'a cell) (x: 'a) = match cell.cell_type with
| InputCell -> 
    if not (cell.eq !(cell.value) x)
    then begin
      cell.value := x;
      let cells = breadth_first_update_compute_cells cell |> dedup_cells in
      List.iter cells ~f:call_callbacks;
      ()
    end
| _ -> failwith "cannot set the value of a compute cell";;

let create_compute_cell_1 one ~f ~eq = 
  let callbacks = callbacks_tbl () in
  let value = ref (f !(one.value)) in
  let c = {cell_id = next_cell_id(); value; callbacks; observers = ref []; eq; cell_type = ComputeCell {one; f}} in
  one.observers := c :: !(one.observers);
  c

let create_compute_cell_2 one two ~f ~eq = 
  let callbacks = callbacks_tbl () in
  let value = ref (f !(one.value) !(two.value)) in
  let c = {cell_id = next_cell_id(); value; callbacks; observers = ref []; eq; cell_type = ComputeCell2 {one; two; f}} in
  one.observers := c :: !(one.observers);
  two.observers := c :: !(two.observers);
  c
