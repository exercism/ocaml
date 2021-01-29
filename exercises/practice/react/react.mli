type 'a cell
type callback_id

(* Creates a cell that has a value which does not depend on the value of any other cell. *)
val create_input_cell : value: 'a -> eq: ('a -> 'a -> bool) -> 'a cell

val value_of : 'a cell -> 'a

(* Sets the value of an input cell. Setting the value of a compute cell is not allowed. *)
val set_value : 'a cell -> 'a -> unit

(* Creates a computed cell with one other cell as input, the value of this cell is the value of the input
   with the function f applied to it.
 *)
val create_compute_cell_1 : 'a cell -> f: ('a -> 'a) -> eq: ('a -> 'a -> bool) -> 'a cell

(* Creates a computed cell with two other cells as input, the value of this cell is the value of the inputs
   with the function f applied to them.
 *)
val create_compute_cell_2 : 'a cell -> 'a cell -> f: ('a -> 'a -> 'a) -> eq: ('a -> 'a -> bool) -> 'a cell

(* After this is called, the callback will be called whenever the cell's value is changed. *)
val add_callback : 'a cell -> k: ('a -> unit) -> callback_id

(* After this is called, the callback will be not called on changes to this cell any more. *)
val remove_callback : 'a cell -> callback_id -> unit