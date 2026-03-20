:- module(coverage, [
    coverage2/0, 
    coverage/0, 
    show_tp/0,
    show_fp/0, 
    show_negative/0,
    show_fn/0,
    show_tn/0
    ]).


:- use_module(positions).
:- use_module(alpha).


candidate(W, Move) :-
  solve(W, 3, Score, [Move|_]),
  Score >= 0.

candidate_detect_negative(W, Move) :-
  solve(W, 3, Score, [Move|_]),
  Score < 0.


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