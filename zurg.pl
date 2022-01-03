construct_list(List,Toy):-construct_list(List,[],Toy).  % parse the input = reunion of [item ,time] -> Toys = reunion of item

construct_list([],Toys,Toys):-
    assert(toys(Toys)).

construct_list([[Toy | [Time]] | List],Toys,FToys):-
    assert(time(Toy,Time)),
    append(Toys,[Toy],NewToys),
    construct_list(List,NewToys,FToys). 

one_way_cross([],0).                                    % there are no toys to cross the bridge
one_way_cross([Toy1 , Toy2],ToyTime):-                  % there are two toys in which case we compute the time of crossing
    time(Toy1,Toy1Time),                                % time of the first toy to cross
    time(Toy2,Toy2Time),                                % time of the second toy to cross
    ToyTime is max(Toy1Time,Toy2Time).                  % we choose the time of crossing as the maximum of the two toys


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

cross_bridge(left(Agenda),right(NewAgenda),left_to_right([Toy1 , Toy2]),ToyTime,TimeSlice) :-   %toys are crossing the bridge to right,we compute the time
    choose_two_toys(Agenda,Toy1,Toy2,TimeSlice),
    
    subtract(Agenda,[Toy1,Toy2],NewAgenda),                                         % the Agenda will be the list of toys without the two who just crossed
    write(Agenda),write(' ---- '),write([Toy1,Toy2]),write(' ---> '),write(NewAgenda),write('\n'),
    
    one_way_cross([Toy1 ,Toy2],ToyTime).                                            % we compute the time of crossing the two toys

cross_bridge(right(Agenda),left(NewAgenda),right_to_left(LeftToy),LeftToyTime,_) :-     % one toy will cross back to the right
    toys(Toys),                                                                         % we take the list of toys
    subtract(Toys,Agenda,ToyListTemp),                                                  % list of toys which didn't cross the bridge
    member(LeftToy,ToyListTemp),                                                        % we take the toy on the other side of the bridge
    merge_set(Agenda,[LeftToy],NewAgenda),                                              % the agenda will now contain once again the toy who came back      
    write(NewAgenda),write(' <---- '),write([LeftToy]),write(' ---'),write(Agenda),write('\n'),
    time(LeftToy,LeftToyTime).                                                          % we compute the time of crossing for that one toy



search_bf(Goal,Goal,[],0,_,_).                                              % when the goal is found, the search if finished and initializes the path as emtpy lis and time as 0
search_bf(Agenda,Goal,Solution,TotalTime,ConstraintTime,TimeSlice) :-       % we search in the agenda, the goal and compute the solution and total time
    cross_bridge(Agenda,NewAgenda,NewPath,StepTime,TimeSlice),              % (toy3,..) ---(toy1 , toy2)---> ()  and then (toy3,..) <---(toy1)--- (toy2)
    search_bf(NewAgenda,Goal,Path,StepTimeN,ConstraintTime,TimeSlice),      % recurisve call for the new agenda having a new path and a time 
    append([NewPath],Path,Solution),                                        % we add the current cross_bridges to the existent path and create the solution
    TotalTime is StepTime + StepTimeN,                                      % the total time is the current time and the time of recursive calls 
    TotalTime =< ConstraintTime.                                            % the total time of execution must be less than the one given as input

% predicate used for optimizing the toys chosen for crossing bridge
% toys cross the bridge if and only if their time difference is less than time slice 
compute_time_slice(Time,Toys,TimeSlice):- length(Toys, Len), TimeSlice is Time / Len. 



solve(Time,ToysAndTime,Solution):-                                          % solves the zurg escape having a time, list of (toy,time) and gives a path
    construct_list(ToysAndTime,Toys),                                       % using the list, constructs the list of facts 
    compute_time_slice(Time,Toys,TimeSlice),                                % computes the optimum time difference between two toys  
    search_bf(left(Toys),right([]),Solution,ComputedTime,Time,TimeSlice),   % calls the breadth-first strategy 
    write(Solution),write('---'),write(ComputedTime),write('\n').           % pretty-prints the solution