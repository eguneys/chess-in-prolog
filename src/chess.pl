:- use_module(board_manager).



board_move(Board, From, To, BAfter) :- 
select(Piece-From, Board, BFrom),
exclude(_Captured-To, BFrom, BTo),
BAfter = [Piece-To | BTo].

add_world_from_to(W-B, From, To, W2-B2) :- 
board_move(B, From, To, B2),
add_world(W-B, From-To, B2, W2).


b_on_a1([white-bishop-(a-1)]).