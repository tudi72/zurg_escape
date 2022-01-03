construct_list(List,Toy):-construct_list(List,[],Toy).

construct_list([],Toys,Toys):-
    assert(toys(Toys)).

construct_list([[Toy | [Time]] | List],Toys,FToys):-
    assert(time(Toy,Time)),
    append(Toys,[Toy],NewToys),
    construct_list(List,NewToys,FToys).    

define_arcs([Toy| Toys]):-
    define_arcs(Toys,Toy),
    assert(right_to_left(Toy)).

define_arcs([],_).

define_arcs([Head| Toys],Toy):-
    assert(left_to_right(Toy,Head)),
    assert(left_to_right(Head,Toy)),
    define_arcs(Toys,Toy).

compute_time_for_two_toys([],[],0).
compute_time_for_two_toys(_,[],0).
compute_time_for_two_toys([],_,0).
compute_time_for_two_toys(Parent,Kid,ToyTime):-
    time(Parent,Toy1Time),
    time(Kid,Toy2Time),
    ToyTime is max(Toy1Time,Toy2Time).

remove_duplicates([],[]).

remove_duplicates([H | T], List) :- 
    member(H, T),
    remove_duplicates( T, List).

remove_duplicates([H | T], [H|T1]) :- 
    \+member(H, T), 
    remove_duplicates( T, T1).


children(Node,UniqueChildren):-
    findall(C,left_to_right(Node,C),Children),
    remove_duplicates(Children,UniqueChildren).



choose_two_toys([Toy | []],Toy,[],_).           % if there is a list containing only one element, it will choose that one and the second one will be empty
choose_two_toys([],[],[],_).                    % if the list is empty the toys chosen will be both emtpy
choose_two_toys(Agenda,Toy1,Toy2,TimeSlice):-   % if we have an agenda list , we search for two toys to be chosen with respect to timeslice
    member(Toy1,Agenda),                        % we choose the first toy from the agenda list
    member(Toy2,Agenda),                        % we choose the second toy from the agenda list
    time(Toy1,Time1),                           % we compute the time of crossing for the first toy 
    time(Toy2,Time2),                           % we compute the time of crossing for the second toy
    TimeSlice > Time2 - Time1,                  % the time difference between the toys chosen should be smaller than the time slie
    Time1 < Time2.                              % the first toy must be smaller than the second toy

choose_two_toys(Agenda,Toy1,Toy2,TimeSlice):-   % the same code is repeating 
    member(Toy1,Agenda),    
    member(Toy2,Agenda),
    time(Toy1,Time1), 
    time(Toy2,Time2),
    TimeSlice > Time1 - Time2,                  
    Time2 < Time1.                              % the first toy must be bigger than the second toy

move(left(Agenda),right(NewAgenda),left_to_right([Toy1 , Toy2]),ToyTime,TimeSlice) :-   %toys are crossing the bridge to right,we compute the time
    choose_two_toys(Agenda,Toy1,Toy2,TimeSlice),
    subtract(Agenda,[Toy1,Toy2],NewAgenda),                                         % the Agenda will be the list of toys without the two who just crossed
    toys(Toys),
    subtract(NewAgenda,Toys,ToBeListed),
    write('\t'),write(NewAgenda),write('--------'),write([Toy1,Toy2]),write('-------->'),write(ToBeListed),write('\n'),
    one_way_cross([Toy1 ,Toy2],ToyTime).                                            % we compute the time of crossing the two toys

move(right(Agenda),left(NewAgenda),right_to_left(LeftToy),LeftToyTime,_) :-     % one toy will cross back to the right
    toys(Toys),                                                                     % we take the list of toys
    subtract(Toys,Agenda,ToyListTemp),                                              % list of toys which didn't cross the bridge
    member(LeftToy,ToyListTemp),                                                    % we take the toy on the other side of the bridge
    merge_set(Agenda,[LeftToy],NewAgenda),                                          % the agenda will now contain once again the toy who came back      
    subtract(ToyListTemp,[LeftToy],ToBeListed),
    write('\t'),write(Agenda),write(' <--------'),write([LeftToy]),write('----------'),write(ToBeListed),write('\n'),
    time(LeftToy,LeftToyTime).                                                      % we compute the time of crossing for that one toy



search_bf(Goal,Path,Path,Goal,Time,Time).
search_bf([],Path,Path,[],Time,Time).
search_bf([Current | Rest],Path,PathT,Goal,Time,FinalTime,ToysVisited):-
    children(Current,Children),                                 % get all the nodes to be visited next
    append(Children,Rest,TempAgenda),                           % Agenda = [ Rest | Children]
    search_bf(NewAgenda,NewPath,PathT,Goal,NextTime,FinalTime,NewToysVisited). % the recursive call 

solve(Time,Output,Path):-
    construct_list(Output,[T| Toys]),
    define_arcs([T | Toys]),
    search_bf([T | []], [], Path, [], 0,TempTime),
    write(TempTime),
    TempTime =< Time.

delete(X, [X|T], T).
delete(X, [H|T], [H|S]):-
    delete(X, T, S).

permutation([], []).
permutation([H|T], R):-
    permutation(T, X), delete(H, R, X).



goal(List1,List2):- permutation(List1,List2).

