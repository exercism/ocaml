type player = O | X

(* Returns the winning player inside the option if there is a winner, otherwise None *)
val connect : string list -> player option