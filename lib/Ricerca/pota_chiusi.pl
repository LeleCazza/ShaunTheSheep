:- dynamic(chiuso/1).

% Usa una base dati dinamica chiuso/1 per memorizzare i nodi
% chiusi (cioè già incontrati);  non  fa controlli sui costi,
% ovvero assume la consistenza dell euristica.
% NB: se il grafo è finito e i suoi nodi sono noti in partenza,
% la chiusura di un nodo si riduce ad un flag associato al nodo;
% quando il nodo è espanso, si alza il flag; un nodo è chiuso
% se ha il flag alzato

starting :-
	  retractall(chiuso(_)).


%%  taglia  implementato come taglio dei chiusi
taglia(N,_) :-
    (	showflag -> writeln(verifica_chiusura(N)); true),
    chiuso(N),
    (	showflag -> writeln(N:' è chiuso'); true).

chiudi(N) :-
    (	showflag -> writeln(chiudo(N)); true),
    (	not(chiuso(N)) -> assert(chiuso(N)); true ).

%%	NUOVA VERSIONE DA MIGLIORARE

% pred chiusura(nodo(TNP), potatura(nodo(TNP)), potatura(nodo(TNP))).
% A) se non si mantiene una lista di nodi chiusi per la potatura,
% ha successo senza effetti;
% B) altrimenti aggiunge TNP alla base dati dei nodi chiusi; in tal
% caso taglia_cicli taglia più pesantemente i nodi chiusi
% chiusura(nc(V,_,_),L,[V|L]).

chiusura(nc(V,_,_),A,B) :-
	put_assoc(V,A,n,B).


% pred potatura(nodo(TNP), potatura(nodo(TNP)), difflist(nodo(TNP))).
% potatura(S, L, C, dl(L1,L2)) det:
% L2 aggiunge a L1 il risultato della potatura di S in base a C
% - se S non è potato, aggiunge S
% - se S è sostituito da un chiuso migliore SC, contiene SC
% - se S è potato nulla viene aggiunti
% - aperto ad altre strategie di potatura

potatura(nc(V,_Path,_),Chiusi,dl(L,L)) :-
	get_assoc(V,Chiusi,_),!.
potatura(N,_,dl([N|L],L)).


/*chiusura(nc(V,_,_),_A,_B) :-
	not(chiuso(V)) -> assert(chiuso(V)); true.

potatura(nc(V,_Path,_),_Chiusi,dl(L,L)) :-
	chiuso(V),!.
potatura(N,_,dl([N|L],L)).*/
