open Core.Std
open OUnit2

module IMap = Int.Map

(* Assert list equals *)
let ale exp got = 
  let printer l = List.sexp_of_t String.sexp_of_t l
                  |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~printer

(* Assert map equals *)
let ame exp got =
  let printer m = 
      Map.to_alist m
      |> List.sort ~cmp:compare
      |> List.sexp_of_t (Tuple2.sexp_of_t Int.sexp_of_t (List.sexp_of_t String.sexp_of_t))
      |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~cmp:(Map.equal (=)) ~printer

(* The tests never reuse a school value, so if you like you can use destructive
 * modification (i.e. mutable data structures). For the same reason
 * Grade_school.create takes a unit argument.
 *
 * For those who wonder why the test doesn't use objects, it's to not force
 * the use of objects. You can still use them internally though. 
 *)

let tests =
  ["add student">:: (fun _ ->
       let got = Grade_school.create ()
                 |> Grade_school.add "Aimee" 2 in
       ame (IMap.of_alist_exn [(2, ["Aimee"])])
           (Grade_school.to_map got));
   "add more students in same class">:: (fun _ ->
       let got = Grade_school.create ()
                 |> Grade_school.add "James" 2
                 |> Grade_school.add "Blair" 2
                 |> Grade_school.add "Paul" 2 in
       ame (IMap.of_alist_exn [(2, ["Blair"; "James"; "Paul"])])
           (Grade_school.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "add students to different grades">:: (fun _ ->
       let got = Grade_school.create ()
                 |> Grade_school.add "Chelsea" 3
                 |> Grade_school.add "Logan" 7 in
       ame (IMap.of_alist_exn [(3, ["Chelsea"]); (7, ["Logan"])])
           (Grade_school.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "get students in a grade">:: (fun _ ->
       let got = Grade_school.create ()
                 |> Grade_school.add "Franklin" 5
                 |> Grade_school.add "Bradley" 5
                 |> Grade_school.add "Jeff" 1
                 |> Grade_school.grade 5 in
       ale ["Bradley"; "Franklin"]
           (List.sort ~cmp:compare got));
   "get students in a non existant grade">:: (fun _ ->
       ale [] (List.sort ~cmp:compare (Grade_school.create () |> Grade_school.grade 2)));
   "sort school">:: (fun _ ->
       let got = Grade_school.create ()
                 |> Grade_school.add "Christopher" 4
                 |> Grade_school.add "Jennifer" 4
                 |> Grade_school.add "Aaron" 4
                 |> Grade_school.add "Kareem" 6
                 |> Grade_school.add "Kyle" 3
                 |> Grade_school.sort in
       ame (IMap.of_alist_exn [(3, ["Kyle"]);
                               (4, ["Aaron"; "Christopher"; "Jennifer"]);
                               (6, ["Kareem"])])
           (Grade_school.to_map got));
  ]

let () =
  run_test_tt_main ("grade-school tests" >::: tests)
