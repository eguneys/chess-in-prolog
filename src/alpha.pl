:- module(alpha, [solve/4]).

:- use_module(gen_evaluate).


alphabeta(State, Depth, _, _, _, Score, []) :-
  (Depth =:= 0; terminal(State)),
  !,
  evaluate(State, Score).

alphabeta(State, Depth, Alpha, Beta, max, Score, PV) :-
  NewDepth is Depth - 1,
  best_max(State, NewDepth, Alpha, Beta, Score, PV).

alphabeta(State, Depth, Alpha, Beta, min, Score, PV) :-
  NewDepth is Depth - 1,
  best_min(State, NewDepth, Alpha, Beta, Score, PV).


best_max(State, Depth, Alpha, Beta, BestScore, BestPV) :-
  findall(Move-Child, gen(max, State, Move, Child), Moves),
  best_max_list(Moves, Depth, Alpha, Beta, BestScore, BestPV).


best_max_list([], _, Alhpa, _, BestScore, BestPV) :-
  BestScore = Alhpa,
  BestPV = [].

best_max_list([Move-Child | Rest], Depth, Alpha, Beta, BestScore, BestPV) :-
  alphabeta(Child, Depth, Alpha, Beta, min, Score, ChildPV),
  CandidatePV = [Move | ChildPV],

  max_update(Alpha, Score, NewAlpha),

  (NewAlpha >= Beta ->
    BestScore = Score,
    BestPV = CandidatePV
  ;
    best_max_list(Rest, Depth, NewAlpha, Beta, NextScore, NextPV),

    (Score > NextScore ->
        BestScore = Score,
        BestPV = CandidatePV
      ;
        BestScore = NextScore,
        BestPV = NextPV
    )
  ).
    

best_min_list([], _, _, Beta, BestScore, BestPV) :-
  BestScore = Beta,
  BestPV = [].

best_min_list([Move-Child | Rest], Depth, Alpha, Beta, BestScore, BestPV) :-
  alphabeta(Child, Depth, Alpha, Beta, max, Score, ChildPV),

  CandidatePV = [Move | ChildPV],

  min_update(Beta, Score, NewBeta),

  ( Alpha >= NewBeta ->
      BestScore = NewBeta,
      BestPV = CandidatePV
  ;
      best_min_list(Rest, Depth, Alpha, NewBeta, NextScore, NextPV),

      ( Score < NextScore ->
          BestScore = Score,
          BestPV = CandidatePV
      ;
          BestScore = NextScore,
          BestPV = NextPV
      )
  ).

max_update(A, B, A) :- A >= B, !.
max_update(_, B, B).

min_update(A, B, A) :- A < B, !.
min_update(_, B, B).


solve(W, Depth, Score, PV) :-
  InitialState = state(W, ctx{}),
  alphabeta(InitialState, Depth, -10000, 10000, max, Score, PV).
