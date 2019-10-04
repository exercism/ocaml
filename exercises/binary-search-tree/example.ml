open Base

type 'a bst = Leaf | Node of 'a bst * 'a * 'a bst

let empty = Leaf

let value = function
  | Leaf -> Error "empty tree"
  | Node(_, v, _) -> v

let left = function
  | Leaf -> Error "empty tree"
  | Node(l, _, _) -> l

let right = function
  | Leaf -> Error "empty tree"
  | Node(_, _, r) -> r

let insert v = function
  | Leaf -> Node(Leaf, v, Leaf)
  | Node(l, v', r) when v <= v' -> Node(insert v l, v', r)
  | Node(l, v', r) -> Node(l, v', insert v r)

let to_list = function
| Leaf -> []
| Node(l, v, r) -> to_list(l) @ [v] @ to_list(r)