:- module(puzzle_loader, [
    run_puzzle_csv/1
]).

:- use_module(library(csv)).
:- use_module(fen).


run_puzzle_csv(File) :-
  csv_read_file(File, Rows, [functor(row), arity(_)]),
  run_rows(Rows, 0, 0).


run_rows([], Total, Failed) :-
  format("Done. Total: ~w Failed: ~w~n", [Total, Failed]).


run_rows([Row|Rs], Total0, Failed0) :-
  Total is Total0 + 1,
  ( puzzle_row_ok(Row)
  -> Failed = Failed0
  ; Failed is Failed0 + 1
  ),
  run_rows(Rs, Total, Failed).

puzzle_row_ok(Row) :-
  Row =.. [_|Fields],
  member(fen=Fen, Fields),
  !,
  run_puzzle_fen(Fen).


run_puzzle_fen(FEN) :-
  catch(
    (
        load_fen(FEN),
        sanity_fen
    ),
    Error,
    (
        print_message(error, Error),
        fail
    )
  ).


  sanity_fen.