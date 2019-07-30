open Base

open Model
open Yojson.Basic
open Yojson.Basic.Util

let strip_quotes s = String.drop_prefix s 1 |> Fn.flip String.drop_suffix 1

let two_elt_list_to_tuple (j: json): string = match j with
| `List [`Int x1; `Int x2] -> Printf.sprintf "(%d,%d)" x1 x2
| _ -> failwith "two element list expected, but got " ^ (json_to_string j)

let map_elements (to_str: json -> string) (parameters: (string * json) list): (string * string) list =
  List.map parameters ~f:(fun (k,j) -> (k,to_str j))

let optional_int ~(none: int) = function
| `Int n when n = none -> "None"
| `Int n -> "(Some " ^ Int.to_string n ^ ")"
| x -> json_to_string x

let optional_int_list = function
| `List xs -> "(Some [" ^ String.concat ~sep:"; " (List.map ~f:json_to_string xs) ^ "])"
| _ -> "None"

let optional_int_or_string ~(none: int) = function
| `String s -> "(Some \"" ^ s ^ "\")"
| `Int n when n = none -> "None"
| x -> json_to_string x

let default_value ~(key: string) ~(value: string) (parameters: (string * string) list): (string * string) list =
  if List.exists ~f:(fun (k, _) -> String.(k = key)) parameters
  then parameters
  else (key, value) :: parameters

let optional_strings ~(f: string -> bool) (parameters: (string * json) list): (string * string) list =
  let replace parameter =
    let (k, v) = parameter in
    if f k
    then (k, "(Some " ^ json_to_string v ^ ")")
    else (k, json_to_string v) in
  List.map ~f:replace parameters

let option_of_null (value: json): string = match value with
| `Null -> "None"
| `String s -> "(Some \"" ^ s ^ "\")"
| `List _ as l -> "(Some " ^ (json_to_string l) ^ ")"
| x -> failwith "cannot handle this type: " ^ json_to_string x

let is_empty_string (value: json): bool = match value with
| `String s -> String.is_empty s
| _ -> false

let edit_phone_number_expected (value: json) = match value with
| `String s -> "(Ok \"" ^ s ^ "\")"
| `Assoc [("error", v)] -> "(Error " ^ json_to_string v ^ ")"
| x -> failwith "Bad json value in change " ^ json_to_string x

let edit_hamming_expected = function
| `Int n -> "(Ok " ^ Int.to_string n ^ ")"
| `Assoc [("error", `String m)] ->" (Error \"" ^ m ^ "\")"
| x -> json_to_string x

let edit_change_expected (value: json) = match value with
| `List xs -> "(Some [" ^ (String.concat ~sep:"; " (List.map ~f:json_to_string xs)) ^ "])"
| `Assoc [("error", _)] -> "None"
| `Int (-1) -> "None"
| _ -> failwith "Bad json value in change"

let edit_bowling_expected (value: json) = match value with
| `Int n -> "(Ok " ^ (Int.to_string n) ^ ")"
| `Assoc [(k, v)] -> 
    if String.(k = "error") then "(Error " ^ json_to_string v ^ ")" else failwith ("Can only handle error value but got " ^ k)
| _ -> failwith "Bad json value in bowling"

let edit_forth_expected (value: json) = match value with
| `List xs -> "(Some [" ^ (String.concat ~sep:"; " (List.map ~f:json_to_string xs)) ^ "])"
| `Assoc [("error", _)] -> "None"
| x -> failwith "Bad json value in change " ^ json_to_string x

let edit_beer_song_expected = function
| `List xs -> xs 
  |> List.map ~f:(function 
    | `String s -> s 
    | x -> json_to_string x) 
  |> String.concat ~sep:(String.escaped "\n")
  |> Printf.sprintf "\"%s\""
| x -> json_to_string x |> Printf.sprintf "Bad json value in beer-song %s" |> failwith 

let edit_say (ps: (string * json) list) =
  let edit = function
  | ("number", `Int v) when v >= 0 -> ("number", Printf.sprintf "%iL" v)
  | ("number", `Int v) when v < 0 -> ("number", Printf.sprintf "(%iL)" v)
  | ("expected", `Assoc [("error", v)]) -> ("expected", "(Error " ^ json_to_string v ^ ")")
  | ("expected", v) -> ("expected", "(Ok " ^ json_to_string v ^ ")")
  | (k, ps) -> (k, json_to_string ps) in
  List.map ps ~f:edit

let edit_triangle (ps: (string * json) list): (string * string) list option =
  let edit = function
  | ("sides", `List l) -> ("sides", l |> List.map ~f:json_to_string |>  String.concat ~sep:" ")
  | (k, v) -> (k, json_to_string v) in
  let int_sides = function
  | ("sides", `List l) -> l |> List.for_all ~f:(function `Int _ -> true | _ -> false)
  | (_, _) -> false
  in
  if List.exists ps ~f:int_sides then
    List.map ps ~f:edit |> Option.return
  else
    None

let edit_all_your_base (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("outputBase", v) -> let v = json_to_string v in ("outputBase", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
  | ("inputBase", v) -> let v = json_to_string v in ("inputBase", if Int.of_string v >= 0 then v else "(" ^ v ^ ")")
  | ("expected", v) -> ("expected", optional_int_list v)
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_connect (ps: (string * json) list): (string * string) list =
  let format_board l =  
    if List.length l > 1 then
      l |> List.map ~f:(json_to_string)
        |> String.concat ~sep:";\n"
        |> Printf.sprintf "[\n%s;\n]"
    else json_to_string (`List l)
  in
  let edit = function
  | ("expected", `String "X") -> ("expected", "(Some X)")
  | ("expected", `String "O") -> ("expected", "(Some O)")
  | ("expected", `String "" ) ->  ("expected", "None")
  | ("board", `List l) -> ("board", format_board l)
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_dominoes (ps: (string * json) list): (string * string) list =
  let edit (p: (string * json)) = match p with
  | ("dominoes", `List j) -> ("dominoes", "[" ^ (List.map ~f:two_elt_list_to_tuple j |> String.concat ~sep:"; ") ^ "]")
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_minesweeper (ps: (string * json) list): (string * string) list =
  let format_board l =
    if List.length l > 1 then
      l |> List.map ~f:json_to_string |> String.concat ~sep:";\n" |> Printf.sprintf "[\n%s;\n]"
    else
      json_to_string (`List l)
  in
  let edit = function
  | ("minefield", `List l) -> ("minefield", format_board l)
  | ("expected", `List l) -> ("expected", format_board l)
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_space_age (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("planet", v) -> ("planet", json_to_string v |> strip_quotes) 
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit
  
let null_to_option = function `Null -> "None" | x -> Printf.sprintf "(Some %s)" (json_to_string x)

let edit_palindrome_products (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("property", v) -> ("property", json_to_string v |> strip_quotes)
  | ("expected", `Assoc kvs) -> 
      let find = List.Assoc.find kvs ~equal:String.equal in
      let open Option.Monad_infix in
      let success_result = 
        find "value" >>= fun value ->
        find "factors" >>= fun factors ->
        let factors = to_list factors in
        let factors_str = "[" ^ (List.map ~f:two_elt_list_to_tuple factors |> String.concat ~sep:"; ") ^ "]" in
        let expected = Printf.sprintf "Ok {value=%s; factors=%s}" (null_to_option value) factors_str in
        Some ("expected", expected) in
      if Option.is_some success_result
      then Option.value_exn success_result
      else 
        let error = List.Assoc.find_exn kvs ~equal:String.equal "error" in
        ("expected", "Error " ^ json_to_string error)
  | (k, v) -> (k, json_to_string v)
  in
  List.map ps ~f:edit
  
let edit_bowling (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("property", v) -> ("property", json_to_string v |> strip_quotes) 
  | ("roll", `Int n) -> ("roll", let s = Int.to_string n in if n < 0 then ("(" ^ s ^ ")") else s)
  | ("expected", v) -> ("expected", edit_bowling_expected v)
  | (k, v) -> (k, json_to_string v) in
  (List.map ps ~f:edit) @ if List.exists ps ~f:(fun (k, _) -> String.equal "roll" k) then [] else [("roll", "")]

let edit_binary_search (ps: (string * json) list): (string * string) list =
  let open Yojson.Basic.Util in
  let as_array_string xs = 
    let xs = to_list xs |> List.map ~f:to_int |> List.map ~f:Int.to_string in
    "[|" ^ String.concat ~sep:"; " xs ^ "|]" in
  let edit = function
  | ("array", v) -> ("array", as_array_string v) 
  | ("expected", `Int i) -> ("expected", Printf.sprintf "(Ok %i)" i)
  | ("expected", `Assoc [("error", `String m)]) -> ("expected", Printf.sprintf "(Error \"%s\")" m)
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_change (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("target", `Int i) -> ("target", Printf.sprintf (if i < 0 then "(%i)" else "%i") i)
  | ("expected", v) -> ("expected", match v with
    | `List xs -> "(Ok [" ^ (String.concat ~sep:"; " (List.map ~f:json_to_string xs)) ^ "])"
    | `Assoc [("error", v)] -> "(Error " ^ json_to_string v ^ ")"
    | x -> failwith "Bad json value in change " ^ json_to_string x)
  | (k, v) -> (k, json_to_string v) in
  ps |> List.map ~f:edit

let edit_rectangles (ps: (string * json) list): (string * string) list =
  let format_field l = 
    let sep = if List.length l > 1 then ";\n" else "" in
    let fmt = if List.length l > 1 then Printf.sprintf  "[|\n%s;\n|]" else Printf.sprintf  "[|%s|]" in
    l |> List.map ~f:json_to_string 
      |> String.concat ~sep
      |> fmt
  in
  let edit = function
  | ("strings", `List l) -> ("strings", format_field l)
  | (k, v) -> (k, json_to_string v) in
  List.map ps ~f:edit

let edit_etl (ps: (string * json) list): (string * string) list =
  let edit = function
  | ("expected", `Assoc l) -> 
    let grouped = l
      |> List.map ~f:(fun (k, v) -> Printf.sprintf "('%s', %s)" k (json_to_string v))
      |> List.groupi ~break:(fun i _ _ -> Int.(i % 5 = 0))
    in
    if List.length grouped > 1 then
      grouped
      |> List.map ~f:(String.concat ~sep:"; ")
      |> String.concat ~sep:";\n"
      |> fun v -> ("expected", Printf.sprintf "[\n%s;\n]" v)
    else
      grouped
      |> List.map ~f:(String.concat ~sep:"; ")
      |> String.concat ~sep:"; "
      |> fun v -> ("expected", Printf.sprintf "[%s]" v)
  | (k, v) -> (k, json_to_string v) in
  let s = List.map ps ~f:edit in
  s @ (
    ps 
    |> List.filter_map  ~f:(fun (k, v) -> (
      if String.equal k "expected" then
        None
      else
        match v with 
        | `List l -> 
          l
          |> List.filter_map ~f:(function
            | `String s -> Some (Printf.sprintf "'%s'" s)
            | _ -> None)
          |> String.concat ~sep:"; "
          |> fun s -> (k, Printf.sprintf "[%s]" s)
          |> Option.return
        | _ -> None
    ))
    |> (fun l -> 
      if List.length l <= 2 then
        [("input", "[" ^ (List.map l ~f:(fun (k, v) -> Printf.sprintf "(%s, %s)" k v) |> (String.concat ~sep:"; ")) ^ "]")]
      else 
        [("input", "[\n" ^ (List.map l ~f:(fun (k, v) -> Printf.sprintf "(%s, %s)" k v) |> (String.concat ~sep:";\n")) ^ ";\n]")]
  ))

let rec edit_expected ~(f: json -> string) (parameters: (string * json) list) = match parameters with
  | [] -> []
  | ("expected", v) :: rest -> ("expected", f v) :: edit_expected ~f rest
  | (k, v) :: rest -> (k, json_to_string v) :: edit_expected ~f rest

let ocaml_edit_parameters ~(slug: string) (parameters: (string * json) list) = match (slug, parameters) with
| ("all-your-base", ps) -> edit_all_your_base ps |> Option.return
| ("beer-song", ps) -> edit_expected ~f:edit_beer_song_expected ps |> Option.return
| ("binary-search", ps) -> edit_binary_search ps |> Option.return
| ("bowling", ps) -> edit_bowling ps |> Option.return
| ("connect", ps) -> edit_connect ps |> Option.return
| ("change", ps) -> edit_change ps |> Option.return
| ("dominoes", ps) -> edit_dominoes ps |> Option.return
| ("etl", ps) -> edit_etl ps |> Option.return
| ("forth", ps) -> edit_expected ~f:edit_forth_expected ps |> Option.return
| ("hamming", ps) -> edit_expected ~f:edit_hamming_expected ps |> Option.return
| ("minesweeper", ps) -> edit_minesweeper ps |> Option.return
| ("palindrome-products", ps) -> edit_palindrome_products ps |> Option.return
| ("phone-number", ps) -> edit_expected ~f:edit_phone_number_expected ps |> Option.return
| ("rectangles", ps) -> edit_rectangles ps |> Option.return
| ("say", ps) -> edit_say ps |> Option.return
| ("space-age", ps) -> edit_space_age ps |> Option.return
| ("triangle", ps) -> edit_triangle ps
| (_, ps) -> map_elements json_to_string ps |> Option.return
