% Retrieve penguins from penguin.pl file
?- write('\nLoading penguin.pl file ...\n'),
   consult('penguin.pl'),
   write('Loading Done !\n').

% BMI Calculation
calculate_bmi(Weight, Height, BMI) :-
    BMI is Weight / (Height * Height).

% Generic Grouping
group([], _, [], _).
group(List, N, [Group | Groups], Gender) :-
    % Create a group of size N
    length(Group, N),
    % Extract N elements from the list and append them to the group
    append(Group, Rest, List),
    % Recursively create groups from the remaining elements
    group(Rest, N, Groups, Gender).
group(List, N, [List], _) :-
    % If the length of the remaining list is less than N, create a group with the remaining elements
    length(List, LengthList),
    LengthList > 0,
    LengthList < N.

% Group by Level
group_penguin_level(Penguins, N, Gender, Level, Groups) :-
    % Get penguins at the specified level
    findall(P, (
        penguin(P, _, _, _, Gender, Level, LastPosition),
        \+ has_won_last_race(P, LastPosition)
    ), ListPenguins),
    % Get penguins who won the last race at the next level
    findall(P, (
        penguin(P, _, _, _, Gender, NextLevel, LastPosition),
        has_won_last_race(P, LastPosition),
        NextLevel is Level + 1
    ), WinnerPenguins),
    % Combine the two lists, randomize the order, and create groups
    append(ListPenguins, WinnerPenguins, AllPenguins),
    random_permutation(AllPenguins, RandomList),
    group(RandomList, N, Groups, Gender).

has_won_last_race(P, LastPosition) :-
    % Check if a penguin has won the last race
    LastPosition = 1,
    penguin(P, _, _, _, _, _, _).

% Group by BMI and Level
group_penguin_bmi_level(Penguins, N, Gender, BMI1, BMI2, Level) :-
    % Group penguins by level
    group_penguin_level(Penguins, N, Gender, Level, LevelGroups),
    % Get penguins within the specified BMI range
    findall(P, (
        member(Group, LevelGroups),
        member(P, Group),
        penguin(P, _, Height, Weight, _, _, _),
        calculate_bmi(Weight, Height, BMI),
        BMI >= BMI1, BMI =< BMI2
    ), ListPenguins),
    % Randomize the order, and create groups
    random_permutation(ListPenguins, RandomList),
    group(RandomList, N, Penguins, Gender).

% Create groups by BMI and Level
create_all_groups_bmi_level(AllGroups, N) :-
    % Create groups for females
    create_groups_by_bmi_level(N, female, AllFemaleGroups),
    % Create groups for males
    create_groups_by_bmi_level(N, male, AllMaleGroups),
    % Combine female and male groups
    append(AllFemaleGroups, AllMaleGroups, ComplexAllGroups),
    % Combine groups for different levels
    append(ComplexAllGroups, AllGroups).

create_groups_by_bmi_level(N, Gender, AllGroups) :-
    % Create groups for low, medium, and high BMI ranges at different levels
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 0, 1, 1), LowBmiGroups),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1, 1.5, 1), MediumBmiGroups),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1.5, 999, 1), HighBmiGroups),
    
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 0, 1, 2), LowBmiGroups2),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1, 1.5, 2), MediumBmiGroups2),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1.5, 999, 2), HighBmiGroups2),
    
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 0, 1, 3), LowBmiGroups3),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1, 1.5, 3), MediumBmiGroups3),
    findall(Group, group_penguin_bmi_level(Group, N, Gender, 1.5, 999, 3), HighBmiGroups3),
    
    % Combine groups for different BMI ranges and levels
    append([LowBmiGroups, MediumBmiGroups, HighBmiGroups, LowBmiGroups2, MediumBmiGroups2, HighBmiGroups2, LowBmiGroups3, MediumBmiGroups3, HighBmiGroups3], AllGroups).

% Display groups
display_all_groups([]).
display_all_groups([Group | RestGroups]) :-
    % Display information about each group
    nl,
    write('Group: '), write(Group), nl,
    display_penguins(Group),
    display_all_groups(RestGroups).

% Display penguins
display_penguins([]).
display_penguins([P | RestPenguins]) :-
    % Display information about each penguin in a group
    display_penguin(P),
    display_penguins(RestPenguins).

display_penguin(P) :-
    % Display detailed information about a penguin
    penguin(P, Name, Height, Weight, Gender, Level, Position),
    calculate_bmi(Weight, Height, BMI),
    write('  Penguin '), write(P), write(': '),
    write('Name: '), write(Name), write(', '),
    write('Height: '), write(Height), write(', '),
    write('Weight: '), write(Weight), write(', '),
    write('Gender: '), write(Gender), write(', '),
    write('Level: '), write(Level), write(', '),
    write('Position: '), write(Position), write(', '),
    write('BMI: '), write(BMI), nl.

% Code to use in a prolog terminal
% ?- create_all_groups_bmi_level(AllGroups, 5), display_all_groups(AllGroups).
