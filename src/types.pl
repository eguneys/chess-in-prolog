:- module(types, [
    up/2,
    down/2,
    left/2,
    right/2,
    up2/2,
    down2/2,
    left2/2,
    right2/2,
    up_left/2,
    down_left/2,
    up_right/2,
    down_right/2,

    up2_left/2,
    up2_right/2,
    down2_left/2,
    down2_right/2,
    up_left2/2,
    up_right2/2,
    down_left2/2,
    down_right2/2,
    diagonal/2,
    orthogonal/2,
    lwise/2,
    kingzone/2,

    up_sliding/2,
    down_sliding/2,
    left_sliding/2,
    right_sliding/2,
    up_right_sliding/2,
    up_left_sliding/2,
    down_left_sliding/2,
    down_right_sliding/2,

    up_sliding_stop/3,
    down_sliding_stop/3,
    left_sliding_stop/3,
    right_sliding_stop/3,

    up_right_sliding_stop/3,
    up_left_sliding_stop/3,
    down_right_sliding_stop/3,
    down_left_sliding_stop/3
]).


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

up_rank(1, 2).
up_rank(2, 3).
up_rank(3, 4).
up_rank(4, 5).
up_rank(5, 6).
up_rank(6, 7).
up_rank(7, 8).

down_rank(Two, One) :- up_rank(One, Two).

up(A-One, A-Two) :- up_rank(One, Two).
down(Two, One) :- up(One, Two).

right_file(a, b).
right_file(b, c).
right_file(c, d).
right_file(d, e).
right_file(e, f).
right_file(f, g).
right_file(g, h).

left_file(B, A) :- right_file(A, B).

right(A-R, B-R) :- right_file(A, B).
left(B, A) :- right(A, B).

down2(Three, One) :- down(Three, Two), down(Two, One).
up2(Three, One) :- up(Three, Two), up(Two, One).
right2(Three, One) :- right(Three, Two), right(Two, One).
left2(Three, One) :- left(Three, Two), left(Two, One).


up_left(B-One, A-Two) :- left_file(B, A), up_rank(One, Two).
down_left(B-Two, A-One) :- left_file(B, A), down_rank(Two, One).
up_right(A-One, B-Two) :- right_file(A, B), up_rank(One, Two).
down_right(A-Two, B-One) :- right_file(A, B), down_rank(Two, One).


up2_left(BOne, AThree) :- up2(BOne, BThree), left(BThree, AThree).
up2_right(BOne, CThree) :- up2(BOne, BThree), right(BThree, CThree).
down2_left(BThree, AOne) :- down2(BThree, BOne), left(BOne, AOne).
down2_right(AThree, BOne) :- down2(AThree, AOne), right(AOne, BOne).

up_left2(COne, ATwo) :- up(COne, CTwo), left2(CTwo, ATwo).
up_right2(AOne, CTwo) :- up(AOne, ATwo), right2(ATwo, CTwo).
down_left2(CTwo, AOne) :- down(CTwo, COne), left2(COne, AOne).
down_right2(ATwo, COne) :- down(ATwo, AOne), right2(AOne, COne).


orthogonal(A, B) :- up(A, B).
orthogonal(A, B) :- down(A, B).
orthogonal(A, B) :- left(A, B).
orthogonal(A, B) :- right(A, B).


diagonal(A, B) :- up_left(A, B).
diagonal(A, B) :- up_right(A, B).
diagonal(A, B) :- down_left(A, B).
diagonal(A, B) :- down_right(A, B).


lwise(A, B) :- up2_left(A, B).
lwise(A, B) :- up2_right(A, B).
lwise(A, B) :- down2_left(A, B).
lwise(A, B) :- down2_right(A, B).
lwise(A, B) :- up_left2(A, B).
lwise(A, B) :- up_right2(A, B).
lwise(A, B) :- down_left2(A, B).
lwise(A, B) :- down_right2(A, B).


kingzone(A, B) :- orthogonal(A, B).
kingzone(A, B) :- diagonal(A, B).


up_sliding(_, []).
up_sliding(One, [Two|Tt]) :- up(One, Two), up_sliding(Two, Tt).

down_sliding(_, []).
down_sliding(Two, [One|Tt]) :- down(Two, One), down_sliding(One, Tt).

left_sliding(_, []).
left_sliding(B, [A|Tt]) :- left(B, A), left_sliding(A, Tt).

right_sliding(_, []).
right_sliding(A, [B|Tt]) :- right(A, B), right_sliding(B, Tt).


up_right_sliding(_, []).
up_right_sliding(A, [B|Tt]) :- up_right(A, B), up_right_sliding(B, Tt).

up_left_sliding(_, []).
up_left_sliding(A, [B|Tt]) :- up_left(A, B), up_left_sliding(B, Tt).

down_right_sliding(_, []).
down_right_sliding(A, [B|Tt]) :- down_right(A, B), down_right_sliding(B, Tt).

down_left_sliding(_, []).
down_left_sliding(A, [B|Tt]) :- down_left(A, B), down_left_sliding(B, Tt).


up_sliding_stop(_, _, []).
up_sliding_stop(X, Stop, [Stop]) :- up(X, Stop).
up_sliding_stop(X, Stop, [Y|Rest]) :- up(X, Y), Y \= Stop,
up_sliding_stop(Y, Stop, Rest).

down_sliding_stop(_, _, []).
down_sliding_stop(X, Stop, [Stop]) :- down(X, Stop).
down_sliding_stop(X, Stop, [Y|Rest]) :- down(X, Y), Y \= Stop,
down_sliding_stop(Y, Stop, Rest).

left_sliding_stop(_, _, []).
left_sliding_stop(X, Stop, [Stop]) :- left(X, Stop).
left_sliding_stop(X, Stop, [Y|Rest]) :- left(X, Y), Y \= Stop,
left_sliding_stop(Y, Stop, Rest).

right_sliding_stop(_, _, []).
right_sliding_stop(X, Stop, [Stop]) :- right(X, Stop).
right_sliding_stop(X, Stop, [Y|Rest]) :- right(X, Y), Y \= Stop,
right_sliding_stop(Y, Stop, Rest).

up_right_sliding_stop(_, _, []).
up_right_sliding_stop(X, Stop, [Stop]) :- up_right(X, Stop).
up_right_sliding_stop(X, Stop, [Y|Rest]) :- up_right(X, Y), Y \= Stop,
up_right_sliding_stop(Y, Stop, Rest).

up_left_sliding_stop(_, _, []).
up_left_sliding_stop(X, Stop, [Stop]) :- up_left(X, Stop).
up_left_sliding_stop(X, Stop, [Y|Rest]) :- up_left(X, Y), Y \= Stop,
up_left_sliding_stop(Y, Stop, Rest).


down_right_sliding_stop(_, _, []).
down_right_sliding_stop(X, Stop, [Stop]) :- down_right(X, Stop).
down_right_sliding_stop(X, Stop, [Y|Rest]) :- down_right(X, Y), Y \= Stop,
down_right_sliding_stop(Y, Stop, Rest).

down_left_sliding_stop(_, _, []).
down_left_sliding_stop(X, Stop, [Stop]) :- down_left(X, Stop).
down_left_sliding_stop(X, Stop, [Y|Rest]) :- down_left(X, Y), Y \= Stop,
down_left_sliding_stop(Y, Stop, Rest).


pawn_forward(white, A, B) :- up(A, B).
pawn_forward(black, A, B) :- down(A, B).

pawn_forward2(white, A, B) :- up2(A, B).
pawn_forward2(black, A, B) :- down2(A, B).


castle_short_king(e-1, g-1).
castle_short_king(e-8, g-8).

castle_short_rook(h-1, f-1).
castle_short_rook(h-8, f-8).

castle_long_king(e-1, c-1).
castle_long_king(e-8, c-8).

castle_long_rook(a-1, d-1).
castle_long_rook(a-8, d-8).


:- dynamic occupies/2.
:- dynamic piece_at/4.

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