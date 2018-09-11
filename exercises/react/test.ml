open Base
open OUnit2
open React

let ae exp got =
  assert_equal exp got ~printer:Int.to_string

let assert_list_eq exp got =
  let printer xs = List.sexp_of_t Int.sexp_of_t xs |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~printer

let create_int_input_cell = create_input_cell ~eq:Int.equal
let create_compute_cell_1 = create_compute_cell_1 ~eq:Int.equal
let create_compute_cell_2 = create_compute_cell_2 ~eq:Int.equal

let tests = [
  "creating an input cell with value then asking for its value returns the same value" >:: (fun _ctx ->
    let cell = create_int_input_cell ~value:10 in
    ae 10 (value_of cell)
  );
  "setting an input cell with a new value then asking for its value returns the new value" >:: (fun _ctx ->
    let cell = create_int_input_cell ~value:10 in
    set_value cell 20;
    ae 20 (value_of cell)
  );
  "compute cells calculate from an initial value" >:: (fun _ctx ->
    let cell = create_int_input_cell ~value:1 in
    let computed = create_compute_cell_1 cell ~f:Int.succ in
    ae 2 (value_of computed)
  );
  "compute cells take inputs in the right order" >:: (fun _ctx ->
    let one = create_int_input_cell ~value:1 in
    let two = create_int_input_cell ~value:2 in
    let computed = create_compute_cell_2 one two ~f:(fun x y -> x + 10 * y) in
    ae 21 (value_of computed)
  );
  "compute cells update value when dependencies are changed" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1 in
    let computed = create_compute_cell_1 input ~f:Int.succ in
    set_value input 3;
    ae 4 (value_of computed)
  );
  "compute cells can depend on other compute cells" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1  in
    let times_two = create_compute_cell_1 input ~f:(fun x -> x * 2) in
    let times_thirty = create_compute_cell_1 input ~f:(fun x -> x * 30) in
    let computed = create_compute_cell_2 times_two times_thirty ~f:(+) in
    
    ae 32 (value_of computed);
    set_value input 3;
    ae 96 (value_of computed)
  );
  "compute cells fire callbacks" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1 in
    let output = create_compute_cell_1 input ~f:Int.succ in
    let record = ref [] in
    ignore @@ add_callback output ~k:(fun x -> record := x :: !record);
    
    set_value input 3;
    assert_list_eq [4] !record
  );
  "input cells do not fire if no change" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:2 in
    let record = ref [] in
    ignore @@ add_callback input ~k:(fun x -> record := x :: !record);
    
    set_value input 2;

    assert_list_eq [] !record;
  );
  "compute cells do not fire if no change" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:2 in
    let output = create_compute_cell_1 input ~f:(fun x -> if x < 3 then 111 else 222) in
    let record = ref [] in
    ignore @@ add_callback output ~k:(fun x -> record := x :: !record);
    
    set_value input 1;
    assert_list_eq [] !record;

    set_value input 1;
    assert_list_eq [] !record;
  );
  "callback cells do not fire if no change on two calls to set_value" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:2 in
    let output = create_compute_cell_1 input ~f:(fun x -> if x < 3 then 111 else 222) in
    let record = ref [] in
    ignore @@ add_callback output ~k:(fun x -> record := x :: !record);
    
    set_value input 2;
    set_value input 2;
    assert_list_eq [] !record;
  );
  "uses the provided eq function to determine if a cell value has changed" >:: (fun _ctx ->
    let called_eq = ref false in
    let input = create_input_cell ~value:2 ~eq:(fun _ _ -> called_eq := true; false) in
    
    set_value input 2;
    assert_bool "should call eq" !called_eq;
  );
  "callbacks can be added and removed" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:2 in
    let output = create_compute_cell_1 input ~f:Fn.id  in
    let called_callback = ref false in
    let cb = add_callback output ~k:(fun _ -> called_callback := true) in
    
    remove_callback output cb;
    set_value input 3;
    
    assert_bool "should not call callback" (not !called_callback);
  );
  "removing a callback multiple times doesn't interfere with other callbacks" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1 in
    let output = create_compute_cell_1 input ~f:Int.succ in
    let callback1_calls = ref [] in
    let callback2_calls = ref [] in
    let cb1 = add_callback output ~k:(fun x -> callback1_calls := x :: !callback1_calls) in
    ignore @@ add_callback output ~k:(fun x -> callback2_calls := x :: !callback1_calls);
    remove_callback output cb1;
    remove_callback output cb1;
    
    set_value input 2;
    
    assert_list_eq [] !callback1_calls;
    assert_list_eq [3] !callback2_calls;
  );
  "callbacks should only be called once even if multiple dependencies change" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1 in
    let plus_one = create_compute_cell_1 input ~f:Int.succ in
    let minus_one1 = create_compute_cell_1 input ~f:Int.pred in
    let minus_one2 = create_compute_cell_1 minus_one1 ~f:Int.pred in
    let output = create_compute_cell_2 plus_one minus_one2 ~f:((fun x y -> x * y)) in
    
    let callback1_calls = ref [] in
    ignore @@ add_callback output ~k:(fun x -> callback1_calls := x :: !callback1_calls);
    set_value input 4;
    
    assert_list_eq [10] !callback1_calls;
  );
  "callbacks should not be called if dependencies change but output value doesn't change" >:: (fun _ctx ->
    let input = create_int_input_cell ~value:1 in
    let plus_one = create_compute_cell_1 input ~f:Int.succ in
    let minus_one1 = create_compute_cell_1 input ~f:Int.pred in
    let always_two = create_compute_cell_2 plus_one minus_one1 ~f:(fun x y -> x - y) in
    
    let callback1_calls = ref [] in
    ignore @@ add_callback always_two ~k:(fun x -> callback1_calls := x :: !callback1_calls);
    set_value input 2;
    set_value input 3;
    set_value input 5;
    
    assert_list_eq [] !callback1_calls;
  );
]

let () =
  run_test_tt_main ("react tests" >::: tests)
