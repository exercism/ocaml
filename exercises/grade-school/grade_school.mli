(** Grade-school exercise *)
type school

val empty_school :  school

(** Add a student to a school *)
val add : string -> int -> school -> school

(** Get all the students from a grade *)
val grade : int -> school -> string list

(** Sort the list of students in a grade, if necessary *)
val sorted : school -> school
