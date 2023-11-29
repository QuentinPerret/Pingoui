% Retrieve pinguins from pinguin.pl file
?-  write('\nLoading pinguin.pl file ...\n'),
        consult('pinguin.pl'),
        write('Loading Done !\n').

% Calcul de l'IMC
calculate_imc(Poids, Taille, IMC) :-
    IMC is Poids / (Taille * Taille).

% Groupe générique
group([], _, [], _).
group(List, N, [Group | Groups], Sexe) :-
    length(Group, N),
    append(Group, Rest, List),
    group(Rest, N, Groups, Sexe).
group(List, N, [List], _) :-
    length(List, LengthList),
    LengthList > 0,
    LengthList < N.

% Groupe par IMC
group_pinguin_imc(Pinguins, N, Sexe, IMCRange1, IMCRange2) :-
    findall(P, (
        pinguin(P, _, Taille, Poids, Sexe, _, _),
        calculate_imc(Poids, Taille, IMC),
        IMC >= IMCRange1, IMC =< IMCRange2
    ), ListPinguins),
    random_permutation(ListPinguins, RandomList),
    group(RandomList, N, Pinguins, Sexe).


% Création des groupes par IMC
create_all_groups_imc(AllGroups, N) :-
    create_groups_by_imc(N, female, AllFemaleGroups),
    create_groups_by_imc(N, male, AllMaleGroups),
    append(AllFemaleGroups, AllMaleGroups, AllGroups).

create_groups_by_imc(N, Sexe, AllGroups) :-
    findall(Group, group_pinguin_imc(Group, N, Sexe, 0, 1), LowImcGroups),
    findall(Group, group_pinguin_imc(Group, N, Sexe, 1, 1.5), MediumImcGroups),
    findall(Group, group_pinguin_imc(Group, N, Sexe, 1.5, 999), HighImcGroups),
    append([LowImcGroups, MediumImcGroups, HighImcGroups], AllGroups).


% Affichage des groupes
display_groups_imc([]).
display_groups_imc([Groups | RestGroups]) :-
    nl,
    display_groups_by_imc(Groups),
    display_groups_imc(RestGroups).

display_groups_by_imc([]).
display_groups_by_imc([Group | RestGroups]) :-
    nl,
    write('Group: '), write(Group), nl,
    display_pinguins(Group),
    display_groups_by_imc(RestGroups).

% Affichage des pingouins
display_pinguins([]).
display_pinguins([P | RestPinguins]) :-
    pinguin(P, Nom, Taille, Poids, Sexe, Niveau, Position),
    calculate_imc(Poids, Taille, IMC),
    write('  Pinguin '), write(P), write(': '),
    write('Nom: '), write(Nom), write(', '),
    write('Taille: '), write(Taille), write(', '),
    write('Poids: '), write(Poids), write(', '),
    write('Sexe: '), write(Sexe), write(', '),
    write('Niveau: '), write(Niveau), write(', '),
    write('Position: '), write(Position), nl,
    write('IMC: '), write(IMC), nl,
    display_pinguins(RestPinguins).

% Utilisation du nouveau code
?- create_all_groups_imc(AllGroups, 5), display_groups_imc(AllGroups).
