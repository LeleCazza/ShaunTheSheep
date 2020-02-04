:- consult(frontiera_ord).

% STRATEGIA A*:  ordina frontiera_ord in base a f(NP) = g(NP) + h(NP)

% pred leq(nodo_problema, nodo_problema).
% 	   leq(+N1, +N2) is semidet
%	   Spec: ordinamento della frontiera da usare in
% 			 frontiera_ord.pl
%     		 per A* la frontiera è ordinata in base a f(N) = g(N) + h(N)

leq(nc(N1,_,Costo1),nc(N2,_,Costo2)) :-
    h(N1, W1),
    h(N2, W2),
    Costo1+W1 =< Costo2+W2.


% pred priority(nodo_completo, number).
% 	   priority(+N,-P) det
%      Spec: P = f(N) = g(N)+h(N)

priority(nc(N,_,Costo), P) :-
	h(N,W),
	P is Costo + W.
