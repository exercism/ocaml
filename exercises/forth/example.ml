open Core

let (>|>) f g x = g (f x)

let string_to_int (s: string): int option =
  Option.try_with (fun () -> Int.of_string s)

type sentence = 
| Def of string
| Normal of string list

type stack = int list

type handler = stack -> stack option
type vocabulary = handler String.Map.t

let handle_binary_op f = function
| x :: y :: xs -> Some ((f y x) :: xs)
| _ -> None

let std_vocabulary: vocabulary =
  String.Map.empty 
  |> Map.add ~key:"+" ~data:(handle_binary_op (+))
  |> Map.add ~key:"-" ~data:(handle_binary_op (-))
  |> Map.add ~key:"*" ~data:(handle_binary_op ( * ))
  |> Map.add ~key:"/" ~data:(function | x :: y :: xs -> if x = 0 then None else Some ((y/x) :: xs) | _ -> None)
  |> Map.add ~key:"DUP" ~data:(function | x :: xs -> Some (x :: x :: xs) | _ -> None)
  |> Map.add ~key:"DROP" ~data:(function | _ :: xs -> Some xs | _ -> None)
  |> Map.add ~key:"SWAP" ~data:(function | x :: y :: xs -> Some (y :: x :: xs) | _ -> None)
  |> Map.add ~key:"OVER" ~data:(function | x :: y :: xs -> Some (y :: x :: y :: xs) | _ -> None)

let (<|>) o1 o2 = match o1 with
| None -> o2
| Some _ -> o1

let apply x f = f x

let string_last = function
| "" -> None
| s -> Some s.[String.length s - 1]

let evaluate_number (word: string) (stack: stack): stack option =
  Option.map (string_to_int word) ~f:(fun n -> n :: stack)

let evaluate_word (word: string) (vocabulary: vocabulary) (stack: stack): stack option = 
  evaluate_number word stack <|> 
  Option.bind (Map.find vocabulary word) ~f:(apply stack) <|>
  None 

let rec eval_all (stack: 'a) (fs: ('a -> 'a option) list): 'a option = match fs with
| [] -> Some stack
| f :: fs -> (match f stack with
  | None -> None
  | Some stack -> eval_all stack fs
)

let to_sentence (words: string): sentence =
  if words.[0] = ':' && string_last words = Some ';'
  then Def words
  else Normal (String.split ~on:' ' words)

let rec handle_def vocabulary stack words: (vocabulary * stack) option =
  let words = String.split ~on:' ' words in
  let words = List.drop words 1 in
  let words = List.take words (List.length words - 1) in
  if List.length words < 2
  then None
  else 
    let new_vocab = List.hd_exn words in
    if Option.is_some (string_to_int new_vocab)
    then None
    else
      let def = List.drop words 1 in
      let vocabulary = Map.add vocabulary ~key:new_vocab ~data:(fun stack -> Option.map ~f:(snd >|> List.rev) @@ evaluate_stack stack vocabulary def) in
      Some (vocabulary, stack)

and evaluate_sentence_or_fail (vocabulary: vocabulary) (stack: stack) (sentence: sentence): (vocabulary * stack) option = match sentence with
| Normal words -> eval_all (vocabulary, stack) (List.map words ~f:(fun w -> fun (v,s) -> Option.map (evaluate_word w v s) ~f:(fun s -> (v,s))))
| Def def -> handle_def vocabulary stack def

and evaluate_stack (stack: stack) (vocabulary: vocabulary) (words: string list): (vocabulary * stack) option = 
  List.fold words ~init:(Some (vocabulary, stack)) 
        ~f:(fun mvs w -> (match mvs with
          | None -> None
          | Some (v, s) -> evaluate_sentence_or_fail v s (to_sentence w)
          ))
  |> Option.map ~f:(fun (v,s) -> (v, List.rev s))

let evaluate words = Option.map ~f:snd @@ evaluate_stack [] std_vocabulary (List.map ~f:String.uppercase words)