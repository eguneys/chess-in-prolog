:- module(lines, [bishop_fork_line/5]).

:- use_module(types).
:- use_module(piece_at).

move_sequence_over_worlds(_, []).
move_sequence_over_worlds(W0, [step(W0, Move, W1)|Rest]) :-
    legal_move(W0, Move),
    hyp_world(W0, Move, W1),
    move_sequence_over_worlds(W1, Rest).


bishop_fork_line(W0, Line, Bishop, Rook, King) :-
  Line = [step(W0, Move1, W1)],
  move_sequence_over_worlds(W0, Line),
  bishop_fork(W1, Move1, Bishop, Rook, King).



bishop_fork(W, move(From, To), From, RookSq, KingSq) :-
  bishop_move(W, From, To),
  attacks(W, To, KingSq),
  attacks(W, To, RookSq).