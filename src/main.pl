:- module(main, [
    coverage2/0, 
    coverage/0, 
    show_tp/0,
    show_fp/0, 
    show_negative/0,
    show_fn/0,
    show_tn/0
    ]).

:- use_module(positions).
:- use_module(forks).
:- use_module(attacks).
:- use_module(moves).
:- use_module(fen).


queen_evade_mate(W, Move, W4) :-
  Move = move(_, To),
  queen_bishop_capture_evadable(W, Move, W2),
  turn_king_evadable(W2, KingFrom, KingTo),
  make_move(W2, move(KingFrom, KingTo), W3),
  gives_check(W3, To, To2),
  make_move(W3, move(To, To2), W4),
  \+ turn_king_evadable(W4, _, _).

  

queen_evade_mate_capture_rook(W, Move, W4) :-
  Move = move(_, To),
  queen_bishop_capture_evadable(W, Move, W2),
  turn_king_evadable(W2, KingFrom, KingTo),
  make_move(W2, move(KingFrom, KingTo), W3),
  opponent_hanging(W3, rook, HRook),
  attack_see(W3, To, HRook),
  make_capture_move(W3, move(To, HRook), W4),
  \+ turn_king_evadable(W4, _, _).

  

queen_bishop_capture_evadable(W, Move, W2) :-
  %W = id_0BK2g,
  queen_see_king_with_bishop(W, From, To),
  \+ in_check(W),
  \+ opponent_non_king_capturable(W, To),
  make_capture_move(W, move(From, To), W2),
  \+ in_illegal_check(W2),
  Move = move(From, To).



bishop_fork_candidate(W, From, To, Fork_a, Fork_b) :-
  piece_at(W, From, _, bishop),
  piece_at(W, Fork_a, _, rook),
  piece_at(W, Fork_b, _, king),
  fork(W, From, To, Fork_a, Fork_b).


bishop_fork_precheck(W, _From, To) :-
  \+ queen_evade_mate(W, _, _),
  \+ queen_bishop_mate(W, _, To),
  \+ in_check(W).

bishop_fork_post(W, From, To, Fork_a, Fork_b, W_out) :-
  make_move(W, move(From, To), W2),
  \+ in_illegal_check(W2),
  handle_king_capture_scenario(W2, To, W_out),
  handle_non_king_capture_scenario(W2, To, W_out),
  handle_king_evade_scenario(W2, To, Fork_a, Fork_b, W_out).




handle_king_capture_scenario(W2, To, W2) :-
  \+ turn_king_capturable(W2, To).

handle_non_king_capture_scenario(W2, To, W2) :-
  \+ turn_non_king_capturable(W2, To).

handle_king_evade_scenario(W2, To, Fork_a, Fork_b, W_out) :-
  (once(turn_king_evadable(W2, Fork_b, KingTo)) ->
  (make_move(W2, move(Fork_b, KingTo), W3),
  make_capture_move(W3, move(To, Fork_a), W4),
  \+ bad_trade(W4));
  W_out = W2
  ).



bad_trade(W) :-
  opponent_hanging(W, Piece, Sq),
  (Piece = queen; Piece = rook),
  attack_see(W, _, Sq).

bishop_forks(W, Move, W4) :-
  Move = move(From, To),
  bishop_fork_precheck(W, From, To),
  bishop_fork_candidate(W, From, To, Fork_a, Fork_b),
  bishop_fork_post(W, From, To, Fork_a, Fork_b, W4).


bishop_forks_no_post(W, Move) :-
  Move = move(From, To),
  bishop_fork_precheck(W, From, To),
  bishop_fork_candidate(W, From, To, _, _).





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
  bishop_forks(W, Move, _).
%  queen_mate(W, From, To).

candidate_detect_negative(W, Move) :-
  bishop_forks_no_post(W, Move).


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

true_negative(W) :-
  negative(W),
  uci2(W, Move),
  candidate_detect_negative(W, Move2),
  Move \= Move2.

false_negative(W) :-
  negative(W),
  uci2(W, Move),
  candidate_detect_negative(W, Move).

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

coverage2 :-
  findall(W, true_negative(W), LsTn),
  findall(W, false_negative(W), LsFn),
  length(LsTn, Tn),
  length(LsFn, Fn),
  format('Tn/Fn: ~w/~w', [Tn, Fn]),
  nl.

show_fn :-
  findall(W, false_negative(W), Ls), 
  (take(10, Ls, Ls10), !;
  Ls = Ls10),
  show_worlds(Ls10).

show_tn :-
  findall(W, true_negative(W), Ls), 
  (take(10, Ls, Ls10), !;
  Ls = Ls10),
  show_worlds(Ls10).





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