
% Sample trees.
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))
% bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))


%natural_number.
is_natural_num(0).
is_natural_num(s(X)):-   is_natural_num(X).

%binary tree member.
btMember(E , bt(L,E,R) ).
btMember(E , bt(L,Rt,R) ) :- btMember(E,L).
btMember(E , bt(L,Rt,R) ) :- btMember(E,R).

% 1. is_binary_tree(T).
 is_binary_tree(nil).
 is_binary_tree(bt(X,Y,Z)):- is_binary_tree(X),is_natural_num(Y),is_binary_tree(Z).


% | ?- is_binary_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% yes



%2. lt(X,Y) and bs_tree(T). 
 lt(X,s(X)).
 lt(X,s(Y)):- lt(X,Y).
 bs_tree( bt(nil, Y, nil) ) :- is_natural_num(Y).
 bs_tree( bt(X ,Y, nil) ) :- bs_tree(X), is_natural_num(Y), btMember(E,X), lt(E,Y).
 bs_tree( bt(nil, Y, Z) ) :- bs_tree(Z), is_natural_num(Y), btMember(E,Z), lt(Y,E).
 bs_tree( bt(X, Y, Z) ) :- bs_tree(bt(X,Y,nil)), bs_tree(Z), btMember(E,Z), lt(Y,E).
 
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil))).
% no
% | ?- bs_tree(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(s(s(s(0))))),nil))).
% yes





% 3. parent(T, P, C).
lsubtree(T,bt(T,Rt,R)):-  is_binary_tree(T), is_binary_tree(bt(T,Rt,R)).
rsubtree(T,bt(L,Rt,T)):-  is_binary_tree(T), is_binary_tree(bt(L,Rt,T)).
subtree(T,T2):- lsubtree(T,T2).
subtree(T,T2):- rsubtree(T,T2).
subtree(T,T2):-  subtree(X,T2),subtree(T,X),is_binary_tree(T), is_binary_tree(T2).

parent(bt(bt(Lc, C, Rc), P, Rp), P, C) :-  is_binary_tree(bt(bt(Lc, C, Rc), P, Rp)).
parent(bt(Lp, P ,bt(Lc, C, Rc)), P, C) :-  is_binary_tree(bt(Lp, P ,bt(Lc, C, Rc))).

parent(T, P, C):- subtree(Ts,T), parent(Ts,P,C).
%parent(T, P, C):- dparent(T,P,C).

% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), s(s(s(s(0)))), C).
% C = s(0) ? ;
% C = s(s(0)) ? ;
% no

% | ?- parent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), P, 0).
% P = s(0) ? ;
% no





% 4. descendent(T, A, D).
descendent(T, A, D):- parent(T, A, D).
descendent(T, A, D):- parent(T, A, X), descendent(T, X, D).

% | ?- descendent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), s(s(s(s(0)))), D).
% D = s(0) ? ;
% D = s(s(0)) ? ;
% D = 0 ? ;
% D = s(s(s(0))) ? ;
% no

% | ?- descendent(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), P, 0).
% P = s(0) ? ;
% P = s(s(s(s(0)))) ? ;
% no





% 5. count_nodes(T, X).
% | ?- count_nodes(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), X).
% X = s(s(s(s(s(0))))) ? ;
% no
sum(0,X,X).
sum(s(X),Y,s(Z)) :- sum(X,Y,Z).
count_nodes(nil,0).
count_nodes(bt(L,Rt,R),s(X)):- count_nodes(L,X1),count_nodes(R,X2),sum(X1,X2,X).

% 6. sum_nodes(T, X).
sum_nodes(nil,0).
sum_nodes(bt(L,Rt,R),X):- sum_nodes(L,X1),sum_nodes(R,X2),sum(X1,X2,X3),sum(X3,Rt,X).
% | ?- sum_nodes(bt(bt(nil, s(0), nil), s(s(s(s(0)))), bt(nil,s(s(0)), nil)), X).
% X = s(s(s(s(s(s(s(0))))))) ? ;
% no

% | ?- sum_nodes(T, s(s(s(s(s(s(s(0)))))))).
% T = bt(nil,s(s(s(s(s(s(s(0))))))),nil) ? ;
% T = bt(nil,s(s(s(s(s(s(s(0))))))),bt(nil,0,nil)) ? ;
% T = bt(nil,s(s(s(s(s(s(0)))))),bt(nil,s(0),nil)) ? ;
% T = bt(nil,s(s(s(s(s(0))))),bt(nil,s(s(0)),nil)) ? ;
% T = bt(nil,s(s(s(s(0)))),bt(nil,s(s(s(0))),nil)) ? ;
% T = bt(nil,s(s(s(0))),bt(nil,s(s(s(s(0)))),nil)) ?
% yes




% 7. preorder(T, X).
% ?- preorder(bt(bt(bt(nil,0,nil),s(0), bt(nil,s(s(s(0))),nil)), s(s(s(s(0)))), bt(nil,s(s(0)),nil)), X).
% X = [s(s(s(s(0)))),s(0),0,s(s(s(0))),s(s(0))] ? ;
% no

%append([],L,L).
%append([H|T],L2,[H|L3]):-append(T,L2,L3).
preorder(bt(nil,X,nil),[X]).
preorder(bt(L,Rt,R),X):- append(X1,Rt,X2),append(X2,X3,X),preorder(L,X1),preorder(R,X3).



