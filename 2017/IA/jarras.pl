/*Codigos Aula 7

Gabriel dos Santos Vieira e Victor Garritano Noronha

*/

objetivo(2,_).

acao((J1, J2), encher1, (4,J2) :- J1 < 4.

acao((J1, J2), encher1, (J1,3) :- J2 < 3.

acao((J1, J2), esvaziar1, (0, J2)) :- J1 > 0.

acao((J1, J2), esvaziar2, (J1, 0)) :- J2 > 0.

acao((J1, J2), passar12, (J1novo, J2novo)) :-	J1 > 0, J2 < 3,
											 	dif is 3 - J2, dif => J1,
												J2novo is J2 + J1, J1novo is 0, !.
												
acao((J1, J2), passar12, (J1novo, J2novo)) :-	J1 > 0, J2 < 3,
											 	dif is 3 - J2, dif < J1,
												J1novo is J1 - dif,
												J2novo is J2 + dif.
												
acao((J1, J2), passar21, (J1novo, J2novo)) :-	J1 < 4, J2 > 0, dif is 4 - J1,
												dif => J2, J1novo is J2 + J1,
												J2novo is 0, !. 	

acao((J1, J2), passar21, (J1novo, J2novo)) :-	J1 < 4, J2 > 0, dif is 4 - J1,
												dif < J2, J2novo is J2 - dif,
												J1novo is J1 + dif.
												
vizinho(N, FilhosN) :- findall(X, acao(N,_,X), FilhosN).
