/*stores the three default diabolic magic squares*/
diabolicA(L) :- L = [1, 8, 13, 12, 14, 11, 2, 7, 4, 5, 16, 9, 15, 10, 3, 6].
diabolicB(L) :- L = [1, 12, 7, 14, 8, 13, 2, 11, 10, 3, 16, 5, 15, 6, 9, 4].
diabolicC(L) :- L = [1, 8, 11, 14, 12, 13, 2, 7, 6, 3, 16, 9, 15, 10, 5, 4].

/*Validates a diabolic magic square typed by the user*/
diabolic(L) :- matrix4x4(L, M), check_rows(M), check_columns(M), check_diagonals(M), check_3x3(M), check_2x2(M).

showall(L) :- diabolicA(L1), new_diabolic(L1), diabolicB(L2), new_diabolic(L2), diabolicC(L3), new_diabolic(L3).

/*-------------------- Creation of DMS ---------------------*/
new_diabolic(L) :- matrix4x4(L, M), all(M).

all(M1) :- all_aux(M1, 0),
	convolution(M1, M2), all_aux(M2, 0),
	rotation_center(M1, M3), all_aux(M3, 0),
	reflection(M1, M4), all_aux(M4, 0),
	rotation_center(M2, M5), all_aux(M5, 0),
	reflection(M2, M6), all_aux(M6, 0),
	reflection(M3, M7), all_aux(M7, 0),
	reflection(M5, M8), all_aux(M8, 0).
	
all_aux(M, D) :- D == 3 , print(M), nl, all_aux2(M,0).
all_aux(M, D) :- print(M), nl, all_aux2(M,0), rot_rows(M, MR1), D1 is D + 1, all_aux(MR1, D1).

all_aux2(M, D) :- D == 3.
all_aux2(M, D) :- rot_columns(M, MR1), print(MR1), nl, D1 is D + 1, all_aux2(MR1, D1).

/*-------------------- Rotations --------------------*/

/*Convolution */
convolution([[A, B, C, D], [E, F ,G, H], [I, J, K, L], [M, N, O, P]], MR) :- MR = [[A, D, H, E], [B, C, G, F], [N, O, K, J], [M, P, L, I]].

/*Rotation about the center point*/
rotation_center([[A, B, C, D], [E, F ,G, H], [I, J, K, L], [M, N, O, P]], MR) :- MR = [[A, E, H, D], [B, F, G, C], [N, J, K, O], [M, I, L, P]].

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
print_list([]).
print_list([X|Xs]) :- print(X), nl, print_list(Xs).

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