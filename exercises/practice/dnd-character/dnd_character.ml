type character = {
  charisma : int;
  constitution : int;
  dexterity : int;
  hitpoints : int;
  intelligence : int;
  strength : int;
  wisdom : int;
}

let ability () =
  failwith "'ability' is missing"

let modifier ~score =
  failwith "'modifier' is missing"

let generate_character () =
  failwith "'generate_character' is missing"
