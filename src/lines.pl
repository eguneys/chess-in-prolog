:- module(lines, [bishop_fork_root/1, bishop_fork_world/2]).

:- use_module(types).
:- use_module(piece_at).


bishop_fork_line(W0, Line, Bishop, Rook, King) :-
  Line = [step(W0, Move1, W1)],
  bishop_fork(step(W0, Move1, W1), Bishop, Rook, King).


bishop_fork_root(Move) :-
  bishop_fork(step(root, Move, _), _, _, _).

bishop_fork_world(W, Move) :-
  bishop_fork(step(W, Move, _), _, _, _).

bishop_fork(step(W, Move, W1), BishopSq, RookSq, KingSq) :-
  bishop_fork_candidate(W, BishopSq, To, KingSq, RookSq),
  Move = move(BishopSq, To),
  hyp_world(W, Move, W1),
  attacks(W1, bishop, To, KingSq),
  attacks(W1, bishop, To, RookSq),
  side_to_move(W1, Opp),
  
  \+ (piece_at(W1, AFrom, Piece, Opp),
  lean_into(W1, AFrom, To, Opp),
  attacks(W1, Piece, AFrom, To)).

lean_into(W, A, B, C).


bishop_fork_candidate(W, From, To, KingSq, RookSq) :-
  side_to_move(W, Color),
  piece_at(W, From, bishop, Color),
  opposite_color(Color, Opp),
  piece_at(W, KingSq, king, Opp),
  piece_at(W, RookSq, rook, Opp),
  bishop_attack(W, From, To).
