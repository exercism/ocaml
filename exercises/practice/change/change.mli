open Base

(* If it is impossible to make the target with the given coins, then return Error *)
val make_change : target: int -> coins: int list -> (int list, string) Result.t 