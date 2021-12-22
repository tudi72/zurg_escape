% try to construct the list of facts regarding the toys and times 
construct_list(List,Toy):-construct_list(List,[],Toy).
construct_list([],Toys,Toys):-
    assert(toys(Toys)).
construct_list([[Toy | Time] | List],Toys,FToys):-
    assert(time(Toy,Time)),
    construct_list(List,[Toy | Toys],FToys).    

% the time if no toy crosses the bridge is zero
one_way_cross([],0).

% the time spent for two toys if they want to cross in one direction the bridge
one_way_cross([Toy1 | Toy2],ToyTime):-
    time(Toy1,Toy1Time),
    time(Toy2,Toy2Time),
    ToyTime is max(Toy1Time,Toy2Time).


% choose two toys out of the list to cross the bridge
choose_two_toys(ToyList,[Toy1,Toy2],ToyListAfter) :-
    member(Toy1,ToyList),
    member(Toy2,ToyList),
    compare(<,Toy1,Toy2),
    subtract(ToyList,[Toy1,Toy2],ToyListAfter).


move(st(left,ToyList),st(r,ToyListAfter),right([Toy1 | Toy2]),ToyTime) :-
    choose_two_toys(ToyList,[Toy1,Toy2],ToyListAfter),
    one_way_cross([Toy1 | Toy2],ToyTime).
    
move(st(right,L1),st(left,L2),left(X),D) :-
    toys(T),
    subtract(T,L1,R),
    member(X,R),
    merge_set([X],L1,L2),
    time(X,D).

trans(st(right,[]),st(right,[]),[],0).

trans(S,U,L,D) :-
    move(S,T,M,X),
    trans(T,U,N,Y),
    append([M],N,L),
    D is X + Y.

    
solution(Time,ToysAndTime,Solution):-
    construct_list(ToysAndTime,Toys),
    trans(st(left,Toys),st(right,[]),Solution,PartialTime),
    PartialTime=<Time.