(* Encoding from English to atbash cipher *)
val encode : ?block_size:int -> string -> string

(* Decoding from atbash to English *)
val decode : string -> string
