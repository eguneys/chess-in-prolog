:- module(piece_at, [
    piece_at/4
]).

:- dynamic base_piece_at/4.
:- dynamic base_side_to_move/2.
:- dynamic base_castle_right/3.

:- dynamic base_half_move/2.
:- dynamic base_full_move/2.

:- dynamic parent/2.
:- dynamic delta_del/4.
:- dynamic delta_add/4.

:- dynamic delta_no_castle/3.

:- dynamic delta_ep_add/2.
:- dynamic delta_ep_clear/2.

:- dynamic delta_halfmove_reset/1.
:- dynamic delta_halfmove_inc/1.


:- table piece_at/4.
:- table in_check/2.

piece_at(W, Sq, P, C) :-
  delta_add(W, Sq, P, C).

piece_at(W, Sq, P, C) :-
   parent(W, Parent),
   piece_at(Parent, Sq, P, C),
   \+ delta_del(W, Sq, P, C).

piece_at(root, Sq, P, C) :-
  base_piece_at(root, Sq, P, C).


side_to_move(root, Color) :-
  base_side_to_move(root, Color).

side_to_move(W, Color) :-
 parent(W, P),
 side_to_move(P, Other),
 opposite_color(Other, Color).

opposite_color(white, black).
opposite_color(black, white).

castle_right(root, Color, Side) :-
  base_castle_right(root, Color, Side).

castle_right(W, Color, Side) :-
  parnet(W, P),
  castle_right(P, Color, Side),
  \+ delta_no_castle(W, Color, Side).


ep_square(W, Sq) :-
  delta_ep_add(W, Sq).

ep_square(W, Sq) :-
  parent(W, P),
  ep_square(P, Sq),
  \+ delta_ep_clear(W).


halfmove(root, N) :-
  base_half_move(root, N).

halfmove(W, 0) :-
  delta_halfmove_reset(W).

halfmove(W, N1) :-
  parent(W, P),
  halfmove(P, N),
  delta_halfmove_inc(W),
  N1 is N + 1.


fullmove(root, N) :-
  base_full_move(root, N).

fullmove(W, N) :-
  parent(W, P),
  fullmove(P, N).

fullmove(W, N1) :-
  parent(W, P),
  fullmove(P, N),
  side_to_move(P, black),
  side_to_move(W, white),
  N1 is N + 1.


legal_move(W, Move) :-
  side_to_move(W, Color),
  piece_at(W, From, Piece, Color),
  pseudo_legal_move(W, From, Piece, Move),
  \+ leaves_king_in_check(W, Move).


leaves_king_in_check(W, Move) :-
  side_to_move(W, Color),
  hyp_world(W, Move, W2),
  in_check(W2, Color).

hyp_world(W, Move, W2) :-
  parent(W2, W),
  delta_for_move(W2, Move).

in_check(W, Color) :-
  king_square(W, Color, KingSq),
  opposite_color(Color, Opp),
  attacked_by(W, Opp, KingSq).



% delta_for_move(W, Move).
  % asserts delta_del delta_add castling ep etc.


/*
% No Castling logic yet
play_from_to(W, From, To, W2) :-
 assertz(parent(W2, W)),
 piece_at(W, From, Piece, Color),
 assertz(delta_del, W, From, Piece, Color),
 assertz(delta_add, W, To, Piece, Color),
 piece_at(W, To, CapturedPiece, CapturedColor) ->
 assertz(delta_del, W, To, CapturedPiece, CapturedColor).
 */

