%--------------------------------------------------------------------
%
% USA il predicato APERTO
%
% pred priority(nodo(TNP), number)
%    la priorità è a seconda della strategia g, h oppure f
%
% DEFINISCE i predicati usati da "search.pl"
% usando la libreria heaps di SWI prolog
%
%----------------------------------------------------------------------

% pred frontiera_iniziale(nodo(TNP),frontiera(nodo(TNP)),potatura(nodo(TNP))).
% 	   frontiera_iniziale(+N,-F, C) det
%	   Spec: F è la frontiera con il solo
% 			 nodo N,  C contiene i chiusi e/o altre informazioni di potatura
% 			 in pota_chiusi contiene i chiusi, nelle altre strategie implelemtate
%			 non è usato. Inoltre può inizializzare dati globali

frontiera_vuota(heap(nil,0)).
frontiera_iniziale(N,F1) :-
	retractall(chiuso(_)),
	priority(N,P),
	add_to_heap(heap(nil,0), P, N, F1).
frontiera_iniziale(N,F1,E) :-
	priority(N,P),
	retractall(chiuso(_)),
	empty_assoc(E),
	add_to_heap(heap(nil,0), P, N, F1).


% pred scelto(nodo(TNP), frontiera(nodo(TNP)), frontiera(nodo(TNP))).
% 	   scelto(-N, +F0,-F1) det
%	   Spec: N è un nodo di F0 (il nodo selezionato)
% 			 e F1 è F0 senza N

scelto(N, F1, F2) :-
	get_from_heap(F1, _, N, F2).


% pred aggiunta(list(nodo(TNP)), frontiera(nodo(TNP)), frontiera(nodo(TNP))).
% 	   aggiunta(+L, +F1, -F2) det
%	   Spec: F2 si ottiene aggiungendo L ad F1
% 	         in base alla priorità e algoritmo dati dalla strategia

aggiunta([],F,F).
aggiunta([N|V], F, F1) :-
      priority(N,P),
      add_to_heap(F,P,N,FF),
      aggiunta(V,FF,F1).
