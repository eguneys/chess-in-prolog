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
  fork/5,

  turn_queens/2,
  opponent_king_see/2,
  opponent_non_king_capturable/2,
  opponent_king_evadable/2,
  turn_king_evadable/3,
  turn_non_king_capturable/3,
  opponent_king_capturable/2,
  turn_king_capturable/3,

  in_check/1,
  in_illegal_check/1,


  opponent_hanging/3,

  gives_check/3
]).

:- use_module(attacks).
:- use_module(moves).

turn(W, Role, From) :-
  side_to_move(W, Color),
  piece_at(W, From, Color, Role).


opponent(W, Role, From) :-
  opposite_side(W, Color),
  piece_at(W, From, Color, Role).

vacant_see(W, From, To) :-
  piece_at(W, From, Color, Piece),
  (
    Piece = pawn ->
    pawn_attacks(Color, From, To);
    attacks(W, Piece, From, To)
  ),
  empty(W, To).

attack_see(W, From, To) :-
  opposite(Color, Opp),
  piece_at(W, From, Color, Piece),
  (
    Piece = pawn ->
    pawn_attacks(Color, From, To);
    attacks(W, Piece, From, To)
  ),
  piece_at(W, To, Opp, _).


vacant_or_attack_see(W, From, To) :-
  vacant_see(W, From, To);
  attack_see(W, From, To).

defend_see(W, From, To) :-
  piece_at(W, From, Color, Piece),
  (
    Piece = pawn ->
    pawn_attacks(Color, From, To);
    attacks(W, Piece, From, To)
  ),
  piece_at(W, To, Color, _).

turn_kings(W, From) :- turn(W, king, From).
turn_bishops(W, From) :- turn(W, bishop, From).
turn_queens(W, From) :- turn(W, queen, From).

opponent_kings(W, From) :- opponent(W, king, From).
opponent_bishops(W, From) :- opponent(W, bishop, From).
opponent_rooks(W, From) :- opponent(W, rook, From).

turn_see(W, From, To) :- turn(W, _, From), 
attack_see(W, From, To).

turn_see(W, From, To) :- turn(W, _, From), 
defend_see(W, From, To).

turn_see(W, From, To) :- turn(W, _, From), 
vacant_see(W, From, To).


opponent_see(W, From, To) :- opponent(W, _, From), 
attack_see(W, From, To).

opponent_see(W, From, To) :- opponent(W, _, From), 
defend_see(W, From, To).

opponent_see(W, From, To) :- opponent(W, _, From), 
vacant_see(W, From, To).


vacant_see2(W, From, To, To2) :- 
  piece_at(W, From, _, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_take(W, From), Piece, To, To2),
  empty(W, To2),
  From \= To2.



attack_see2(W, From, To, To2) :- 
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_take(W, From), Piece, To, To2),
  opposite(Color, Opp),
  piece_at(W, To2, Opp, _),
  From \= To2.

defend_see2(W, From, To, To2) :- 
  piece_at(W, From, Color, Piece),
  attacks(W, Piece, From, To),
  attacks(hyp_take(W, From), Piece, To, To2),
  piece_at(W, To2, Color, _),
  From \= To2.

fork(W, From, To, Fork_a, Fork_b) :-
  vacant_or_attack_see(W, From, To),
  attack_see2(W, From, To, Fork_a),
  attack_see2(W, From, To, Fork_b),
  Fork_a \= Fork_b.


opponent_king_see(W, To) :- 
  opponent_kings(W, From),
  opponent_see(W, From, To).


opponent_non_king_capturable(W, To) :-
  opponent_see(W, From, To),
  opponent(W, Piece, From),
  Piece \= king.

opponent_king_evadable(W, To) :-
  opponent(W, king, From),
  vacant_or_attack_see(W, From, To),
  \+ turn_see(W, _, To).

turn_king_evadable(W, From, To) :-
  turn(W, king, From),
  vacant_or_attack_see(W, From, To),
  \+ opponent_see(W, _, To),
  make_move(W, move(From, To), W2),
  \+ turn_see(W2, _, To).

opponent_king_capturable(W, To) :-
  opponent(W, king, From),
  attack_see(W, From, To),
  \+ turn_see(W, _, To).

turn_non_king_capturable(W, From, To) :-
  turn_see(W, From, To),
  turn(W, Piece, From),
  Piece \= king.



turn_king_capturable(W, From, To) :-
  turn(W, king, From),
  attack_see(W, From, To),
  \+ opponent_see(W, _, To).



in_check(W) :-
  turn_kings(W, From),
  opponent_see(W, _, From).

in_illegal_check(W) :-
  opponent_kings(W, From),
  turn_see(W, _, From).



opponent_hanging(W, Piece, From) :-
  opponent(W, Piece, From),
  \+ opponent_see(W, _, From).



gives_check(W, From, To) :-
  opponent_kings(W, King),
  attack_see2(W, From, To, King).