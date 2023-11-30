% Retrieve pinguins from pinguin.pl file
?- write('\nLoading repartition.pl file ...\n'),
    consult('repartition.pl'),
    write('repartition.pl loading Done !\n').

% Charger les pistes depuis le fichier piste.pl
?- write('\nLoading piste.pl file ...\n'),
   consult('piste.pl'),
   write('Loading piste.pl done !\n').

% Règle pour afficher les pistes
display_pistes :-
    write('\nPistes disponibles :\n'),
    findall(PisteId, piste(PisteId, _, _), Pistes),
    display_pistes(Pistes).

display_pistes([]).
display_pistes([Piste | RestPistes]) :-
    piste(Piste, PisteName, PisteDifficulty),
    write('Piste '), write(Piste), write(': '),
    write('Nom: '), write(PisteName), write(', '),
    write('Difficulté: '), write(PisteDifficulty), nl,
    display_pistes(RestPistes).

% Règle pour répartir les groupes sur les pistes
repartir_groupes_sur_pistes([]).
repartir_groupes_sur_pistes([Group | RestGroups]) :-
    % Choisir un pingouin du groupe pour déterminer le niveau du groupe
    member(P, Group),
    pinguin(P, _, _, _, _, Niveau, LastPosition),
    
    % Calculer le niveau du groupe en fonction du pingouin choisi
    (LastPosition \= 1 -> GroupNiveau is Niveau; GroupNiveau is Niveau - 1),

    % Trouver une piste avec la difficulté correspondante
    piste(PisteId, _, GroupNiveau),

    % Afficher la répartition
    write('Groupe '), write(Group), write(' réparti sur Piste '), write(PisteId), nl,

    % Répartir le reste des groupes
    repartir_groupes_sur_pistes(RestGroups).
% Utilisation du nouveau code
?- create_all_groups_imc_niveau(AllGroups, 6),repartir_groupes_sur_pistes(AllGroups).
% ?- display_pistes .
