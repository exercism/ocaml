open Base
open Knapsack
open OUnit2

let ae exp got _test_ctxt = assert_equal exp got ~printer:(Int.to_string)

let tests = [
  "no items" >::
  ae 0 (Knapsack.maximum_value [] 100);
  "one item, too heavy" >::
  ae 0 (Knapsack.maximum_value [{weight = 100; value = 1}] 10);
  "five items (cannot be greedy by weight)" >::
  ae 21 (Knapsack.maximum_value
           [{weight = 2; value = 5};
            {weight = 2; value = 5};
            {weight = 2; value = 5};
            {weight = 2; value = 5};
            {weight = 10; value = 21}]
           10);
  "five items (cannot be greedy by value)" >::
  ae 80 (Knapsack.maximum_value
           [{weight = 2; value = 20};
            {weight = 2; value = 20};
            {weight = 2; value = 20};
            {weight = 2; value = 20};
            {weight = 10; value = 50}]
           10);
  "example knapsack" >::
  ae 90 (Knapsack.maximum_value
           [{weight = 5; value = 10};
            {weight = 4; value = 40};
            {weight = 6; value = 30};
            {weight = 4; value = 50}]
           10);
  "8 items" >::
  ae 900 (Knapsack.maximum_value
            [{weight = 25; value = 350};
             {weight = 35; value = 400};
             {weight = 45; value = 450};
             {weight = 5; value = 20};
             {weight = 25; value = 70};
             {weight = 3; value = 8};
             {weight = 2; value = 5};
             {weight = 2; value = 5}]
            104);
  "15 items" >::
  ae 1458 (Knapsack.maximum_value
             [{weight = 70; value = 135};
              {weight = 73; value = 139};
              {weight = 77; value = 149};
              {weight = 80; value = 150};
              {weight = 82; value = 156};
              {weight = 87; value = 163};
              {weight = 90; value = 173};
              {weight = 94; value = 184};
              {weight = 98; value = 192};
              {weight = 106; value = 201};
              {weight = 110; value = 210};
              {weight = 113; value = 214};
              {weight = 115; value = 221};
              {weight = 118; value = 229};
              {weight = 120; value = 240}]
             750);
]

let () =
  run_test_tt_main ("knapsack tests" >::: tests)
