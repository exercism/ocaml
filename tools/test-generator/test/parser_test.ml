open Core.Std
open OUnit2
open Parser
open Model

let show_cases = function
  | Ok (Single cs) -> List.map ~f:show_case cs |> String.concat
  | Ok (Suite cs) -> failwith "no printer"
  | Error e -> show_error e

let ae exp got _test_ctxt = assert_equal exp got ~printer:show_cases

let single x = Ok (Single x)

let parser_tests = [
  "parses empty json as empty list" >::
    ae (single []) (parse_json_text "{\"cases\" : []}");

  "gives an error with a json map that does not have the key cases in" >::
    ae (Error UnrecognizedJson)
       (parse_json_text "{\"case\" : [{\"description\" : \"d1\", \"expected\" : 100}]}");

  "gives an error with cases that is not a json list" >::
    ae (Error ExpectingListOfCases)
       (parse_json_text "{\"cases\" : 11}");

  "gives an error with a case that is not a json map" >::
    ae (Error ExpectingMapForCase)
       (parse_json_text "{\"cases\" : [\"key\"]}");

  "parses a single element with a description and expected string output" >::
    ae (single [{description = "d1"; parameters = []; expected = String "value"}])
       (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"expected\" : \"value\"}]}");

  "parses a single element with a description and expected float output" >::
    ae (single [{description = "d1"; parameters = []; expected = Float 100.}])
       (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"expected\" : 100.0}]}");

  "parses a single element with a description and expected bool output" >::
    ae (single [{description = "d1"; parameters = []; expected = Bool true}])
      (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"expected\" : true}]}");

  "parses a single element with an int key value pair" >::
    ae (single [{description = "d1"; parameters = [("input", Int 1996)]; expected = Bool true}])
      (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"input\" : 1996, \"expected\" : true}]}");

  "parses a single element with a string key value pair" >::
    ae (single [{description = "d1"; parameters = [("input", String "some-string")]; expected = Int 85}])
      (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"input\" : \"some-string\", \"expected\" : 85}]}");

  "parses a single element with a string list key value pair" >::
    ae (single [{description = "d1"; parameters = [("input", StringList ["s1"; "s2"])]; expected = Int 85}])
      (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"input\" : [\"s1\", \"s2\"], \"expected\" : 85}]}");

  "an element without a description is an Error" >::
    ae (Error BadDescription)
      (parse_json_text "{\"cases\" : [{\"input\" : 11, \"expected\" : 85}]}");

  "an element with a description which is an int is an Error" >::
    ae (Error BadDescription)
      (parse_json_text "{\"cases\" : [{\"description\" : 1, \"input\" : 11, \"expected\" : 85}]}");

  "an element without expected is an Error" >::
    ae (Error BadDescription)
      (parse_json_text "{\"cases\" : [{\"input\" : 11}]}");

  "parses a map in the expected parameter" >::(fun _ctx ->
      assert_equal (single [{description = "d1"; parameters = []; expected = IntStringMap [("one", 1); ("two", 2)]}])
        (parse_json_text "{\"cases\" : [{\"description\" : \"d1\", \"expected\" : {\"one\": 1, \"two\": 2}}]}");
      );

  "parses leap.json" >::(fun ctxt ->
      match parse_json_text @@ In_channel.read_all "test/leap.json" with
      | Ok (Single p) -> assert_equal 7 (List.length p)
      | Ok (Suite p) -> assert_failure "was suite"
      | Error e -> assert_failure ("failed to parse leap.json: " ^ show_error e)
  );

  "parses hello_world.json which has a # element as documentation" >::(fun ctxt ->
      match parse_json_text @@ In_channel.read_all "test/hello_world.json" with
      | Ok (Single p) -> ()
      | Ok (Suite p) -> assert_failure "was suite"
      | Error e -> assert_failure ("failed to parse hello_world.json: " ^ show_error e)
    );

  "parses difference_of_squares.json" >::(fun ctxt ->
      match parse_json_text @@ In_channel.read_all "test/difference_of_squares.json" with
      | Ok (Suite p) -> assert_equal ["square_of_sum"; "sum_of_squares"; "difference_of_squares"] (List.map ~f:(fun x -> x.name) p)
      | Ok (Single p) -> assert_failure "was single"
      | Error e -> assert_failure ("failed to parse difference_of_squares.json: " ^ show_error e)
    );
]
