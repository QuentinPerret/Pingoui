% Retrieve pinguins from pinguin.pl file
?-  write('\nLoading pinguin.pl file ...\n'),
        consult('pinguin.pl'),
        write('Loading Done !\n').
        

group_pinguin(Pinguins,N,Sexe) :- 
    findall(P, pinguin(P,_,_,_,Sexe,_,_), ListPinguins),
    random_permutation(ListPinguins, RandomList),
    group(RandomList,N,Pinguins,Sexe).

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
    write('Position: '), write(Position), nl,
    display_pinguins(RestPinguins).

% create_all_groups(AllGroups, 5), display_groups(AllGroups).

% create_all_groups(AllGroups,5).

?- create_all_groups(AllGroups, 5), display_groups(AllGroups).