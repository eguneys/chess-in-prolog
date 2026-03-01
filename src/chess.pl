:- use_module(board_manager).

is_a_color(white).
is_a_color(black).

opposite(white, black).
opposite(black, white).

is_a_role(bishop).
is_a_role(rook).
is_a_role(knight).
is_a_role(queen).
is_a_role(king).
is_a_role(pawn).


is_a_file(a).
is_a_file(b).
is_a_file(c).
is_a_file(d).
is_a_file(e).
is_a_file(f).
is_a_file(g).
is_a_file(h).

is_a_rank(1).
is_a_rank(2).
is_a_rank(3).
is_a_rank(4).
is_a_rank(5).
is_a_rank(6).
is_a_rank(7).
is_a_rank(8).

is_a_square(F-R) :- is_a_file(F), is_a_rank(R).

is_a_piece(Color-Role) :- is_a_color(Color), is_a_role(Role).

is_a_board([]).
is_a_board([Piece-Square|Rest]) :- is_a_piece(Piece), is_a_square(Square), is_a_board(Rest).


board_move(Board, From, To, BAfter) :- 
select(Piece-From, Board, BFrom),
exclude(_Captured-To, BFrom, BTo),
BAfter = [Piece-To | BTo].

add_world_from_to(W-B, From, To, W2B2) :- 
board_move(B, From, To, B2),
W2B2 = _W2-B2,
add_world(W, From-To, W2B2).


root_world_with_legality(B) :- add_root_world(B).

b_on_a1([white-bishop-(a-1)]).