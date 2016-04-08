diabolic([1, 8, 13, 12, 14, 11, 2, 7, 4, 5, 16, 9, 15, 10, 3, 6]).
diabolic([1, 12, 7, 14, 8, 13, 2, 11, 10, 3, 16, 5, 15, 6, 9, 4]).
diabolic([1, 8, 11, 14, 12, 13, 2, 7, 6, 3, 16, 9, 15, 10, 5, 4]).
listNums(L) :- L = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16].

/*-------------------- Validate Functions --------------------*/

/*Checking the sum of the rows*/
check_rows(L) :- matrix4x4(L, Y), check_rows2(Y).

check_rows2([]).
check_rows2([X|Xs]) :- check_rows2(X, Xs).
check_rows2(X, Xs) :- sum34(X), check_rows2(Xs).

/*Checking the sum of the columns*/
check_columns(L) :- matrix4x4(L, Y), check_columns2(Y).

check_columns2([], [], [], [], []).
check_columns2([A|As]) :- check_columns2(A, As).
check_columns2(A, [B|Bs]) :- check_columns2(A, B, Bs).
check_columns2(A, B, [C|Cs]) :- check_columns2(A, B, C, Cs).
check_columns2(A, B, C, [D|Ds]) :- check_columns2(A, B, C, D, Ds).
check_columns2([A|As], [B|Bs], [C|Cs], [D|Ds], E) :- sum34([A, B, C, D]), check_columns2(As, Bs, Cs, Ds, E).

/*checking the sum of the diagonals*/

/*-------------------- Auxiliar Functions --------------------*/

/*Sum is 34*/
sum34(L):- list_sum(L, T), T==34.

/*sum of a list*/
list_sum([], 0).
list_sum([Head|Tail], Sum):-
     list_sum(Tail, Sum1),
     Sum is (Sum1 + Head).
            
/*Converting a list into a matrix of 4x4*/
matrix4x4(Xs, Ys) :- length(Xs, 16), matrix4x4(Xs, [], Ys).
matrix4x4([], [], []).
matrix4x4([X|Xs], S, Ys) :-  not(length(S, 4)), not(is_list(X)), matrix4x4(Xs, [X|S], Ys).
matrix4x4(Xs, S, [Y|Ys]) :- length(S, 4), reverse(S,Y), matrix4x4(Xs, [], Ys).                      Kevin Quirós
