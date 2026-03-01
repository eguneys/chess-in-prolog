:- module(board_manager, [
    is_world/1,
    add_world/4,
    add_root_world/1
]).

:- use_module(node_manager).

:- dynamic world_board/2.

is_world(W-B) :-
  node_id(W),
  world_board(W, B).

add_world(W-B, Move, NewBoard, Child) :-
  is_world(W-B),
  is_world(Child-NewBoard),
  add_move(W, Move, Child),
  !.

add_world(W-B, Move, NewBoard, Child) :-
  is_world(W-B),
  add_move(W, Move, Child),
  assertz(world_board(Child, NewBoard)).


add_root_world(Board) :-
add_root(),
retractall(world_board(_, _)),
assertz(world_board(0, Board)).