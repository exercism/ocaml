open Base
open OUnit2

module L = List_ops

let aei exp got _test_ctxt = assert_equal ~printer:Int.to_string exp got

let ael exp got _test_ctxt =
  assert_equal exp got ~printer:(fun xs -> String.concat ~sep:";" (List.map ~f:Int.to_string xs)) 

let is_odd n = n % 2 = 1

let tests = [
  "length of empty list">::
  aei 0 (L.length []);
  "length of normal list">::
  aei 4 (L.length [1;3;5;7]);
  "reverse of empty list">::
  ael [] (L.reverse []);
  "reverse of normal list">::
  ael [7;5;3;1] (L.reverse [1;3;5;7]);
  "map of empty list">::
  ael [] (L.map ~f:((+) 1) []);
  "map of normal list">::
  ael [2;4;6;8] (L.map ~f:((+) 1) [1;3;5;7]);
  "filter of empty list">::
  ael [] (L.filter ~f:is_odd []);
  "filter of normal list">::
  ael [1;3] (L.filter ~f:is_odd [1;2;3;4]);
  "fold of empty list">::
  aei 0 (L.fold ~init:0 ~f:(+) []);
  "fold of normal list">::
  aei 7 (L.fold ~init:(-3) ~f:(+) [1;2;3;4]);
  "append of empty lists">::
  ael [] (L.append [] []);
  "append of empty and non-empty list">::
  ael [1;2;3;4] (L.append [] [1;2;3;4]);
  "append of non-empty and empty list">::
  ael [1;2;3;4] (L.append [1;2;3;4] []);
  "append of non-empty lists">::
  ael [1;2;3;4;5] (L.append [1;2;3] [4;5]);
  "concat of empty list of lists">::
  ael [] (L.concat []);
  "concat of normal list of lists">::
  ael [1;2;3;4;5;6] (L.concat [[1;2];[3];[];[4;5;6]]);
]

let () =
  run_test_tt_main ("list-ops tests" >::: tests)
