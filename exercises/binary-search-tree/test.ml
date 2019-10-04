(* binary-search-tree - 1.3.0 *)
open Base
open OUnit2
open Binary_search_tree

let result_to_string f = function
  | Error m -> Printf.sprintf "Error \"%s\"" m
  | Ok x -> f x |> Printf.sprintf "Some %s"

let ae exp got _test_ctxt =
  assert_equal ~printer:(result_to_string Int.to_string) exp got

let intlist_to_string l = 
  List.map l ~f:Int.to_string
  |> List.intersperse ~sep:"; "
  |> List.fold ~init:"" ~f:(^) 
  |> fun s -> "[" ^ s ^ "]"

let ael exp got _test_ctxt =
  assert_equal ~printer:intlist_to_string exp got

let tests = 
  let t4 = empty |> insert 4 in 
  let t42 = t4 |> insert 2 in  
  let l2 =  t42 |> left in  
  let t44 = t4 |> insert 4 in 
  let l4 =  t44 |> left in 
  let t45 = t4 |> insert 5 in
  let r5 = t45 |> right in  
  let t4261357 = t42 |> insert 6 |> insert 1 |> insert 3 |> insert 5 |> insert 7 in
  let t2 = empty |> insert 2 in
  let t21 = t2 |> insert 1 in
  let t22 = t2 |> insert 2 in
  let t23 = t2 |> insert 3 in
  let t213675 = t21 |> insert 3 |> insert 6 |> insert 7 |> insert 5 in
  [
    "data is retained" >:: ae (Ok 4) (value t4);
    "smaller number at left node 1" >:: ae (Ok 4) (value t42);
    "smaller number at left node 2" >:: ae (Ok 2) (Result.bind l2 ~f:value);
    "same number at left node 1" >:: ae (Ok 4) (value t44);
    "same number at left node 2" >:: ae (Ok 4) (Result.bind l4 ~f:value);
    "greater number at right node 1" >:: ae (Ok 4) (value t45);
    "greater number at right node 2" >:: ae (Ok 5) (Result.bind r5 ~f:value);
    "can create complex tree 1" >:: ae (Ok 4) (value t4261357);
    "can create complex tree 2" >:: ae (Ok 2) (Result.bind (t4261357 |> left) ~f:value);
    "can create complex tree 3" >:: ae (Ok 1) (Result.bind (Result.bind (t4261357 |> left) ~f:left) ~f:value);
    "can create complex tree 4" >:: ae (Ok 3) (Result.bind (Result.bind (t4261357 |> left) ~f:right) ~f:value);
    "can create complex tree 5" >:: ae (Ok 6) (Result.bind (t4261357 |> right) ~f:value);
    "can create complex tree 6" >:: ae (Ok 5) (Result.bind (Result.bind (t4261357 |> right) ~f:left) ~f:value);
    "can create complex tree 7" >:: ae (Ok 7) (Result.bind (Result.bind (t4261357 |> right) ~f:right) ~f:value);
    "can sort single number" >:: ael [2] (to_list t2);
    "can sort if second number is smaller than first" >:: ael [1;2] (to_list t21);
    "can sort if second number is same as first" >:: ael [2;2] (to_list t22);
    "can sort if second number is greater than first" >:: ael [2;3] (to_list t23);
    "can sort complex tree" >:: ael [1; 2; 3; 5; 6; 7] (to_list t213675);
  ]

let () =
  run_test_tt_main ("binary-search-tree tests" >::: tests)
