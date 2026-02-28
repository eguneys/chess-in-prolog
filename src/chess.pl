:- use_module(node_manager, [
    node_id/1,
    add_root
 ]).

color(white).
color(black).

opposite(white, black).
opposite(black, white).

role(bishop).
role(rook).
role(knight).
role(queen).
role(king).
role(pawn).


file(a).
file(b).
file(c).
file(d).
file(e).
file(f).
file(g).
file(h).

rank(1).
rank(2).
rank(3).
rank(4).
rank(5).
rank(6).
rank(7).
rank(8).

square(F-R) :- file(F), rank(R).

piece(Color-Role) :- color(Color), role(Role).

board([]).
board([Piece-Square|Rest]) :- piece(Piece), square(Square), board(Rest).

world_id(W) :- node_id(W).

world(W-B) :- world_id(W), board(B).

turn(W, From, Role, Color) :- world(W), square(From), role(Role), color(Color).
opponent(W, From, Role, Color) :- world(W), square(From), role(Role), color(Color).



world_state(0-[white-bishop-(a-1)]).