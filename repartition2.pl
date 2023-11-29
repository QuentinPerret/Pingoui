% Retrieve pinguins from pinguin.pl file
?-  write('\nLoading pinguin.pl file ...\n'),
        consult('pinguin.pl'),
        write('Loading Done !\n').
        
% IMC calculation
calculate_imc(Weigh, Height, IMC) :-
    IMC is Weigh / (Height * Height).

sexe_is(P ,Sexe) :- pinguin(P,_,_,_,Sexe,_,_). 

group_pinguin(Pinguins, N, Sexe) :-
    findall(P, pinguin(P, _, _, _, Sexe, _, _), ListPinguins),
    random_permutation(ListPinguins, RandomList),
    sort_by_imc(RandomList, SortedList, Sexe),
    display_pinguins(SortedList),nl,
    group(SortedList, N, Pinguins, Sexe).

% Sort by BMI in descending order
sort_by_imc(List, SortedList, Sexe) :-
    include([P] >> (sexe_is(P,Sexe)), List, FiltreredList),
    categorize_by_imc(FiltreredList, SortedList).


% Categorize pinguins by BMI
categorize_by_imc(Pinguins, SortedList) :-
    categorize_by_imc_helper(Pinguins, [], [], [], SortedList).

categorize_by_imc_helper([], L1, L2, L3, SortedList) :-
    append(L1, L2, TempList),
    append(TempList, L3, SortedList).

categorize_by_imc_helper([P | Rest], L1, L2, L3, SortedList) :-
    pinguin(P, _, Taille, Poids, _, _, _),
    calculate_imc(Poids,Taille,IMC),
    (IMC < 1 -> categorize_by_imc_helper(Rest, [P | L1], L2, L3, SortedList);
     IMC =< 1.5 -> categorize_by_imc_helper(Rest, L1, [P | L2], L3, SortedList);
     categorize_by_imc_helper(Rest, L1, L2, [P | L3], SortedList)).


% Group pinguins
group([],_,[],_).
group(List , N,  [Group | Groups], Sexe) :-
    length(Group , N),
    append(Group , Rest , List),
    group(Rest , N , Groups , Sexe).
group(List , N , [List] , _) :-
    length(List,LengthList),
    LengthList > 0,
    LengthList < N.

create_all_groups(AllGroups , N) :-
    group_pinguin(FemaleGroups,N,female),
    group_pinguin(MaleGroups,N,male),
    append(FemaleGroups,MaleGroups,AllGroups).


display_groups([]).
display_groups([Group | RestGroups]) :-
    nl,
    write('Group: '), write(Group), nl,
    display_pinguins(Group),
    display_groups(RestGroups).

display_pinguins([]).
display_pinguins([P | RestPinguins]) :-
    pinguin(P, Nom, Taille, Poids, Sexe, Niveau, Position),
    write('  Pinguin '), write(P), write(': '),
    write('Nom: '), write(Nom), write(', '),
    write('Taille: '), write(Taille), write(', '),
    write('Poids: '), write(Poids), write(', '),
    write('Sexe: '), write(Sexe), write(', '),
    write('Niveau: '), write(Niveau), write(', '),
    write('Position: '), write(Position), write(', '),
    calculate_imc(Poids, Taille, IMC) , write('IMC: ') , write(IMC), nl,
    display_pinguins(RestPinguins).

?- create_all_groups(AllGroups, 5).
% , display_groups(AllGroups).