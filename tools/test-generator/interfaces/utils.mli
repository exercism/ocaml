open Core.Std
open Yojson.Safe

val map2 : ('a -> 'b -> 'c) -> ('a, 'e) Result.t -> ('b, 'e) Result.t -> ('c, 'e) Result.t

val sequence : (('a, 'e) Result.t) list -> (('a list), 'e) Result.t

val to_list_option : json -> json list option

val to_list_note : 'e -> json -> ((json list, 'e) Result.t)

val to_assoc_note : 'e -> json -> ((json list, 'e) Result.t)

val to_string_note : 'e -> json -> ((string, 'e) Result.t)

val member_note : 'e -> string -> json -> ((json, 'e) Result.t)

val safe_to_int_option : json -> int option

val find_arrayi : ?start:int -> 'a array -> f:('a -> bool) -> (int * 'a) option

val (>>) : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
