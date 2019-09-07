open Base
open Stdio
open OUnit2
open Generator
open Generator.Parser
open Generator.Model

let printer (r: (Model.tests, Parser.error) Result.t): string = match r with
| Ok tests -> tests_to_string tests
| Error _ -> "error"

let ae (exp: (Model.tests, Parser.error) Result.t) (got: (Model.tests, Parser.error) Result.t) _test_ctxt = assert_equal exp got ~printer

let single x = Ok (Single x)

let call_parser json = parse_json_text json "cases" |> Result.map ~f:(fun c -> c.tests)

let parser_tests = [
  "gives an error with a json map that does not have the key cases in" >::
    ae (Error (TestMustHaveKeyCalledCases "cases"))
       (call_parser "{\"case\" : [{\"description\" : \"d1\", \"property\" : \"p1\", \"expected\" : 100}]}");

  "gives an error with cases that is not a json list" >::
    ae (Error ExpectingListOfCases)
       (call_parser "{\"cases\" : 11}");

  "gives an error with a case that is not a json map" >::
    ae (Error ExpectingMapForCase)
       (call_parser "{\"cases\" : [\"key\"]}");

  "parses a single element with a description and expected string output" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `String "value")]}])
       (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : \"value\"}]}");

  "parses a single element with a description and expected float output" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Float 100.)]}])
       (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : 100.0}]}");

  "parses a single element with a description and expected bool output" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Bool true)];}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : true}]}");

  "parses a single element with a description and expected int list output" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `List [`Int 1;`Int 2;`Int 3])]}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : [1, 2, 3]}]}");

  "parses a single element with a description and expected null output" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Null)]}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : null}]}");

  "parses a single element with an int key value pair" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Bool true); ("year", `Int 1996)]}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\": { \"year\" : 1996 }, \"expected\" : true}]}");

  "parses a single element with a string key value pair" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Int 85); ("string", `String "some-string")]}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\": { \"string\" : \"some-string\" }, \"expected\" : 85}]}");

  "parses a single element with a string list key value pair" >::
    ae (single [{description = "d1"; property = "p1"; parameters = [("expected", `Int 85); ("list", `List [`String "s1"; `String "s2"])]}])
      (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : { \"list\" : [\"s1\", \"s2\"] }, \"expected\" : 85}]}");

  "an element without a description is an Error" >::
    ae (Error NoDescription)
      (call_parser "{\"cases\" : [{\"input\" : 11, \"expected\" : 85}]}");

  "an element with a description which is an int is an Error" >::
    ae (Error BadDescription)
      (call_parser "{\"cases\" : [{\"description\" : 1, \"property\": \"p1\", \"input\" : 11, \"expected\" : 85}]}");

  "an element without description is an Error" >::
    ae (Error NoDescription)
      (call_parser "{\"cases\" : [{\"input\" : 11}]}");

  "parses a map in the expected parameter" >::(fun _ctx ->
      assert_equal (single [{description = "d1"; property = "p1"; parameters = [("expected", `Assoc [("one", `Int 1); ("two", `Int 2)])]}])
        (call_parser "{\"cases\" : [{\"description\" : \"d1\", \"property\": \"p1\", \"input\" : {}, \"expected\" : {\"one\": 1, \"two\": 2}}]}");
      );

  "parses leap.json" >::(fun _ctxt ->
      match call_parser @@ In_channel.read_all "fixtures/leap.json" with
      | Ok (Single p) -> assert_equal 4 (List.length p)
      | Ok (Suite _) -> assert_failure "was suite"
      | Error e -> assert_failure ("failed to parse leap.json: " ^ show_error e)
  );

  "parses hello_world.json which has a # element as documentation" >::(fun _ctxt ->
      match call_parser @@ In_channel.read_all "fixtures/hello_world.json" with
      | Ok (Single _) -> ()
      | Ok (Suite _) -> assert_failure "was suite"
      | Error e -> assert_failure ("failed to parse hello_world.json: " ^ show_error e)
    );

  "parses difference_of_squares.json" >::(fun _ctxt ->
      match call_parser @@ In_channel.read_all "fixtures/difference_of_squares.json" with
      | Ok (Suite p) -> assert_equal [
        "square_the_sum_of_the_numbers_up_to_the_given_number"; 
        "sum_the_squares_of_the_numbers_up_to_the_given_number"; 
        "subtract_sum_of_squares_from_square_of_sums"] (List.map ~f:(fun x -> x.name) p)
      | Ok (Single _) -> assert_failure "was single"
      | Error e -> assert_failure ("failed to parse difference_of_squares.json: " ^ show_error e)
    );

  "parses nested json in beer-song by dropping intermediate nesting levels" >::(fun _ctxt ->
      match call_parser @@ In_channel.read_all "fixtures/beer-song.json" with
      | Ok (Suite p) -> assert_equal [
        "verse"; 
        "lyrics"] (List.map ~f:(fun x -> x.name) p)
      | Ok (Single _) -> assert_failure "was single"
      | Error e -> assert_failure ("failed to parse beer-song.json: " ^ show_error e)
    );

  "parses json with a methods key for dynamic languages" >::(fun _ctxt ->
      match call_parser @@ In_channel.read_all "fixtures/with-methods-key.json" with
      | Ok (Suite _) -> assert_failure "was suite"
      | Ok (Single _) -> ()
      | Error e -> assert_failure ("failed to parse with-methods-key.json: " ^ show_error e)
    );
]
