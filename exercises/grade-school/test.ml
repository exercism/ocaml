open Core
open OUnit2

module IMap = Int.Map

let assert_list_equals exp got = 
  let printer l = List.sexp_of_t String.sexp_of_t l
                  |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~printer

let assert_map_equals exp got =
  let printer m = 
      Map.to_alist m
      |> List.sort ~cmp:compare
      |> List.sexp_of_t (Tuple2.sexp_of_t Int.sexp_of_t (List.sexp_of_t String.sexp_of_t))
      |> Sexp.to_string_hum ~indent:1 in
  assert_equal exp got ~cmp:(Map.equal (=)) ~printer

let tests =
  ["add student">:: (fun _ ->
       let got = Grade_school.empty_school
                 |> Grade_school.add "Aimee" 2 in
       assert_map_equals (IMap.of_alist_exn [(2, ["Aimee"])])
           (Grade_school.to_map got));
   "add more students in sassert_map_equals class">:: (fun _ ->
       let got = Grade_school.empty_school
                 |> Grade_school.add "Jassert_map_equalss" 2
                 |> Grade_school.add "Blair" 2
                 |> Grade_school.add "Paul" 2 in
       assert_map_equals (IMap.of_alist_exn [(2, ["Blair"; "Jassert_map_equalss"; "Paul"])])
           (Grade_school.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "add students to different grades">:: (fun _ ->
       let got = Grade_school.empty_school
                 |> Grade_school.add "Chelsea" 3
                 |> Grade_school.add "Logan" 7 in
       assert_map_equals (IMap.of_alist_exn [(3, ["Chelsea"]); (7, ["Logan"])])
           (Grade_school.to_map got |> Map.map ~f:(List.sort ~cmp:compare)));
   "get students in a grade">:: (fun _ ->
       let got = Grade_school.empty_school
                 |> Grade_school.add "Franklin" 5
                 |> Grade_school.add "Bradley" 5
                 |> Grade_school.add "Jeff" 1
                 |> Grade_school.grade 5 in
       assert_list_equals ["Bradley"; "Franklin"]
           (List.sort ~cmp:compare got));
   "get students in a non existant grade">:: (fun _ ->
       assert_list_equals [] (List.sort ~cmp:compare (Grade_school.empty_school |> Grade_school.grade 2)));
   "sort school">:: (fun _ ->
       let got = Grade_school.empty_school
                 |> Grade_school.add "Christopher" 4
                 |> Grade_school.add "Jennifer" 4
                 |> Grade_school.add "Aaron" 4
                 |> Grade_school.add "Kareem" 6
                 |> Grade_school.add "Kyle" 3
                 |> Grade_school.sort in
       assert_map_equals (IMap.of_alist_exn [(3, ["Kyle"]);
                               (4, ["Aaron"; "Christopher"; "Jennifer"]);
                               (6, ["Kareem"])])
           (Grade_school.to_map got));
  ]

let () =
  run_test_tt_main ("grade-school tests" >::: tests)
