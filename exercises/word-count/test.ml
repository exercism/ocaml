open Base
open OUnit2
open Word_count

let ae exp got _test_ctxt =
  let cmp = Map.equal (=) in
  let sexp_of_map = Map.sexp_of_m__t (module String) in
  let printer m = sexp_of_map Int.sexp_of_t m |> Sexp.to_string_hum ~indent:1 in
  assert_equal ((Map.of_alist_exn (module String)) exp) got ~cmp ~printer

let tests = [
  "count one word" >::
  ae [("word", 1)]
    (word_count "word");
  "count one of each word" >::
  ae [("one", 1); ("of", 1); ("each", 1)]
    (word_count "one of each");
  "multiple occurrences of a word" >::
  ae [("one", 1); ("fish", 4); ("two", 1); ("red", 1); ("blue", 1)]
    (word_count "one fish two fish red fish blue fish");
  "handles cramped lists" >::
  ae [("one", 1); ("two", 1); ("three", 1)]
    (word_count "one,two,three");
  "handles expanded lists" >::
  ae [("one", 1); ("two", 1); ("three", 1)]
    (word_count "one,\ntwo,\nthree");
  "ignore punctuation" >::
  ae [("car", 1); ("carpet", 1); ("as", 1); ("java", 1); ("javascript", 1)]
    (word_count "car: carpet as java: javascript!!&@$%^&");
  "include numbers" >::
  ae [("testing", 2); ("1", 1); ("2", 1)]
    (word_count "testing, 1, 2 testing");
  "normalize case" >::
  ae [("go", 3); ("stop", 2)]
    (word_count "go Go GO Stop stop");
  "with apostrophes" >::
  ae [("first", 1); ("don't", 2); ("laugh", 1); ("then", 1); ("cry", 1)]
    (word_count "First: don't laugh. Then: don't cry.");
  "with quotations" >::
  ae [("joe", 1); ("can't", 1); ("tell", 1); ("between", 1); ("large", 2); ("and", 1)]
    (word_count "Joe can't tell between 'large' and large.");
  "multiple spaces not detected as a word" >::
  ae [("multiple", 1); ("whitespaces", 1)]
    (word_count " multiple   whitespaces");
]

let () =
  run_test_tt_main ("word_count tests" >::: tests)
