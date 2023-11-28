% Retrieve pinguins from pinguin.pl file
:- initialization(main).
main :- write('\nLoading pinguin.pl file ...\n'),
        consult('pinguin.pl'),
        write('Loading Done !\n').

group_pinguin(Pinguins,N) :- 
    findall(P, pinguin(P,_,_,_,_,_,_), ListPinguins),
    group(ListPinguins,N,Pinguins).

group([], _, []).
group(List , N,  [Group | Groups]) :-
    length(Group , N),
    append(Group , Rest , List),
    group(Rest , N , Groups).

%group_pinguin(Groups,5).