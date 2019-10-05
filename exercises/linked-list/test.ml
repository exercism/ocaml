open Base
open OUnit2
open Linked_list

let ae exp got _test_ctxt =
  assert_equal ~printer:Int.to_string exp got

let test1 = 
  let l = empty () in
  push 10 l;
  push 20 l;
  let v1 = pop l in
  let v2 = pop l in 
  ["add/extract elements to the end of the list with push/pop" >:: ae 20 v1;
  "add/extract elements to the end of the list with push/pop" >:: ae 10 v2]

let test2 = 
  let l = empty () in
  push 10 l;
  push 20 l;
  let v1 = shift l in
  let v2 = shift l in 
  ["extract elements from the beginning of the list with shift" >:: ae 10 v1;
  "extract elements from the beginning of the list with shift" >:: ae 20 v2]

let test3 = 
  let l = empty () in
  unshift 10 l;
  unshift 20 l;
  let v1 = shift l in
  let v2 = shift l in 
  ["add/extract elements from the beginning of the list with unshift/shift" >:: ae 20 v1;
  "add/extract elements from the beginning of the list with unshift/shift" >:: ae 10 v2]

let test4 = 
  let l = empty () in
  unshift 10 l;
  unshift 20 l;
  let v1 = pop l in
  let v2 = pop l in 
  ["add/extract elements from the beginning of the list with unshift/shift" >:: ae 10 v1;
  "add/extract elements from the beginning of the list with unshift/shift" >:: ae 20 v2]

let test5 = 
  let l = empty () in
  push 10 l;
  push 20 l;
  let v1 = pop l in
  push 30 l;
  let v2 = shift l in 
  unshift 40 l;
  push 50 l;
  let v3 = shift l in
  let v4 = pop l in
  let v5 = shift l in
  ["example" >:: ae 20 v1;
  "example" >:: ae 10 v2;
  "example" >:: ae 40 v3;
  "example" >:: ae 50 v4;
  "example" >:: ae 30 v5]

let test6 =
  let l = empty () in
  let v1 = count l in
  push 10 l;
  let v2 = count l in
  push 20 l;
  let v3 = count l in
  ["can count its elements" >:: ae 0 v1;
  "can count its elements" >:: ae 1 v2;
  "can count its elements" >:: ae 2 v3]

let test7 = 
  let l = empty () in
  push 10 l;
  let _ = pop l in
  unshift 20 l;
  let v1 = count l in
  let v2 = pop l in
  ["sets head/tail after popping last element" >:: ae 1 v1;
  "sets head/tail after popping last element" >:: ae 20 v2]

let test8 = 
  let l = empty () in
  unshift 10 l;
  let _ = shift l in
  push 20 l;
  let v1 = count l in
  let v2 = shift l in
  ["sets head/tail after shifting last element" >:: ae 1 v1;
  "sets head/tail after shifting last element" >:: ae 20 v2]

let tests = 
  test1 @ test2 @ test3 @ test4 @ test5 @ test6 @ test7 @ test8 

let () =
  run_test_tt_main ("linked-list tests" >::: tests)
