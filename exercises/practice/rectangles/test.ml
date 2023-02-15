open OUnit2
open Rectangles

let ae exp got _test_ctxt = assert_equal exp got ~printer:string_of_int

let tests = [
  "no rows" >::
  ae 0 (count_rectangles [||]);
  "no columns" >::
  ae 0 (count_rectangles [|""|]);
  "no rectangles" >::
  ae 0 (count_rectangles [|" "|]);
  "one rectangle" >::
  ae 1 (count_rectangles [|
      "+-+";
      "| |";
      "+-+";
    |]);
  "two rectangles without shared parts" >::
  ae 2 (count_rectangles [|
      "  +-+";
      "  | |";
      "+-+-+";
      "| |  ";
      "+-+  ";
    |]);
  "five rectangles with shared parts" >::
  ae 5 (count_rectangles [|
      "  +-+";
      "  | |";
      "+-+-+";
      "| | |";
      "+-+-+";
    |]);
  "rectangle of height 1 is counted" >::
  ae 1 (count_rectangles [|
      "+--+";
      "+--+";
    |]);
  "rectangle of width 1 is counted" >::
  ae 1 (count_rectangles [|
      "++";
      "||";
      "++";
    |]);
  "1x1 square is counted" >::
  ae 1 (count_rectangles [|
      "++";
      "++";
    |]);
  "only complete rectangles are counted" >::
  ae 1 (count_rectangles [|
      "  +-+";
      "    |";
      "+-+-+";
      "| | -";
      "+-+-+";
    |]);
  "rectangles can be of different sizes" >::
  ae 3 (count_rectangles [|
      "+------+----+";
      "|      |    |";
      "+---+--+    |";
      "|   |       |";
      "+---+-------+";
    |]);
  "corner is required for a rectangle to be complete" >::
  ae 2 (count_rectangles [|
      "+------+----+";
      "|      |    |";
      "+------+    |";
      "|   |       |";
      "+---+-------+";
    |]);
  "large input with many rectangles" >::
  ae 60 (count_rectangles [|
      "+---+--+----+";
      "|   +--+----+";
      "+---+--+    |";
      "|   +--+----+";
      "+---+--+--+-+";
      "+---+--+--+-+";
      "+------+  | |";
      "          +-+";
    |]);
  "rectangles must have four sides" >::
  ae 5 (count_rectangles [|
      "+-+ +-+";
      "| | | |";
      "+-+-+-+";
      "  | |  ";
      "+-+-+-+";
      "| | | |";
      "+-+ +-+";
    |]);
]

let () =
  run_test_tt_main ("rectangles tests" >::: tests)
