open Base

type bst = Leaf | Node of bst * int * bst

let empty = Leaf

let value = function
  | Leaf -> Error "empty tree"
  | Node(_, v, _) -> Ok v

let left = function
  | Leaf -> Error "empty tree"
  | Node(l, _, _) -> Ok l

let right = function
  | Leaf -> Error "empty tree"
  | Node(_, _, r) -> Ok r

let rec insert v = function
  | Leaf -> Node(Leaf, v, Leaf)
  | Node(l, v', r) when v <= v' -> Node(insert v l, v', r)
  | Node(l, v', r) -> Node(l, v', insert v r)

let rec to_list = function
| Leaf -> []
| Node(l, v, r) -> to_list(l) @ [v] @ to_list(r)