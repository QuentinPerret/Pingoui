% Retrieve pinguins from pinguin.pl file
:- initialization(main).
main :- write('\nLoading pinguin.pl file ...\n'),
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

%group_pinguin(Groups,5,female).