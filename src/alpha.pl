:- module(alpha, [solve/4]).

:- use_module(gen_evaluate).
:- use_module(positions).


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

  (Moves = [] ->
    evaluate(State, BestScore),
    BestPV = []
    ; 
    best_max_list(Moves, Depth, Alpha, Beta, BestScore, BestPV)
  ).




best_max_list([Move-Child | Rest], Depth, Alpha, Beta, BestScore, BestPV) :-
  alphabeta(Child, Depth, Alpha, Beta, min, Score, ChildPV),
  CandidatePV = [Move | ChildPV],

  max_update(Alpha, Score, NewAlpha),

  best_max_list_rest(Rest, Depth, NewAlpha, Beta,
                     Score, CandidatePV,
                     BestScore, BestPV).


best_max_list_rest([], _, _, _, BestScore, BestPV, BestScore, BestPV).

best_max_list_rest([Move-Child | Rest], Depth, Alpha, Beta,
                   CurrScore, CurrPV,
                   BestScore, BestPV) :-

  alphabeta(Child, Depth, Alpha, Beta, min, Score, ChildPV),
  CandidatePV = [Move | ChildPV],

  max_update(Alpha, Score, NewAlpha),

  ( NewAlpha >= Beta ->
      BestScore = CurrScore,
      BestPV = CurrPV
  ;
      ( Score > CurrScore ->
          NextScore = Score,
          NextPV = CandidatePV
      ;
          NextScore = CurrScore,
          NextPV = CurrPV
      ),

      best_max_list_rest(Rest, Depth, NewAlpha, Beta,
                         NextScore, NextPV,
                         BestScore, BestPV)
  ).




best_min(State, Depth, Alpha, Beta, BestScore, BestPV) :-
  findall(Move-Child, gen(min, State, Move, Child), Moves),

  (Moves = [] ->
    evaluate(State, BestScore),
    BestPV = []
    ; 
    best_min_list(Moves, Depth, Alpha, Beta, BestScore, BestPV)
  ).



best_min_list([Move-Child | Rest], Depth, Alpha, Beta, BestScore, BestPV) :-
  alphabeta(Child, Depth, Alpha, Beta, min, Score, ChildPV),
  CandidatePV = [Move | ChildPV],

  min_update(Beta, Score, NewBeta),

  best_min_list_rest(Rest, Depth, Alpha, NewBeta,
                     Score, CandidatePV,
                     BestScore, BestPV).


best_min_list_rest([], _, _, _, BestScore, BestPV, BestScore, BestPV).

best_min_list_rest([Move-Child | Rest], Depth, Alpha, Beta,
                   CurrScore, CurrPV,
                   BestScore, BestPV) :-

  alphabeta(Child, Depth, Alpha, Beta, max, Score, ChildPV),
  CandidatePV = [Move | ChildPV],

  min_update(Beta, Score, NewBeta),

  ( Alpha >= NewBeta ->
      BestScore = CurrScore,
      BestPV = CurrPV
  ;
      ( Score < CurrScore ->
          NextScore = Score,
          NextPV = CandidatePV
      ;
          NextScore = CurrScore,
          NextPV = CurrPV
      ),

      best_min_list_rest(Rest, Depth, Alpha, NewBeta,
                         NextScore, NextPV,
                         BestScore, BestPV)
  ).





max_update(A, B, A) :- A >= B, !.
max_update(_, B, B).

min_update(A, B, A) :- A < B, !.
min_update(_, B, B).


solve(W, Depth, Score, PV) :-
  InitialState = state(W, ctx{}),
  alphabeta(InitialState, Depth, -10000, 10000, max, Score, PV).

solve_all(Depth, Score, PV) :-
  uci2(W, _),
  solve(W, Depth, Score, PV).


