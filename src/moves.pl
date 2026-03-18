:-module(moves, [ 
    opposite/2,
    side_to_move/2,
    piece_at/4,
    opposite_side/2,
    make_capture_move/3,
    make_move/3
]).

:- use_module(positions).

load_files('positions', [qcompile(true)]).

opposite(white, black).
opposite(black, white).


side_to_move(W, Color) :-
  base_side_to_move(W, Color).

side_to_move(W, Color) :-
  nonvar(W),
  side_to_move_eval(W, Color).

side_to_move_eval(hyp_opposite(W), Opp) :-
  side_to_move(W, Color),
  opposite(Color, Opp).

side_to_move_eval(hyp_take(W, _), Color) :-
  side_to_move(W, Color).

side_to_move_eval(hyp_put(W, _, _, _), Color) :-
  side_to_move(W, Color).




piece_at(hyp_take(W, FromExclude), From, Color, Role) :-
  nonvar(W),
  piece_at(W, From, Color, Role),
  From \= FromExclude.

piece_at(hyp_put(_W, From, Color, Role), From, Color, Role).
piece_at(hyp_put(W, _, _, _), From, Color, Role) :-
  nonvar(W),
  piece_at(W, From, Color, Role).

piece_at(hyp_opposite(W), From, Color, Role) :-
  nonvar(W),
  piece_at(W, From, Color, Role).

piece_at(W, From, Color, Role) :-
  base_piece_at(W, From, Color, Role).

opposite_side(W, Color) :-
  side_to_move(W, Opp),
  opposite(Color, Opp).


take_piece(W, From, hyp_take(W, From)).
put_piece(W, From, Color, Role, hyp_put(W, From, Color, Role)).
change_side(W, hyp_opposite(W)).

make_capture_move(W, move(From, To), W2) :-
  piece_at(W, From, Color, Role),
  piece_at(W, To, _, _),
  take_piece(W, From, W3),
  take_piece(W3, To, W4),
  put_piece(W4, To, Color, Role, W5),
  change_side(W5, W2).

make_move(W, move(From, To), W2) :-
  piece_at(W, From, Color, Role),
  take_piece(W, From, W3),
  (
    piece_at(W, To, _, _) ->
    take_piece(W3, To, W4);
    W4 = W3
  ),
  put_piece(W4, To, Color, Role, W5),
  change_side(W5, W2).

 