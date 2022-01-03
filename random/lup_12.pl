arc(buzz,woody).
arc(buzz,rex).
arc(buzz,hamm).
arc(woody,buzz).
arc(woody,hamm).
arc(hamm,buzz).
goal([]).

children(Node,Children):-
    findall(C,arc(Node,C),Children).

add_df([],Agenda,_,Agenda).
add_df([Child|Rest],OldAgenda,Visited,[Child|NewAgenda]):-
    not(member(Child,OldAgenda)),
    not(member(Child,Visited)),
    add_df(Rest,OldAgenda,Visited,NewAgenda).

add_df([Child|Rest],OldAgenda,Visited,NewAgenda):-
    member(Child,OldAgenda),
    add_df(Rest,OldAgenda,Visited,NewAgenda).

add_df([Child|Rest],OldAgenda,Visited,NewAgenda):-
    member(Child,Visited),
    add_df(Rest,OldAgenda,Visited,NewAgenda).


search_df_loop([Goal | _],_,Goal).
search_df_loop([Current | Rest],Visited,Goal):-
    children(Current,Children),
    add_df(Children,Rest,Visited,NewAgenda),
    write('Agenda: '),write([Current | Rest]),write('  New Agenda: '),write(NewAgenda),write('\n'),
    search_df_loop(NewAgenda,[Current | Visited],Goal).

solve(List,Goal):-
    search_df_loop(List,[],Goal).



