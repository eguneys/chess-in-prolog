:- module(main, [
    setup/0
]).

:- use_module(piece_at).
:- use_module(types).

base_side_to_move(Color) :-
  assertz(base_side_to_move(root, Color)).

base_root_piece_at(Sq, Color, Role) :-
  assertz(base_piece_at(root, Sq, Role, Color)).


setup() :-
base_root_piece_at(c3, white, king),
base_root_piece_at(g3, black, king),
base_root_piece_at(c1, white, rook).


