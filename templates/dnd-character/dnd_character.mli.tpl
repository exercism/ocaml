type character = {
  mutable charisma : int;
  mutable constitution : int;
  mutable dexterity : int;
  mutable hitpoints : int;
  mutable intelligence : int;
  mutable strength : int;
  mutable wisdom : int;
}

val ability : unit -> int

val modifier : score:int -> int

val generate_character : unit -> character
