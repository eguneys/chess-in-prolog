:- module(main, [
    coverage/0, 
    show_tp/0,
    show_fp/0, 
    show_negative/0
    ]).

:- use_module(positions).
:- use_module(forks).
:- use_module(attacks).
:- use_module(moves).
:- use_module(fen).

queen_evade_mate(W, Move, W3) :-
  queen_bishop_capture_evadable(W, Move, W2),
  Move = move(From, To),
  turn_king_evadable(W2, KingFrom, KingTo),
  make_move(W2, move(KingFrom, KingTo), W3).
  

queen_bishop_capture_evadable(W, Move, W2) :-
  W = id_0BK2g,
  queen_see_king_with_bishop(W, From, To),
  \+ in_check(W),
  \+ opponent_non_king_capturable(W, To),
  make_capture_move(W, move(From, To), W2),
  \+ in_illegal_check(W2),
  Move = move(From, To).



bishop_forks(W, From, To, Fork_a, Fork_b) :-
  piece_at(W, From, _, bishop),
  piece_at(W, Fork_a, _, rook),
  piece_at(W, Fork_b, _, king),
  \+ queen_bishop_mate(W, _, To),
  \+ in_check(W),
  fork(W, From, To, Fork_a, Fork_b),
  make_capture_move(W, move(From, To), W2),
  \+ turn_king_capturable(W2, To),
  \+ turn_non_king_capturable(W2, To).
  


queen_see_king_with_bishop(W, From, To) :-
  turn_queens(W, From),
  opponent_king_see(W, To),
  attack_see(W, From, To),
  turn_bishops(W, Bishop),
  attack_see(W, Bishop, To).

queen_bishop_mate(W, From, To) :-
  queen_see_king_with_bishop(W, From, To),
  \+ in_check(W),
  \+ opponent_non_king_capturable(W, To),
  make_capture_move(W, move(From, To), W2),
  \+ turn_king_evadable(W2, _, _),
  \+ in_illegal_check(W2).


candidate(W, Move) :- 
  Move = move(From, To),
  bishop_forks(W, From, To, _, _).
%  queen_mate(W, From, To).



true_positive(W) :-
  uci2(W, _),
  candidate(W, Move),
  uci2(W, Move).

false_positive(W) :-
  uci2(W, _),
  candidate(W, Move),
  \+ uci2(W, Move).

negative(W) :-
  uci2(W, _),
  \+ candidate(W, _).

coverage :-
  findall(W, true_positive(W), LsTp),
  findall(W, false_positive(W), LsFp), 
  findall(W, negative(W), LsN),
  length(LsTp, Tp),
  length(LsFp, Fp),
  length(LsN, N),
  TpFp is Tp + Fp + 1,
  Total is TpFp + N + 1,
  C is TpFp / Total * 100,
  A is Tp / TpFp * 100,
  format('Tp/Fp: ~w/~w N:~w', [Tp, Fp, N]),
  nl,
  format('Coverage: ~2f%, Accuracy: ~2f%', [C, A]).



show_fp :-
  findall(W, false_positive(W), Ls), 
  (take(10, Ls, Ls10), !;
  Ls = Ls10),
  length(Ls, N),
  format('Fp: ~w', N),
  nl,
  show_worlds(Ls10),
  format('Fp: ~w', N),
  nl.


show_tp :-
  findall(W, true_positive(W), Ls), 
  (take(10, Ls, Ls10);
  Ls = Ls10),
  show_worlds(Ls10).

show_negative :-
  findall(W, negative(W), Ls), 
  (take(10, Ls, Ls10);
  Ls = Ls10),
  show_worlds(Ls10).

show_worlds([]).
show_worlds([W|Ws]) :- show_world(W), show_worlds(Ws).

show_world(W) :- 
atom_concat(id_, Id, W),
format('https://lichess.org/training/~w', Id),
nl.


take(N, List, Front) :-
    length(Front, N),
    append(Front, _, List).