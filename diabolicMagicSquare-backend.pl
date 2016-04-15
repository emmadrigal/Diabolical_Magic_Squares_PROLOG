/*-------------------- Creation of DMS ---------------------*/
/*Generates one square*/
diabolic(L):- var(L), showall(M, [[1, 8, 13, 12], [14, 11, 2, 7], [4, 5, 16, 9], [15, 10, 3, 6]]), Num is random(383), nth0(Num, M, L).

/*Validates a diabolic magic square typed by the user*/
diabolic(L) :- nonvar(L),matrix4x4(L, M), check_rows(M), check_columns(M), check_diagonals(M), check_3x3(M), check_2x2(M).

/*Generates three squares*/
diabolic(L, M, N):- var(L), var(M), var(N), showall(Matrix, [[1, 8, 13, 12], [14, 11, 2, 7], [4, 5, 16, 9], [15, 10, 3, 6]]), Num1 is random(383), Num2 is random(383), Num3 is random(383), nth0(Num1, Matrix, L), nth0(Num2, Matrix, M), nth0(Num3, Matrix, N).

/*Generate an especific and random number of DMS for java*/
generate(L1, C) :- generateAll(L), generate_aux(L, L1, C, 0).
generate_aux(_, _, C, Count) :- Count == C.
generate_aux(L, L1, C, Count) :- Count1 is Count + 1, Num is random(383), nth0(Num, L, L2), append(L3, [L2], L1), generate_aux(L, L3, C, Count1).

/*Generate all DMS for java*/
generateAll(L) :- showall(M, [[1, 8, 13, 12], [14, 11, 2, 7], [4, 5, 16, 9], [15, 10, 3, 6]]), matrix_to_list(M, L).

/*Generates all the posibilites*/
showall(_):- showall(M, [[1, 8, 13, 12], [14, 11, 2, 7], [4, 5, 16, 9], [15, 10, 3, 6]]), print_list(M).

/*Starts the generation of posibilites starting with one square*/
showall(ListMat, L0):- changeRows(ListMat, L0, 0). 

/*Creates new matrices by rotating columns*/
changeRows(ListMat, L0, Rows):- Rows < 4, changeColumns(NewList0, L0, 0), Rows2 is Rows + 1, rot_rows(L0, L1), changeRows(NewListMat, L1, Rows2), append(NewList0, NewListMat, ListMat).
changeRows([], _, Rows):- Rows == 4.

/*Creates new matrices by rotating rows*/
changeColumns(ListMat, L0, Columns):- Columns < 4, rotateMatrix(NewList0, L0, 0), Columns2 is Columns + 1, rot_columns(L0, L1), changeColumns(NewListMat, L1, Columns2), append(NewList0, NewListMat, ListMat).
changeColumns([], _, Columns):- Columns == 4.

/*Creates new matrices by rotating around the center*/
rotateMatrix(ListMat, L0, Rotations):- Rotations < 4, reflectMatrix(NewList0, L0, 0), Rotations2 is Rotations + 1, rotation(L0, L1), rotateMatrix(NewListMat, L1, Rotations2), append(NewList0, NewListMat, ListMat).
rotateMatrix([], _, Rotations):- Rotations == 4.

/*Creates new matrices by reflecting*/
reflectMatrix(ListMat, L0, Reflections):- Reflections < 2, convoluteMatrix(NewList0, L0, 0), Reflections2 is Reflections + 1, reflection(L0, L1), reflectMatrix(NewListMat, L1, Reflections2), append(NewList0, NewListMat, ListMat).
reflectMatrix([], _, Reflections):- Reflections == 2.

/*Creates new matrices by convoluting*/
convoluteMatrix(ListMat, L0, Convolutions):- Convolutions < 3, convolution(L0, L1), Convolutions2 is Convolutions + 1, convoluteMatrix(NewListMat, L1, Convolutions2), append([L0], NewListMat, ListMat). 
convoluteMatrix([], _, Convolutions):- Convolutions == 3.

/*-------------------- Transformations --------------------*/
/*Convolution */
convolution([[A, B, C, D], [E, F ,G, H], [I, J, K, L], [M, N, O, P]], MR) :- MR = [[A, D, H, E], [B, C, G, F], [N, O, K, J], [M, P, L, I]].

/*Rotation about the center point*/
rotation([[A, B, C, D], [E, F ,G, H], [I, J, K, L], [M, N, O, P]], MR) :- MR = [[M, I, E, A], [N, J, F, B], [O, K, G, C], [P, L, H, D]].

/*reflection*/
reflection([A, B, C, D], MR) :- reverse(A, As), reverse(B, Bs), reverse(C, Cs), reverse(D, Ds), MR = [As, Bs, Cs, Ds].

/*rotation of rows*/
rot_rows([X|Xs], MR) :- append(Xs, [X], MR).

/*rotation of columns*/
rot_columns([A, B, C, D], MR) :- rot_columns(A, B, C, D, MR).
rot_columns([A|As], [B|Bs], [C|Cs], [D|Ds], MR) :- append(As, [A], Ar), append(Bs, [B], Br),append(Cs, [C], Cr), append(Ds, [D], Dr), MR = [Ar, Br, Cr, Dr].


/*-------------------- Validate Functions --------------------*/
/*Checking the sum of the rows*/
check_rows([]).
check_rows([X|Xs]) :- sum34(X), check_rows(Xs).

/*Checking the sum of the columns*/
check_columns([A, B, C, D]) :- check_columns(A, B, C ,D).
check_columns([], [], [], []).
check_columns([A|As], [B|Bs], [C|Cs], [D|Ds]) :- sum34([A, B, C, D]), check_columns(As, Bs, Cs ,Ds).

/*checking the sum of the diagonals*/
check_diagonals(M) :- check_diagonals2(M), rot_columns(M, MR), check_diagonals2(MR), rot_columns(MR, MR2), check_diagonals2(MR2), rot_columns(MR2, MR3), check_diagonals2(MR3).
check_diagonals2(M) :- check_diagonals_aux(M),  reflection(M, MR), check_diagonals_aux(MR).
check_diagonals_aux([A, B, C, D]) :- nth0(0, A, A1), nth0(1, B, B1), nth0(2, C, C1), nth0(3, D, D1), sum34([A1, B1, C1, D1]).

/*Checking the sum of the corners of any 3x3 square*/
check_3x3([A, B, C, D]) :- check_3x3(A, C), check_3x3(B, D).
check_3x3([X|Xs], [Y|Ys]) :- nth0(0, Xs, X0), nth0(1, Xs, X1), nth0(2, Xs, X2), nth0(0, Ys, Y0), nth0(1, Ys, Y1), nth0(2, Ys, Y2), sum34([X, X1, Y, Y1]), sum34([X0, X2, Y0, Y2]).

/*checking the sum of any 2x2 square*/
check_2x2([A, B, C, D]) :- div(A, A1, A2), div(B, B1, B2), div(C, C1, C2), div(D, D1, D2), check_2x2(A1, B1), check_2x2(B1, C1), check_2x2(C1, D1), check_2x2(A2, B2), check_2x2(B2, C2), check_2x2(C2, D2), check_2x2(A1, C2), check_2x2(A2, C1), check_2x2(B1, D2), check_2x2(B2, D1),
	check_2x2(A1, A2, D1, D2), check_2x2(A1, A2, B1, B2), check_2x2(B1, B2, C1, C2), check_2x2(C1, C2, D1, D2).
check_2x2([X|Xs],[Y|Ys]) :- sum34([X, Xs, Y, Ys]).
check_2x2([A|As], [B|Bs], [C|Cs], [D|Ds]) :- sum34([A, Bs, C, Ds]), sum34([As, B, Cs, D]).

/*-------------------- Auxiliar Functions --------------------*/
/*prints alll the elements of a list*/
print_list(L) :- print_list(L, 1).
print_list([], _).
print_list([X|Xs], C) :- print(C), nl, print_list_aux(X), nl, C1 is C + 1, print_list(Xs, C1).
print_list_aux([]).
print_list_aux([X|Xs]) :- print(X), nl, print_list_aux(Xs).

/*divides a list into equal parts*/
div(L, A, B) :- length(L, N), Half is N div 2, length(A, Half), length(B, Half), append(A, B, L).

/*Sum is 34*/
sum34(L):- list_sum(L, T), T==34.

/*sum of a list*/
list_sum([], 0).
list_sum([Head|Tail], Sum):- list_sum(Tail, Sum1), Sum is (Sum1 + Head).
            
/*Converting a list into a matrix of 4x4*/
matrix4x4(Xs, Ys) :- length(Xs, 16), matrix4x4(Xs, [], Ys).
matrix4x4([], [], []).
matrix4x4([X|Xs], S, Ys) :-  not(length(S, 4)), not(is_list(X)), matrix4x4(Xs, [X|S], Ys).
matrix4x4(Xs, S, [Y|Ys]) :- length(S, 4), reverse(S,Y), matrix4x4(Xs, [], Ys).

matrix_to_list([], _).
matrix_to_list([X|Xs], L) :- matrix_to_list_aux(X, L1), matrix_to_list(Xs, L2), append(L2, [L1], L).
matrix_to_list_aux([[A, B, C, D], [E, F ,G, H], [I, J, K, L], [M, N, O, P]], Mr) :- Mr = [A, B, C, D, E, F ,G, H, I, J, K, L, M, N, O, P].