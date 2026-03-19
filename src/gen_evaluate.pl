:- module(gen_evaluate, [gen/4, evaluate/2, terminal/1]).

:- use_module(moves).
:- use_module(forks).


bishop_fork_candidate(W, From, To, Fork_a, Fork_b) :-
  piece_at(W, From, _, bishop),
  piece_at(W, Fork_a, _, rook),
  piece_at(W, Fork_b, _, king),
  fork(W, From, To, Fork_a, Fork_b).



candidate_move(W, Ctx, Move, Ctx) :-
  bishop_fork_candidate(W, From, To, Fork_a, Fork_b),
  Move = move(From, To).




decisive_terminal(_) :- fail.
evaluate_context(_, 0).




gen(max, state(W, Ctx), Move, state(W2, Ctx2)) :-
  candidate_move(W, Ctx, Move, Ctx2),
  make_move(W, Move, W2).


gen(min, state(W, Ctx), Move, state(W2, Ctx2)) :-
  refutation_move(W, Ctx, Move, Ctx2),
  make_move(W, Move, W2).

evaluate(state(_, Ctx), Score) :-
  evaluate_context(Ctx, Score).

terminal(state(_, Ctx)) :-
   decisive_terminal(Ctx).
