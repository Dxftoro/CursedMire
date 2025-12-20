:- use_module(library(socket)).
:- use_module(library(random)).
:- dynamic socket_stream/2.
:- dynamic current_room/1.
:- dynamic inventory/1.

get_streams(In, Out) :-
    socket_stream(in, In),
    socket_stream(out, Out).

main :-
    tcp_socket(Socket),
    tcp_connect(Socket, 'localhost':3333),
    tcp_open_socket(Socket, In, Out),
    asserta(socket_stream(in, In)),
    asserta(socket_stream(out, Out)),
    
    read_line_to_string(In, _),
    
    format(Out, 'Emelya~n', []),
    flush_output(Out),
    
    main_loop.

main_loop :-
    get_streams(In, Out),

    look_environment(Environment),
    grab_random_item(Environment),
    move_randomly,

    sleep(2),
    main_loop.

look_environment(LookResponse) :- 
    get_streams(In, Out),
    format(Out, 'look~n', []), flush_output(Out),
    read_line_to_string(In, LookResponse),
    writeln(LookResponse).

grab_random_item(Environment) :-
    get_streams(In, Out),
    extract_items(Environment, Items),
    (Items \= [] -> 
        random_member(Item, Items),
        grab_item(Out, In, Item) ; 
        true
    ).

move_randomly :-
    get_streams(In, Out),
    random_member(Dir, [north, south, east, west]),
    format(Out, 'move ~w~n', [Dir]), flush_output(Out),
    read_line_to_string(In, MoveResponse),
    writeln(MoveResponse).

extract_items(Response, Items) :-
    split_string(Response, "\n", "", Lines),

    findall(Item, (
        member(Line, Lines),
        extract_item_from(Line, Item)
    ), Items).

extract_item_from(Line, Item) :-
    writeln('NOT SIMPLE'),
    sub_string(Line, _, _, _, "There is"),
    sub_string(Line, StartPos, _, _, "There is "),

    AfterIsPos is StartPos + 9,
    sub_string(Line, AfterIsPos, RestLen, 0, RestOfLine),
    sub_string(RestOfLine, ItemEnd, _, _, " here"),

    sub_string(RestOfLine, 0, ItemEnd, _, ItemStrWithColon),
    (sub_string(ItemStrWithColon, 0, 1, _, ":") ->
        sub_string(ItemStrWithColon, 1, _, 0, CleanItemStr)
    ;
        CleanItemStr = ItemStrWithColon
    ),
    atom_string(Item, CleanItemStr).

extract_item_from(Line, Item, simple) :-
    known_item(Item),
    atom_string(Item, ItemStr),
    sub_string(Line, _, _, _, ItemStr).

known_item(wire).
known_item(metalpipe).
known_item(bunny).
known_item(sock).
known_item(bottle).
known_item(plafon).
known_item(detector).
known_item(air_purifier).
known_item(emmiter).
known_item(keys).
known_item(turtle).
known_item(knife).
known_item(rope).

grab_item(Out, In, Item) :-
    atom_string(Item, ItemStr),
    format('Trying to grab: ~w~n', [ItemStr]),
    format(Out, 'grab ~w~n', [ItemStr]), 
    flush_output(Out),
    read_line_to_string(In, GrabResponse),
    writeln(GrabResponse).