# Escape from Zurg

Buzz, Woody, Rex, and Hamm have to escape from Zurg. They merely have to cross one last bridge before they are free. 
However, the bridge is fragile and can hold at most two of them at the same time. 
Moreover, to cross the bridge, a flashlight is needed to avoid traps and broken parts. The problem is that our friends have only one flashlight with one
battery that lasts for only 60 minutes. The toys need different times to cross the bridge (in either direction):


## Example usage

The algorithm can be executed in a swi-prolog environment. The user can start the execution following the steps:
1. Open the folder containing the file in the terminal. 
```
cd 'C:/...'
```
2. Start the prolog environment.
```
swipl 
```
3. Compile the  prolog file.
```
?- [zurg].
```
4. Execute the predicate solve , it has three arguments. The arguments are explained the following order: time restriction, list of toys and time, the output path.
```
?- solve(60,[[buzz,5],[woody,10],[rex,20],[hamm,25]], _path).
```
5. The output should look like this.
```
        [buzz,woody,rex,hamm]------------------> []
        [rex,hamm]--------[buzz,woody]-------->[]
        [rex,hamm] <--------[buzz]----------[woody]
        [buzz]--------[rex,hamm]-------->[]
        [buzz] <--------[woody]----------[rex,hamm]
        []--------[buzz,woody]-------->[]
Total Time: 60
--------------------------------------------------------------------------------------------------------------------
_path = [left_to_right([buzz, woody]), right_to_left(buzz), left_to_right([rex, hamm]), right_to_left(woody), left_to_right([buzz, woody])]
```
```
?- ?- solve(15,[[ana,1],[maria,2],[ioana,3],[ama,4]], _path).  
        [ana,maria,ioana,ama]------------------> []
        [ioana,ama]--------[ana,maria]-------->[]
        [ioana,ama] <--------[ana]----------[maria]
        [ama]--------[ana,ioana]-------->[]
        [ama] <--------[ana]----------[maria,ioana]
        []--------[ana,ama]-------->[]
Total Time: 11
--------------------------------------------------------------------------------------------------------------------
_path = [left_to_right([ana, maria]), right_to_left(ana), left_to_right([ana, ioana]), right_to_left(ana), left_to_right([ana, ama])]
```