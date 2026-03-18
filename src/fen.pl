:- module(fen, [show_board/1]).

:- use_module(moves).


file(a).  file(b).  file(c).  file(d).  file(e).  file(f).  file(g).  file(h).
rank(8).  rank(7).  rank(6).  rank(5).  rank(4).  rank(3).  rank(2).  rank(1).

piece_symbol(pawn,white,'P').
piece_symbol(knight,white,'N').
piece_symbol(bishop,white,'B').
piece_symbol(rook,white,'R').
piece_symbol(queen,white,'Q').
piece_symbol(king,white,'K').

piece_symbol(pawn,black,'p').
piece_symbol(knight,black,'n').
piece_symbol(bishop,black,'b').
piece_symbol(rook,black,'r').
piece_symbol(queen,black,'q').
piece_symbol(king,black,'k').

square(File, Rank, Sq) :-
  atom_concat(File, Rank, Sq).



show_board(W) :-
    forall(rank(R),
        ( forall(file(F),
            ( square(F,R,Sq),
              ( piece_at(W,Sq,C,P)
                -> piece_symbol(P,C,S)
                ;  S='.'
              ),
              write(S), write(' ')
            )),
          nl
        )),
    nl.