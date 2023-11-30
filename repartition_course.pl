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
    findall(Piste, piste(PisteId, PisteName, PisteDifficulty), Pistes),
    display_pistes(Pistes).

display_pistes([]).
display_pistes([Piste | RestPistes]) :-
    piste(PisteId, PisteName, PisteDifficulty),
    write('Piste '), write(PisteId), write(': '),
    write('Nom: '), write(PisteName), write(', '),
    write('Difficulté: '), write(PisteDifficulty), nl,
    display_pistes(RestPistes).

% Utilisation du nouveau code
% ?- create_all_groups_imc_niveau(AllGroups, 6),display_groups_imc(AllGroups)./
?- display_pistes .
