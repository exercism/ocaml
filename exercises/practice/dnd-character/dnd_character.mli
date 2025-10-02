type character = {
  charisma : int;
  constitution : int;
  dexterity : int;
  hitpoints : int;
  intelligence : int;
  strength : int;
  wisdom : int;
}

(* Gives the random ability score obtained by rolling four 6-sided dice *)
val ability : unit -> int

(* Given an ability score, returns the ability modifier *)
val modifier : score:int -> int

(* Creates a new character *)
val generate_character : unit -> character
