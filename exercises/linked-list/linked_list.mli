open Base

type 'a linked_list

val empty : unit -> 'a linked_list

val push : 'a -> 'a linked_list -> unit

val pop : 'a linked_list -> 'a

val shift : 'a linked_list -> 'a

val unshift : 'a -> 'a linked_list -> unit

val count : 'a linked_list -> int