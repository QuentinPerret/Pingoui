% Retrieve pinguins from pinguin.pl file
?- write('\nLoading pinguin.pl file ...\n'),
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

% Groupe par niveau
group_pinguin_niveau(Pinguins, N, Sexe, Niveau, Groups) :-
    findall(P, (
        pinguin(P, _, _, _, Sexe, Niveau, _)
    ), ListPinguins),

    % Récupérer le niveau précédent
    PrecedentNiveau is Niveau - 1,

    % Récupérer la liste de pingouins du niveau précédent
    findall(PrecedentP, (
        pinguin(PrecedentP, _, _, _, Sexe, PrecedentNiveau, Position),
        % Assurer que les pingouins du niveau précédent sont en position 1
        Position = 1
    ), ListPrecedentPinguins),

    % Diviser la liste du niveau précédent en sous-listes pour chaque groupe
    length(ListPinguins, Len),
    length(ListPrecedentPinguins, LenPrecedent),
    ExtraPrecedent is Len - LenPrecedent,
    length(ExtraPrecedentList, ExtraPrecedent),
    append(ListPrecedentPinguins, ExtraPrecedentList, FullPrecedentList),
    split_list(FullPrecedentList, N, SplitPrecedentLists),

    % Fusionner les listes du niveau actuel et du niveau précédent
    append(ListPinguins, SplitPrecedentLists, ListPinguinsWithPrecedent),

    % Permuter aléatoirement la liste combinée
    random_permutation(ListPinguinsWithPrecedent, RandomList),

    % Grouper les pingouins en utilisant la règle de base
    group(RandomList, N, Groups, Sexe).

% Prédicat pour diviser une liste en sous-listes de taille N
split_list([], _, []).
split_list(List, N, [Sublist | Rest]) :-
    append(Sublist, RestList, List),
    length(Sublist, N),
    split_list(RestList, N, Rest).

% Groupe par IMC et niveau
group_pinguin_imc_niveau(Pinguins, N, Sexe, IMCRange1, IMCRange2, Niveau) :-
    group_pinguin_niveau(Pinguins, N, Sexe, Niveau, LevelGroups),
    findall(P, (
        member(Group, LevelGroups),
        member(P, Group),
        pinguin(P, _, Taille, Poids, _, _, _),
        calculate_imc(Poids, Taille, IMC),
        IMC >= IMCRange1, IMC =< IMCRange2
    ), ListPinguins),
    random_permutation(ListPinguins, RandomList),
    group(RandomList, N, Pinguins, Sexe).

% Création des groupes par IMC et niveau
create_all_groups_imc_niveau(AllGroups, N) :-
    create_groups_by_imc_niveau(N, female, AllFemaleGroups),
    create_groups_by_imc_niveau(N, male, AllMaleGroups),
    append(AllFemaleGroups, AllMaleGroups, AllGroups).

create_groups_by_imc_niveau(N, Sexe, AllGroups) :-
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 0, 1, 1), LowImcGroups),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1, 1.5, 1), MediumImcGroups),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1.5, 999, 1), HighImcGroups),
    
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 0, 1, 2), LowImcGroups2),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1, 1.5, 2), MediumImcGroups2),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1.5, 999, 2), HighImcGroups2),
    
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 0, 1, 3), LowImcGroups3),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1, 1.5, 3), MediumImcGroups3),
    findall(Group, group_pinguin_imc_niveau(Group, N, Sexe, 1.5, 999, 3), HighImcGroups3),
    
    append([LowImcGroups, MediumImcGroups, HighImcGroups, LowImcGroups2, MediumImcGroups2, HighImcGroups2, LowImcGroups3, MediumImcGroups3, HighImcGroups3], AllGroups).

% Affichage des groupes
display_groups_imc([]).
display_groups_imc([Groups | RestGroups]) :-
    nl,
    display_groups_by_imc(Groups),
    display_groups_imc(RestGroups).

% Affichage des groupes par IMC
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
?- create_all_groups_imc_niveau(AllGroups, 5), display_groups_imc(AllGroups).
