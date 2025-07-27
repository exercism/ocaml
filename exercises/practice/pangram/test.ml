open OUnit2
open Pangram

let ae exp got _test_ctxt = assert_equal ~printer:string_of_bool exp got

let tests = [
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
  "empty sentence" >::
  ae false (is_pangram "");
  "perfect lower case" >::
  ae true (is_pangram "abcdefghijklmnopqrstuvwxyz");
  "only lower case" >::
  ae true (is_pangram "the quick brown fox jumps over the lazy dog");
  "missing the letter 'x'" >::
  ae false (is_pangram "a quick movement of the enemy will jeopardize five gunboats");
  "missing the letter 'h'" >::
  ae false (is_pangram "five boxing wizards jump quickly at it");
  "with underscores" >::
  ae true (is_pangram "the_quick_brown_fox_jumps_over_the_lazy_dog");
  "with numbers" >::
  ae true (is_pangram "the 1 quick brown fox jumps over the 2 lazy dogs");
  "missing letters replaced by numbers" >::
  ae false (is_pangram "7h3 qu1ck brown fox jumps ov3r 7h3 lazy dog");
  "mixed case and punctuation" >::
  ae true (is_pangram "\"Five quacking Zephyrs jolt my wax bed.\"");
  "a-m and A-M are 26 different characters but not a pangram" >::
  ae false (is_pangram "abcdefghijklm ABCDEFGHIJKLM");
]

let () =
  run_test_tt_main ("pangram tests" >::: tests)
