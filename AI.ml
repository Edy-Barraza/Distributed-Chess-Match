 open Board

type time = Early | Late

let pawn_scores=
[|
  [| 0;  0;  0;  0;  0;  0;  0;  0|];
  [| 50; 50; 50; 50; 50; 50; 50; 50|];
  [| 10; 10; 20; 30; 30; 20; 10; 10|];
  [| 5;  5; 10; 27; 27; 10;  5;  5|];
  [| 0;  0;  0; 25; 25;  0;  0;  0|];
  [| 5; -5;-10;  0;  0;-10; -5;  5|];
  [| 5; 10; 10;-25;-25; 10; 10;  5|];
  [| 0;  0;  0;  0;  0;  0;  0;  0|]
  |]

let knight_scores =
  [|
    [|-50;-40;-30;-30;-30;-30;-40;-50;|];
    [|-40;-20;  0;  0;  0;  0;-20;-40;|];
    [|-30;  0; 10; 15; 15; 10;  0;-30;|];
    [|-30;  5; 15; 20; 20; 15;  5;-30;|];
    [|-30;  0; 15; 20; 20; 15;  0;-30;|];
    [|-40;-20;  0;  5;  5;  0;-20;-40;|];
    [|-30;  5; 10; 15; 15; 10;  5;-30;|];
    [|-50;-40;-20;-30;-30;-20;-40;-50;|];
  |]


let bishop_scores =
  [|
    [|-20;-10;-10;-10;-10;-10;-10;-20;|];
    [|-10;  0;  0;  0;  0;  0;  0;-10;|];
    [|-10;  0;  5; 10; 10;  5;  0;-10;|];
    [|-10;  5;  5; 10; 10;  5;  5;-10;|];
    [|-10;  0; 10; 10; 10; 10;  0;-10;|];
    [|-10; 10; 10; 10; 10; 10; 10;-10;|];
    [|-20;-10;-40;-10;-10;-40;-10;-20;|];
    [|-10;  5;  0;  0;  0;  0;  5;-10;|];
  |]

let kingscores_early =
  [|
    [|-30; -40; -40; -50; -50; -40; -40; -30;|];
    [|-30; -40; -40; -50; -50; -40; -40; -30;|];
    [|-30; -40; -40; -50; -50; -40; -40; -30;|];
    [|-30; -40; -40; -50; -50; -40; -40; -30;|];
    [|-20; -30; -30; -40; -40; -30; -30; -20;|];
    [|-10; -20; -20; -20; -20; -20; -20; -10;|];
    [| 20;  20;   0;   0;   0;   0;  20;  20;|];
    [| 20;  30;  10;   0;   0;  10;  30;  20|];
  |]

let kingsores_late =
  [|
    [|-50;-40;-30;-20;-20;-30;-40;-50;|];
    [|-30;-10; 20; 30; 30; 20;-10;-30;|];
    [|-30;-10; 30; 40; 40; 30;-10;-30;|];
    [|-30;-20;-10;  0;  0;-10;-20;-30;|];
    [|-30;-10; 30; 40; 40; 30;-10;-30;|];
    [|-30;-10; 20; 30; 30; 20;-10;-30;|];
    [|-30;-30;  0;  0;  0;  0;-30;-30;|];
    [|-50;-30;-30;-30;-30;-30;-30;-50|];
  |]

let rec helper board x y (accu:(position*piece) list) color =
  match x with
  | 9 -> accu
  | _ ->
    match y with
    | 9 -> helper board (x+1) 1 accu color
    | _ -> add_piece (x,y) accu color board

and add_piece (x,y) accu color (board:board) =
  let piece = Hashtbl.find board (make_pos x y) in
  match piece with
  | Some z when z.color = color ->
    let accu' = ((x,y),z)::accu in
      helper board x (y+1) accu' color
  | Some _ | None -> helper board x (y+1) accu color

let get_pieces st color : (position*piece) list =
  let board = st.board in
  helper board 1 1 [] color

let rec flatten' accu (x,lst) : (piece*move) list =
  match lst with
  | [] -> accu
  | h::t -> flatten' ((x,h)::accu) (x,t)


let get_frontier st color : (piece*move) list =
  let pieces = get_pieces st color in
  let add_moves ((x,y),z) = z,((x,y)|>get_valid_moves st) in
  pieces
  |> List.map add_moves
  |> List.map (flatten' [])
  |> List.flatten


let rec max_state accu opt (lst:((piece*move)*int) list) =
  match lst with
  | [] -> opt
  | ((x,y),z)::t when z>=accu-> max_state z (Some (x,y)) t
  | _::t -> max_state accu opt t

let get_piece_opt = function
  | None -> failwith "No piece here"
  | Some x -> x

let unwrap board color = function
  | Pre_Promotion (x,y)-> Full_Promotion (Queen,x,y), Some "Queen",800.
  | EnPassant (x,y) -> EnPassant (x,y),None,0.
  | Normal (x,y) ->
    begin
    let piece2 = Hashtbl.find board (x,y) in let score =
    if piece2 <> None then
      if (piece2|>get_piece_opt).color = color then
        (piece2|>get_piece_opt).piece_type|>get_value
      else 0.
    else 0.
    in Normal (x,y), None, score
  end
  | y -> y,None,0.



let rec alpha_beta_decision st depth color =
  color
  |>  get_frontier st
  |> List.map (apply st color depth)
  |> max_state min_int None

and apply st color depth (piec,mov) : ((piece*move)*int) =
  let mv',opt,sc = unwrap (st|>get_board) color mov in
  let st' = copy_state st in
  let _ = (move st' mv' piec opt) in (*    Carefull here!!!! *)
  let color' = get_next color in
  let frontier = get_frontier st' color' in
  (piec,mov),(min_value st max_int min_int 0 depth color frontier max_int)


    (*)
let min_score y,action = y,action|> min_value st action in
  let scores = color|>get_frontier st |> List.map min_score in
  failwith "unimplemented"


let get_frontier (st : state) (color : piece_color) : (piece*move) list =
  failwith "Unimplemented"
    *)
and get_value piece x y a =
  match piece with
  | Queen | Rook -> 0
  | Bishop -> bishop_scores.(x).(y)
  | Knight -> knight_scores.(x).(y)
  | Pawn -> pawn_scores.(x).(y)
  | King when a=Early -> kingscores_early.(x).(y)
  | King when a=Late -> kingsores_late.(x).(y)
  | _ -> 0


and utility (st:state) color : int =
  let pieces = get_pieces st color in
  let score a ((x,y),z) = a + (get_value (z.piece_type) x y Early) in
  List.fold_left (score) 0 pieces


and max_value st a b depth max_dep color accu (v:int) =
  match accu with
  | [] -> v
  | (piece,act)::t ->
  if depth=max_dep then
    utility st color
  else
    let mv',opt,sc = unwrap (st|>get_board) color act in
    (*let actions = get_frontier st color in*)
    let st' = copy_state st in
    let _ = (move st' mv' piece opt) in (*    Carefull here!!!! *)
    let color' = get_next color in
    let actions = get_frontier st' color' in
    let value' =
      min_value st' a b (depth+1) max_dep color' actions (max_int) in
    let max_val = max v value' in
    if max_val >= b then max_val
    else
      max_value st a b depth max_dep color t max_val

and min_value st a b depth max_dep color accu v =
  match accu with
  | [] -> v
  | (piece,act)::t ->
    if depth=max_dep then
      utility st color
    else let mv',opt,sc = unwrap (st|>get_board) color act in
    (*let actions = get_frontier st color in*)
    let st' = copy_state st in
    let _ = (move st' mv' piece opt) in (*    Carefull here!!!! *)
    let color' = get_next color in
    let actions = get_frontier st' color' in
    let value' =
      max_value st' a b (depth+1) max_dep color' actions (min_int) in
    let min_val = min v value' in
    if min_val <= a then min_val
    else
      min_value st a (min b min_val) depth max_dep color t min_val


let compute_next st color depth =
  let bmove = alpha_beta_decision st depth color in
  match bmove with
  | None -> failwith "No best move"
  | Some (piece,mv) ->
    let mv',opt,sc = unwrap (st|>get_board) color mv in
    move st mv' piece opt
