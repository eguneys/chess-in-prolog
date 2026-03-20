:- module(gen_evaluate, [gen/4, evaluate/2, terminal/1]).

:- use_module(moves).
:- use_module(forks).

queen_see_king_with_bishop_candidate(W, From, To) :-
  turn_queens(W, From),
  opponent_king_see(W, To),
  attack_see(W, From, To),
  turn_bishops(W, Bishop),
  attack_see(W, Bishop, To).



bishop_fork_candidate(W, From, To, Fork_a, Fork_b) :-
  piece_at(W, From, _, bishop),
  piece_at(W, Fork_a, _, rook),
  piece_at(W, Fork_b, _, king),
  fork(W, From, To, Fork_a, Fork_b).

candidate_move(W, Ctx, Move, Ctx2) :-
  queen_see_king_with_bishop_candidate(W, From, To),
  Move = move(From, To),
  Ctx2 = Ctx.put(queen_bishop_mate, yes).

candidate_move(W, Ctx, Move, Ctx2) :-
  \+ in_check(W),
  bishop_fork_candidate(W, From, To, Fork_a, Fork_b),
  Move = move(From, To),
  Ctx2 = Ctx.put(bishop_fork, bishop_fork(From, To, Fork_a, Fork_b)).

refutation_move(W, Ctx, Move, Ctx2) :- 
  dict_match(ctx{bishop_fork: bishop_fork(_From, To, _, _)}, Ctx),
  once(turn_king_capturable(W, KingFrom, To)) ->
  (
    Move = move(KingFrom, To),
    Ctx2 = Ctx.put(bishop_fork_king_captures, bishop_fork_king_captures(KingFrom))
  ).



refutation_move(W, Ctx, Move, Ctx2) :- 
  dict_match(ctx{bishop_fork: bishop_fork(_, _, _Fork_a, Fork_b)}, Ctx),
  once(turn_king_evadable(W, Fork_b, KingTo)) ->
  (
    Move = move(Fork_b, KingTo),
    Ctx2 = Ctx.put(bishop_fork_king_evade, yes)
  ).





decisive_terminal(_) :- fail.
evaluate_context(Ctx, 5):- dict_match(ctx{bishop_fork_king_evade: yes},Ctx), !.
evaluate_context(Ctx, 15):- dict_match(ctx{queen_bishop_mate: yes},Ctx), !.
evaluate_context(Ctx, -5):- dict_match(ctx{bishop_fork_king_captures: _},Ctx), !.
evaluate_context(_, -1).




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


% -- Dict Utility -- %
dict_match(Pattern, Dict) :-
    dict_pairs(Pattern, _, Pairs),
    maplist(match_pair(Dict), Pairs).

match_pair(Dict, K-V) :-
    get_dict(K, Dict, V).