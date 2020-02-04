:- consult(frontiera_ord).
/****************************  START  *****************************/
:- dynamic(is_target/1).

% pred target(stato).
% 	   target(+G) semidet
% 	   Spec: Vero sse G è un goal; se si usa solve/2 e trovato/1 è definito dal
% 			 problema, target(G) equivale a trovato(G);
% 			 se si usa solve/3 e call(Trovato,G), equivale a
%			 call(Trovato,G); is_target memorizza il parametro Trovato

target(X) :-
	  is_target(Trovato),!,  % dinamico da non ridefinire
	  call(Trovato,X);
	  trovato(X).


% pred(solve(stato, nodo(stato), pred(stato))).
% 	   solve(+Start, nc(-Goal,-Path,-Cost), +Trovato) nondet
%      Spec: Path cammino da nodo start a Goal e call(Trovato,Goal) è vero

solve(N,G, Trovato) :-
      retractall(is_target(_)),
      assert(is_target(Trovato)),
      frontiera_iniziale(nc(N,[],0),F0, Chiusi),
      cerca(F0,G, Trovato,  Chiusi).


% pred(solve(stato, nodo(stato))).
%      solve(+Start,nc(-Goal,-Path,-Cost)) nondet
%	   Spec: da Start si raggiunge Goal attraverso
%            il cammino Path con costo Cost; Goal è una soluzione

solve(N,G) :-
      retractall(is_target(_)),
      frontiera_iniziale(nc(N,[],0),F0, Chiusi),
      cerca(F0,G, trovato,  Chiusi).

/***************************  ALGORITMO GENERICO ******************/

% pred cerca(frontiera(nodo(TNP)),nodo(TNP), pred(TNP), potatura(nodo(TNP))).
% 	   cerca(+F,nc(-S,-Path,-Cost), +Trovato, +P) nondet
% 	   Spec:
% 			- per ogni goal G vi è un cammino da un nodo di F a G
%  			  inizialmente F=nodo iniziale, poi ricorsivamente altre frontiere
% 			- Path è il cammino dal nodo iniziale ad S,  vale call(Trovato,S)
%  			  e S è la soluzione trovata dalla strategia applicata
% 			- P contiene le informazioni di potatura, se usate dalla strategia

cerca(Frontiera, Goal, Trovato,  Chiusi) :-
      scelto(nc(PN, Path, Cost),Frontiera,F1),
      (call(Trovato, PN),
	  Goal = nc(PN, Path, Cost);
	  vicini(PN,Vicini),
   	  trasforma(Vicini,nc(PN,Path,Cost),
	  Chiusi, dl([],Espansione)),
      chiusura(nc(PN,Path,Cost),Chiusi,NuoviChiusi),
	  aggiunta(Espansione,F1,NuovaFrontiera),
	  cerca(NuovaFrontiera,Goal, Trovato, NuoviChiusi)).


% pred trasforma(list(TNP),nodo(TNP),potatura(nodo(TNP)), difflist(nodo(TNP))).
% 	   trasforma(+Vicini,+N,+C,dl([],-F)) det
%  	   Spec: F è la porzione di frontiera contenente i Vicini, da aggiungere
% 			 alla frontiera corrente

trasforma([],nc(_,_,_),_,dl(R,R)).
trasforma([V|T], nc(N,Path,Cost),Chiusi,dl(R1,R2)) :-
	  costo(N,V,K),
	  Cost1 is Cost+K,
      potatura(nc(V,[N|Path],Cost1), Chiusi,dl(R2,R3)),
      trasforma(T,nc(N,Path,Cost),Chiusi,dl(R1,R3)).
