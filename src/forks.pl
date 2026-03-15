:- module(forks, [
  turn/3,
  opponent/3,
  vacant_see/3,
  attack_see/3,
  defend_see/3,
  turn_kings/2,
  turn_bishops/2,
  opponent_kings/2,
  opponent_bishops/2,
  opponent_rooks/2,
  opponent_see/3,
  vacant_see2/4,
  attack_see2/4,
  defend_see2/4,
  fork/5
]).

:- use_module(attacks).

turn(W, Role, From) :-
  side_to_move(W, Color),
  piece_at(W, From, Color, Role).


opponent(W, Role, From) :-
  opposite_side(W, Color),
  piece_at(W, From, Color, Role).

vacant_see(W, From, To) :-
  piece_at(W, From, _, Piece),
  attacks(W, Piece, From, To),
  empty(W, To).


attack_see(W, From, To) :-
  opposite(Color, Opp),
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  piece_at(W, To, Opp, _).


defend_see(W, From, To) :-
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  piece_at(W, To, Color, _).


turn_kings(W, From) :- turn(W, king, _, From).
turn_bishops(W, From) :- turn(W, bishops, _, From).

opponent_kings(W, From) :- opponent(W, king, From).
opponent_bishops(W, From) :- opponent(W, bishops, From).
opponent_rooks(W, From) :- opponent(W, rooks, From).


opponent_see(W, From, To) :- opponent(W, _, From), 
attack_see(W, From, To).

opponent_see(W, From, To) :- opponent(W, _, From), 
defend_see(W, From, To).

opponent_see(W, From, To) :- opponent(W, _, From), 
vacant_see(W, From, To).


vacant_see2(W, From, To, To2) :- 
  piece_at(W, From, _, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_off(W, From), Piece, To, To2),
  empty(W, To2),
  From \= To2.



attack_see2(W, From, To, To2) :- 
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_off(W, From), Piece, To, To2),
  opposite(Color, Opp),
  piece_at(W, To2, Opp, _),
  From \= To2.

defend_see2(W, From, To, To2) :- 
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_off(W, From), Piece, To, To2),
  piece_at(W, To2, Color, _),
  From \= To2.

fork(W, From, To, Fork_a, Fork_b) :-
  attack_see2(W, From, To, Fork_a),
  attack_see2(W, From, To, Fork_b),
  Fork_a \= Fork_b.