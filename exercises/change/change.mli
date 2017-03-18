(* If it is impossible to make the target with the given coins, then return None *)
val make_change : target: int -> coins: int list -> int list option