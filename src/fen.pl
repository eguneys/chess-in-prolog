:- module(fen, [
    load_fen/1
]).

:- use_module(node_id).
:- use_module(piece_at).

starting_position("rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1").

%% load_fen(+FenString)
%% Clears state and creates root world from FEN
load_fen(FEN) :-
  reset_worlds,
  split_string(FEN, " ", "", [Board, Turn, Castle, Ep | _]),
  load_board(Board),
  load_turn(Turn),
  load_castling(Castle),
  load_ep(Ep).

load_board(BoardStr) :-
  split_string(BoardStr, "/", "", Ranks),
  load_ranks(Ranks, 8).

load_ranks([], _).
load_ranks([R|Rs], Rank) :-
  load_rank(R, Rank, a),
  Rank1 is Rank - 1,
  load_ranks(Rs, Rank1).

load_rank([], _, _).
load_rank(Str, Rank, File) :-
  string_chars(Str, [C|Cs]),
  ( char_type(C, digit)
    -> atom_number(C, N),
       file_advance(File, N, File1),
       load_rank(Cs, Rank, File1)
    ;  piece_char(C, Piece, Color),
       square(File, Rank, Sq),
       assert(base_piece_at(root, Sq, Piece, Color)),
       file_advance(File, 1, File1),
       load_rank(Cs, Rank, File1)
    ).


piece_char('P', pawn, white).
piece_char('N', knight, white).
piece_char('B', bishop, white).
piece_char('R', rook, white).
piece_char('Q', queen, white).
piece_char('K', king, white).

piece_char('p', pawn, black).
piece_char('n', knight, black).
piece_char('b', bishop, black).
piece_char('r', rook, black).
piece_char('q', queen, black).
piece_char('k', king, black).


file_advance(File, N, File2) :-
  char_code(File, C),
  C2 is C + N,
  char_code(File2, C2).

square(File, Rank, Sq) :-
  atom_concat(File, Rank, Sq).

load_turn("w") :-
  assert(base_side_to_move(root, white)).

load_turn("b") :-
  assert(base_side_to_move(root, black)).


load_castling("-") :- !.
load_castling(Str) :-
  string_chars(Str, Cs),
  forall(member(C, Cs), load_castle_char(C)).

load_castle_char('K') :- assert(base_castle_right(rootk, white, king_side)).
load_castle_char('Q') :- assert(base_castle_right(rootk, white, queen_side)).
load_castle_char('k') :- assert(base_castle_right(rootk, black, king_side)).
load_castle_char('q') :- assert(base_castle_right(rootk, black, queen_side)).

load_ep('-') :- !.
  load_ep(Sq) :-
  atom_string(A, Sq),
  assert(base_ep_square(root, A)).

