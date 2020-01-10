open Base

type 'a node = 
  | Empty
  | Node of { value: 'a; mutable prev: 'a node; mutable next: 'a node}
and 'a linked_list = { mutable first: 'a node; mutable last:'a node}

let empty () = {first = Empty; last = Empty}

let push v l = 
    let elt = Node { value = v; prev = l.last; next = Empty } in ( 
      match l.last with
      | Empty -> l.first <- elt
      | Node n -> n.next <- elt
    ); 
    l.last <- elt

let pop = function
  | {last = Empty; _} -> failwith "empty list!"
  | {last = Node {value; prev; _}; _} as l -> (
      match prev with 
      | Empty -> (l.last <- Empty; l.first <- Empty)
      | Node n -> (l.last <- prev; n.next <- Empty)
    );
    value

let shift = function
  | {first = Empty; _} -> failwith "empty list!"
  | {first = Node {value; next; _}; _} as l -> (
    match next with 
    | Empty -> (l.first <- Empty; l.last <- Empty)
    | Node n -> (l.first <- next; n.prev <- Empty)
  );
  value
  
let unshift v l =
  let elt = Node { value = v; prev = Empty; next = l.first } in ( 
    match l.first with
    | Empty -> l.last <- elt
    | Node n -> n.prev <- elt
  ); 
  l.first <- elt

let count l = 
  let rec count_node acc = function
  | Empty -> acc
  | Node {next = n; _} -> count_node (1 + acc) n
  in count_node 0 l.first