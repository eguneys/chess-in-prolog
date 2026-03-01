:- module(node_manager, [
    add_root/0,
    add_move/3,
    get_children/2,
    history_moves/2,
    is_root/1,
    is_leaf/1,
    node_id/1

]).

% --- Node Manager ---

:- dynamic cache_node/1.
:- dynamic cache_edge/3. % Parent, Move, Child
:- dynamic next_id/1.

% Initialize or Reset
add_root :- 
    retractall(cache_node(_)),
    retractall(cache_edge(_, _, _)),
    retractall(next_id(_)),
    assertz(cache_node(0)),  % Root is always 0
    assertz(next_id(1)).     % Next child will be 1

node_id(Node):- cache_node(Node).

add_move(Parent, Move, Child) :-
cache_edge(Parent, Move, Child),
!.

% Add a move: returns the newly created Child ID
add_move(Parent, Move, Child) :-
    cache_node(Parent),
    retract(next_id(Child)),
    Next is Child + 1,
    assertz(next_id(Next)),
    assertz(cache_node(Child)),
    assertz(cache_edge(Parent, Move, Child)).

% Navigation
get_children(Parent, Children) :- 
    findall(Move-Child, cache_edge(Parent, Move, Child), Children).

% Recursively find path from Root to Node
history_moves(Node, Path) :-
    history_moves_rec(Node, [], Path).

% Base case: reached the root (node 0)
history_moves_rec(0, Acc, Acc).
history_moves_rec(Node, Acc, Path) :-
    cache_edge(Parent, Move, Node),
    history_moves_rec(Parent, [Move|Acc], Path).

% Helpers
is_root(0).
is_leaf(Node) :-
    cache_node(Node),
    \+ cache_edge(Node, _, _).

% --- End Node Manager ---