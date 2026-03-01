:- use_module(piece_at).

generate_child(W, Move, W2) :-
 expand(W),
 legal_move(W, Move),
 create_child_world(W, Move, W2).


high_priority(W) :-
 in_check(W, _).

high_priority(W) :-
 forcing_move(W, _).


expand(W) :-
 side_to_move(W, Color),
 in_check(W, Color).


expand(W) :-
  high_priority(W),
  depth(W, D),
  D < 10.

expand(W) :-
  depth(W, D),
  D < 6,
  \+ terminal(W),
  interesting(W).


terminal(W) :-
  checkmate(W).
terminal(W) :-
  stalemate(W).


forcing_move(W, Move) :-
  gives_check(W, Move).

forcing_move(W, Move) :-
  wins_material(W, Move).

forcing_move(W, Move) :-
  creates_threat(W, Move).


interesting(W) :-
  in_check(W, _).

interesting(W) :-
  legal_move(W, Move),
  forcing_move(W, Move).


interesting(W) :-
  pin(W, _, _).

interesting(W) :-
  fork_threat(W, _, _).

interesting(W) :-
  skewer_threat(W, _, _).

interesting(W) :-
  king_exposed(W, _).