construct_list(List,Toy):-construct_list(List,[],Toy).  % parse the input = reunion of [item ,time] -> Toys = reunion of item

construct_list([],Toys,Toys):-                          % if the input is empty, we unificate the list of toys
    assert(toys(Toys)).                                 % toy(List of items) becomes true

construct_list([[Toy | [Time]] | List],Toys,FToys):-    % parse an item having a toy and time 
    assert(time(Toy,Time)),                             % the predicate time for that item is true
    construct_list(List,[Toy | Toys],FToys).            % recurisve call 

    construct_list(List,Toy):-construct_list(List,[],Toy).


one_way_cross([],0).                                    % there are no toys to cross the bridge
one_way_cross([Toy1 , Toy2],ToyTime):-                  % there are two toys in which case we compute the time of crossing
    time(Toy1,Toy1Time),                                % time of the first toy to cross
    time(Toy2,Toy2Time),                                % time of the second toy to cross
    ToyTime is max(Toy1Time,Toy2Time).                  % we choose the time of crossing as the maximum of the two toys

move(st(left,Agenda),st(right,NewAgenda),left_to_right([Toy1 , Toy2]),ToyTime) :-   %toys are crossing the bridge to right,we compute the time
    member(Toy1,Agenda),                                                            % we take the first toy from the list of toys who didn't cross
    member(Toy2,Agenda),                                                            % we take the second toy from the list of toys who didn't cross
    compare(<,Toy1,Toy2),                                                           % we order them, as the first toy has a smaller time
    write(Agenda),write(' , '),write(Toy1),write(' , '),write(Toy2),write('\n'),
    subtract(Agenda,[Toy1,Toy2],NewAgenda),                                         % the Agenda will be the list of toys without the two who just crossed
    one_way_cross([Toy1 ,Toy2],ToyTime).                                            % we compute the time of crossing the two toys
    
move(st(right,Agenda),st(left,NewAgenda),right_to_left(LeftToy),LeftToyTime) :-     % one toy will cross back to the right
    toys(Toys),                                                                     % we take the list of toys
    subtract(Toys,Agenda,ToyListTemp),                                              % list of toys which didn't cross the bridge
    random_member(LeftToy,ToyListTemp),                                                    % we take the toy on the other side of the bridge
    merge_set(Agenda,[LeftToy],NewAgenda),                                          % the agenda will now contain once again the toy who came back      
    time(LeftToy,LeftToyTime).                                                      % we compute the time of crossing for that one toy

search_df(Goal,Goal,[],0,_).                                    % when the goal is found, the search if finished and initializes the path as emtpy lis and time as 0
search_df(Agenda,Goal,Solution,TotalTime,ConstraintTime) :-     % we search in the agenda, the goal and compute the solution and total time
    move(Agenda,NewAgenda,NewPath,StepTime),                    % (toy3,..) ---(toy1 , toy2)---> ()  and then (toy3,..) <---(toy1)--- (toy2)
    search_df(NewAgenda,Goal,Path,StepTimeN,ConstraintTime),    % recurisve call for the new agenda having a new path and a time 
    append([NewPath],Path,Solution),                            % we add the current moves to the existent path and create the solution
    TotalTime is StepTime + StepTimeN,                          % the total time is the current time and the time of recursive calls 
    TotalTime =< ConstraintTime.


solve(Time,ToysAndTime,Solution):-
    construct_list(ToysAndTime,Toys),
    sort(Toys,SortedToys),
    search_df(st(left,SortedToys),st(right,[]),Solution,ComputedTime,Time),
    write(Solution),write('---'),write(ComputedTime),write('\n').