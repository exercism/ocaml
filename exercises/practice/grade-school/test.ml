(* grade-school - 1.0.0 *)
open OUnit2
open Grade_school

let assert_lists_equal exp got _ctx =
  let printer = String.concat ";" in
  assert_equal exp got ~printer

let tests = [
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  "Adding a student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Aimee" 2 in
    assert_lists_equal ["Aimee"] (roster school)
  );
  "Adding more student adds them to the sorted roster" >:: (
    let school = empty_school |> add "Blair" 2 |> add "James" 2 |> add "Paul" 2 in
    assert_lists_equal ["Blair"; "James"; "Paul"] (roster school)
  );
  "Adding students to different grades adds them to the same sorted roster" >:: (
    let school = empty_school |> add "Chelsea" 3 |> add "Logan" 7 in
    assert_lists_equal ["Chelsea"; "Logan"] (roster school)
  );
  "Roster returns an empty list if there are no students enrolled" >:: (
    let school = empty_school in
    assert_lists_equal [] (roster school)
  );
  "Student names with grades are displayed in the same sorted roster" >:: (
    let school = empty_school
                 |> add "Peter" 2
                 |> add "Anna" 1
                 |> add "Barb" 1
                 |> add "Zoe" 2
                 |> add "Alex" 2
                 |> add "Jim" 3
                 |> add "Charlie" 1 in
    assert_lists_equal ["Anna"; "Barb"; "Charlie"; "Alex"; "Peter"; "Zoe"; "Jim"] (roster school)
  );
  "Grade returns the students in that grade in alphabetical order" >:: (
    let school = empty_school |> add "Franklin" 5 |> add "Bradley" 5 |> add "Jeff" 1 in
    assert_lists_equal ["Bradley"; "Franklin"] (grade 5 school)
  );
  "Grade returns an empty list if there are no students in that grade" >:: (
    let school = empty_school in
    assert_lists_equal [] (grade 1 school)
  );
  (* "an empty school has no children in grade 1" >::
     assert_lists_equal [] (grade 1 empty_school);
     "an empty school has Emma in grade 1 after she's been added to grade 1" >::(
     let s = add "Emma" 1 empty_school in
     assert_lists_equal ["Emma"] (grade 1 s)
     );
     "an empty school does not have Emma in grade 1 after she's been added to grade 2" >::(
     let s = add "Emma" 2 empty_school in
     assert_lists_equal [] (grade 1 s)
     );
     "an empty school has Emma, Timmy, Bob and Becky in grade 1 after they've been added to grade 1" >::(
     let s = empty_school |> add "Emma" 1 |> add "Timmy" 1 |> add "Bob" 1 |> add "Becky" 1 in
     assert_lists_equal ["Becky"; "Bob"; "Emma"; "Timmy"] (grade 1 s |> List.sort compare)
     );
     "a sorted school has Emma, Timmy, Bob and Becky in grade 1 in sorted order" >::(
     let s = empty_school |> add "Emma" 1 |> add "Timmy" 1 |> add "Bob" 1 |> add "Becky" 1 |> sorted in
     assert_lists_equal ["Becky"; "Bob"; "Emma"; "Timmy"] (grade 1 s)
     ); *)
]

let () =
  run_test_tt_main ("grade-school tests" >::: tests)
