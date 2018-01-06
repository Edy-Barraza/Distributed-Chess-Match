(* Represents the entire state of the game *)
type state

(* Represents a single chess board *)
type board

(* Represents all the types of pieces *)
type piece

(* Represents a single position on one board *)
type position

(* Represents a single player *)
type user

(* Represents a command to update the state *)
type command

(* [init_state] is the initial game configuration *)
val init_state : state

(* [is_valid com st] is [true] if the command [com] is valid in state [st]
 * and [false] otherwise *)
val is_valid : command -> state -> bool

(* [get_squares pos st] is the list of possible positions a piece at [pos]
 * can move to in the given [st]
 * requires: [pos] is a valid position on the board *)
val get_squares : position -> user -> state -> position list

(* [do st com] is the result [st'] after applying the command [com] on [st] *)
val do : state -> user -> command -> state*bool

(* [is_check st] is [true] if [user] is on check, [false] otherwise 
 * requires: [user] is a valid user *)
val is_check : state -> user -> bool

(* [is_mate st user] is [true] if [user] is on check mate, [false] otherwise
 * requires: [user] is a valid user *)
val is_mate : state -> user -> bool

(* [get_board n st] returns an association list where the keys are piece
 * id's and the values are their positions on the [nth] board in [st]  *)
val get_board : state -> int -> string*string list

(* [get_inv nth st] is a list representing the [nth] player's inventory*)
val get_inv : int -> state -> string list

(* [get_turn st user] is the number of turns [user] has moved in [st] *)
val get_turn : state -> user -> int

(* [get_score st user] is the current score of [user] in [st] *)
val get_score : state -> user -> int

