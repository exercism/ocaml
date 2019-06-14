type 'a cell
type callback_id

let create_input_cell ~value ~eq =
    failwith "'create_input_cell' is missing"

let value_of _ =
    failwith "'value_of' is missing"

let set_value _ =
    failwith "'set_value' is missing"

let create_compute_cell_1 _ ~f ~eq =
    failwith "'create_compute_cell_1' is missing"

let create_compute_cell_2 _ _ ~f ~eq =
    failwith "'create_compute_cell_2' is missing"

let add_callback _ ~k =
    failwith "'add_callback' is missing"

let remove_callback _ _ =
    failwith "'remove_callback' is missing"
