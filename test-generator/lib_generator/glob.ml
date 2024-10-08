open Core

let split c s =
	let len = String.length s in
	let rec loop acc last_pos pos =
		if pos = -1 then
		String.sub s ~pos:0 ~len:last_pos :: acc
		else
		if Char.equal (String.get s pos) c then
			let pos1 = pos + 1 in
			let sub_str = String.sub s ~pos:pos1 ~len:(last_pos - pos1) in
			loop (sub_str :: acc) pos (pos - 1)
		else loop acc last_pos (pos - 1)
	in
	loop [] len (len - 1)

(** Returns list of indices of occurances of substr in x *)
let find_substrings ?(start_point=0) substr x =
	let len_s = String.length substr and len_x = String.length x in
	let rec aux acc i =
		if len_x - i < len_s
		then acc
		else
			if String.equal (String.sub x ~pos:i ~len:len_s) substr
			then aux (i::acc) (i + 1)
			else aux acc (i + 1)
	in
	aux [] start_point

let matches glob x =
	let rec contains_all_sections = function
		| _, [] | _, [""] -> true
		| i, [g] -> (* need to find a match that matches to end of string *)
			find_substrings ~start_point:i g x
			|> List.exists ~f:(fun j -> j + String.length g = String.length x)
		| 0, ""::g::gs ->
			find_substrings g x
			|> List.exists ~f:(fun j -> contains_all_sections ((j + (String.length g)), gs))
		| i, g::gs ->
			find_substrings ~start_point:i g x
			|> List.exists ~f:(fun j ->
				(if i = 0 then j = 0 else true)
				&& contains_all_sections ((j + (String.length g)), gs))
	in
	contains_all_sections (0, (split '*' glob))
