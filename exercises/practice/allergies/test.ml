(* allergies - 2.0.0 *)
open Base
open Allergies
open OUnit2

(* Pretty-printer for allergen. *)
let print_allergen = function
  | Eggs         -> "Eggs"
  | Peanuts      -> "Peanuts"
  | Shellfish    -> "Shellfish"
  | Strawberries -> "Strawberries"
  | Tomatoes     -> "Tomatoes"
  | Chocolate    -> "Chocolate"
  | Pollen       -> "Pollen"
  | Cats         -> "Cats"

(* Pretty-printer for allergen list. *)
let print_allergens allergens =
  let print_elems = String.concat ~sep:"; " in
  "[ " ^ print_elems (List.map allergens ~f:print_allergen) ^ " ]"

(* Pretty-printer for single (allergen, score) pair. *)
let print_allergen_score (allergen, score) =
  "(" ^ print_allergen allergen ^ ", " ^ Int.to_string score ^ ")"

(* Pretty-printer for (allergens, score) pair, where allergens is a list. *)
let print_allergens_score (allergens, score) =
  "(" ^ print_allergens allergens ^ ", " ^ Int.to_string score ^ ")"

let allergenScores =
  [ (Eggs,           1)
  ; (Peanuts,        2)
  ; (Shellfish,      4)
  ; (Strawberries,   8)
  ; (Tomatoes,      16)
  ; (Chocolate,     32)
  ; (Pollen,        64)
  ; (Cats,         128)
  ]

(* QCheck generator for (allergen, score) pair. *)
let allergen_gen = QCheck.Gen.oneofl allergenScores

(* QCheck generator for all allergens except `allergens`. *)
let complements allergens =
  List.filter_map allergenScores ~f:(fun (allergen, _) ->
      if List.exists allergens ~f:(Poly.equal allergen)
      then None else Some allergen)

(* QCheck generator for (complement, score) pair where `complement` is an
   arbitrary allergen that isn't contained in `score`. *)
let allergen_complement_gen = QCheck.Gen.(
    allergen_gen                    >>= fun (allergen, score) ->
    oneofl (complements [allergen]) >>= fun complement ->
    return (complement, score))

(* Combinator like `QCheck.Gen.oneofl` that generates an arbitrary sublist
   of its input. For each `x` in `xs` of `manyofl xs`, include `x` with a
   50% probability. *)
let rec manyofl =
  QCheck.Gen.(
    function
    | []    -> return []
    | x::xs -> bool >>= function
      | true  -> map (List.cons x) (manyofl xs)
      | false -> manyofl xs)

(* QCheck generator for (allergens, score) pair, where allergens is a list. *)
let allergens_gen =
  let sum = List.fold ~init:0 ~f:(+) in
  QCheck.Gen.(map List.unzip (manyofl allergenScores) >>=
              (fun (allergens, scores) -> return (allergens, sum scores)))

(* Pretty-printer of `allergic_to` failure. *)
let print_allergic_to_fail exp act (allergen, score) =
  "Failed the call `allergic_to " ^ Int.to_string score ^ " " ^ print_allergen allergen ^ "`:\n"
  ^ "  Expected: " ^ exp ^ "\n"
  ^ "  Actual:   " ^ act ^ "\n"

(* Property: `allergic_to score allergen` works for every mapping. *)
let prop_allergic_to_single_allergens =
  QCheck.Test.make ~count:1000 ~name:"prop_allergic_to_single_allergens"
    (QCheck.make allergen_gen ~print:(print_allergic_to_fail "true" "false"))
    (fun (allergen, score) -> allergic_to score allergen)

(* Negative property: `allergic_to score allergen` fails for every `score`
   that represents a single allergen when `allergen` isn't that allergen. *)
let prop_allergic_to_negative_single_allergens =
  QCheck.Test.make ~count:1000 ~name:"prop_allergic_to_negative_single_allergens"
    (QCheck.make allergen_complement_gen ~print:(print_allergic_to_fail "false" "true"))
    (fun (complement_allergen, score) -> not (allergic_to score complement_allergen))

(* Property: `allergic_to score allergen` succeeds for every `allergen` that
   is represented in `score`. *)
let prop_allergic_to_multiple_allergens =
  let print (allergens, score) =
    List.filter_map allergens ~f:(fun allergen ->
        if not (allergic_to score allergen)
        then Some (print_allergic_to_fail "true" "false" (allergen, score))
        else None)
    |> String.concat ~sep:"\n\n"
  in QCheck.Test.make ~count:1000 ~name:"prop_allergic_to_multiple_allergens"
    (QCheck.make allergens_gen ~print)
    (fun (allergens, score) -> List.for_all allergens ~f:(allergic_to score))

(* Pretty-printer of `allergies` failure. *)
let print_allergies_fail (allergens, score) =
  "Failed the call to `allergies " ^ Int.to_string score ^ "`:\n"
  ^ "  Expected: " ^ print_allergens allergens ^ "\n"
  ^ "  Actual:   " ^ print_allergens (allergies score)

(* Property: `allergies score == [allergen]` when `allergen` has `score`. *)
let prop_allergies_single_allergens =
  let print (allergen, score) = print_allergies_fail ([allergen], score) in
  QCheck.Test.make ~count:1000 ~name:"prop_allergies_single_allergens"
    (QCheck.make allergen_gen ~print)
    (fun (allergen, score) -> Poly.equal (allergies score) [allergen])

(* Property: `allergies score` lists all allergens for `score`. *)
let prop_allergies_multiple_allergens =
  QCheck.Test.make ~count:1000 ~name:"prop_allergies_multiple_allergens"
    (QCheck.make allergens_gen ~print:print_allergies_fail)
    (fun (allergens, score) -> Poly.equal (allergies score) allergens)

let aeb exp got _test_ctxt =
  assert_equal exp got ~printer:Bool.to_string

let aea exp got _test_ctxt =
  assert_equal exp got ~printer:print_allergens

let tests = [
  "not allergic to anything" >:: aeb false (allergic_to 0 Eggs);
  "allergic only to eggs" >:: aeb true (allergic_to 1 Eggs);
  "allergic to eggs and something else" >:: aeb true (allergic_to 3 Eggs);
  "allergic to something, but not eggs" >:: aeb false (allergic_to 2 Eggs);
  "allergic to everything" >:: aeb true (allergic_to 255 Eggs);
  "not allergic to anything" >:: aeb false (allergic_to 0 Peanuts);
  "allergic only to peanuts" >:: aeb true (allergic_to 2 Peanuts);
  "allergic to peanuts and something else" >:: aeb true (allergic_to 7 Peanuts);
  "allergic to something, but not peanuts" >:: aeb false (allergic_to 5 Peanuts);
  "allergic to everything" >:: aeb true (allergic_to 255 Peanuts);
  "not allergic to anything" >:: aeb false (allergic_to 0 Shellfish);
  "allergic only to shellfish" >:: aeb true (allergic_to 4 Shellfish);
  "allergic to shellfish and something else" >:: aeb true (allergic_to 14 Shellfish);
  "allergic to something, but not shellfish" >:: aeb false (allergic_to 10 Shellfish);
  "allergic to everything" >:: aeb true (allergic_to 255 Shellfish);
  "not allergic to anything" >:: aeb false (allergic_to 0 Strawberries);
  "allergic only to strawberries" >:: aeb true (allergic_to 8 Strawberries);
  "allergic to strawberries and something else" >:: aeb true (allergic_to 28 Strawberries);
  "allergic to something, but not strawberries" >:: aeb false (allergic_to 20 Strawberries);
  "allergic to everything" >:: aeb true (allergic_to 255 Strawberries);
  "not allergic to anything" >:: aeb false (allergic_to 0 Tomatoes);
  "allergic only to tomatoes" >:: aeb true (allergic_to 16 Tomatoes);
  "allergic to tomatoes and something else" >:: aeb true (allergic_to 56 Tomatoes);
  "allergic to something, but not tomatoes" >:: aeb false (allergic_to 40 Tomatoes);
  "allergic to everything" >:: aeb true (allergic_to 255 Tomatoes);
  "not allergic to anything" >:: aeb false (allergic_to 0 Chocolate);
  "allergic only to chocolate" >:: aeb true (allergic_to 32 Chocolate);
  "allergic to chocolate and something else" >:: aeb true (allergic_to 112 Chocolate);
  "allergic to something, but not chocolate" >:: aeb false (allergic_to 80 Chocolate);
  "allergic to everything" >:: aeb true (allergic_to 255 Chocolate);
  "not allergic to anything" >:: aeb false (allergic_to 0 Pollen);
  "allergic only to pollen" >:: aeb true (allergic_to 64 Pollen);
  "allergic to pollen and something else" >:: aeb true (allergic_to 224 Pollen);
  "allergic to something, but not pollen" >:: aeb false (allergic_to 160 Pollen);
  "allergic to everything" >:: aeb true (allergic_to 255 Pollen);
  "not allergic to anything" >:: aeb false (allergic_to 0 Cats);
  "allergic only to cats" >:: aeb true (allergic_to 128 Cats);
  "allergic to cats and something else" >:: aeb true (allergic_to 192 Cats);
  "allergic to something, but not cats" >:: aeb false (allergic_to 64 Cats);
  "allergic to everything" >:: aeb true (allergic_to 255 Cats);
  "no allergies" >:: aea [] (allergies 0);
  "just eggs" >:: aea [Eggs] (allergies 1);
  "just peanuts" >:: aea [Peanuts] (allergies 2);
  "just strawberries" >:: aea [Strawberries] (allergies 8);
  "eggs and peanuts" >:: aea [Eggs; Peanuts] (allergies 3);
  "more than eggs but not peanuts" >:: aea [Eggs; Shellfish] (allergies 5);
  "lots of stuff" >:: aea [Strawberries; Tomatoes; Chocolate; Pollen; Cats] (allergies 248);
  "everything" >:: aea [Eggs; Peanuts; Shellfish; Strawberries; Tomatoes; Chocolate; Pollen; Cats] (allergies 255);
  "no allergen score parts" >:: aea [Eggs; Shellfish; Strawberries; Tomatoes; Chocolate; Pollen; Cats] (allergies 509);
]

let _ =
  run_test_tt_main ("allergies tests" >::: tests);
  QCheck_runner.run_tests ~verbose:true ~colors:true
    [ prop_allergic_to_single_allergens
    ; prop_allergic_to_negative_single_allergens
    ; prop_allergic_to_multiple_allergens
    ; prop_allergies_single_allergens
    ; prop_allergies_multiple_allergens
    ]
