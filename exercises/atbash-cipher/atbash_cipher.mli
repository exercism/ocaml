(* Encoding from English to atbash cipher. The default for block_size is 5 *)
val encode : ?block_size:int -> string -> string

(* Decoding from atbash to English *)
val decode : string -> string
