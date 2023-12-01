% Retrieve penguins from distribution.pl file
?- write('\nLoading distribution.pl file ...\n'),
    consult('distribution.pl'),
    write('distribution.pl loading Done !\n').

% Load slopes from slope.pl file
?- write('\nLoading slope.pl file ...\n'),
   consult('slope.pl'),
   write('Loading slope.pl done !\n').

% Rule to display slopes
display_slopes :-
    % Display information about available slopes
    write('\nAvailable slopes:\n'),
    findall(SlopeId, slope(SlopeId, _, _), Slopes),
    display_slopes(Slopes).

display_slopes([]).
display_slopes([Slope | RestSlopes]) :-
    % Display information about each slope
    slope(Slope, SlopeName, SlopeDifficulty),
    write('Slope '), write(Slope), write(': '),
    write('Name: '), write(SlopeName), write(', '),
    write('Difficulty: '), write(SlopeDifficulty), nl,
    display_slopes(RestSlopes).

% Rule to distribute groups on slopes
distribute_groups_on_slopes([]).
distribute_groups_on_slopes([Group | RestGroups]) :-
    % Choose a penguin from the group to determine the group's level
    member(P, Group),
    penguin(P, _, _, _, _, Level, LastPosition),
    
    % Calculate the group's level based on the chosen penguin
    (LastPosition \= 1 -> GroupLevel is Level; GroupLevel is Level - 1),

    % Find a slope with the corresponding difficulty
    slope(_, SlopeName, GroupLevel),

    % Display the distribution
    write('Group '), write(Group), write(' distributed on '), write(SlopeName) ,nl,

    % Distribute the rest of the groups
    distribute_groups_on_slopes(RestGroups).

% Code to use in a prolog terminal
?- display_slopes(),nl.
?- create_all_groups_bmi_level(AllGroups, 6), distribute_groups_on_slopes(AllGroups).