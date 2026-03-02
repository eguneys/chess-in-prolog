:- module(types, [
  king_square/3,
  attacked_by/3
]).

:- use_module(geometry).
:- use_module(piece_at).


occupies(W, S) :-
  piece_at(W, S, _, _).


knight_attack(_W, From, To) :-
  knight_attack_geom(From, To).

king_attack(_W, From, To) :-
  king_attack_geom(From, To).

pawn_attack(W, From, To) :-
  piece_at(W, From, pawn, Color),
  pawn_attack_geom(From, To, Color).


rook_attack(W, From ,To) :-
  rook_line(From, To),
  \+ (
    blocker_for(From, To, Mid),
    occupies(W, Mid)
  ).

bishop_attack(W, From ,To) :-
  bishop_line(From, To),
  \+ (
    blocker_for(From, To, Mid),
    occupies(W, Mid)
  ).

queen_attack(W, From, To) :-
  rook_attack(W, From, To);
  bishop_attack(W, From, To).


attacks(W, rook, From, To) :- rook_attack(W, From, To).
attacks(W, bishop, From, To) :- bishop_attack(W, From, To).
attacks(W, queen, From, To) :- queen_attack(W, From, To).
attacks(_W, knight, From, To) :- knight_attack(From, To).
attacks(W, pawn, From, To) :- pawn_attack(W, From, To).
attacks(_W, king, From, To) :- king_attack(From, To).


attacked_by(W, AttackerColor, To) :-
  piece_at(W, From, Piece, AttackerColor),
  attacks(W, Piece, From, To).


king_square(W, Color, Sq) :-
  piece_at(W, Sq, king, Color).


has_legal_move(W) :-
  legal_move(W, _).



checkmate(W) :-
  side_to_move(W, Color),
  in_check(W, Color),
  \+ has_legal_move(W).

stalemate(W) :-
  side_to_move(W, Color),
  \+ in_check(W, Color),
  \+ has_legal_move(W).


:- table has_legal_move/1.
:- table occupies/2.