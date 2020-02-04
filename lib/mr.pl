:- module(mr, [ strategy/1,
	       target/1,
	       solve/2,
	       solve/3 ]
	 ).

:- writeln(
'\n*******************************************************************************************************************************************\n
                                                        PROGETTO PECORA SMARRITA\n
Sono passati oramai alcuni giorni di cammino, la pecora Shaun delusa ammette quindi di essersi persa in cima al monte Wannahockaloogie
e sta per chiedere indicazioni alla fauna locale, quando riesce a scorgere nel centro della vallata il proprio Recinto.
Resta un unico problema. Disgraziatamente si rende conto di aver terminato le scorte di erbetta soffice e potrebbe non riuscire a tornare 
nel suo amato recinto sana e salva.
Aiuta Shaun a salvarsi posizionando nei giusti punti della mappa le caselle di erbetta soffice dove shaun potrà rifocillarsi.  
Per fare in modo che Shaun ritrovi la via di casa e riesca a raggiungere il recinto ancora in vita, seguire le seguenti istruzioni:\n
     - Creare un mondo casuale in cui Shaun possa perdersi liberamente digitando: genera_mondo.\n
     - Posizionare nei punti più appropriati le caselle di erbetta soffice.\n
     - Premere ''invio'' per ottenere il potere divino di rendere effettive le modifiche al mondo.\n 
     - Caricare la strategia di ricerca della strada di casa digitando: default_strategy.\n
     - digitare ''solution(Movimenti,Ore_Totali).'' per sapere se Shaun è riuscito a tornare nel recinto grazie al tuo aiuto.\n
     - Rinchiudere Shaun nel lussuoso recinto e buttar via la chiave definitivamente digitando: ''invio''.\n
     - Per visualizzare tutti gli spostamenti effettuati da Shaun nel mondo digitare: stampa.\n
*******************************************************************************************************************************************\n'),

consult('Ricerca/search').

/*********************  Comandi utente **************************************/

:- dynamic(loaded_strategy/1).

strategy(S) :-
	retractall(loaded_strategy(_)),
	(   is_list(S) -> maplist(s_consult,S); s_consult(S)),
	maplist(write, ['\n*********************       CARICATA STRATEGIA ',S, '       ****************\n\n']).

s_consult(LF) :-
	is_list(LF),!,
	maplist(s_consult, LF).
s_consult(F) :-
	atom_concat('Ricerca/',F, RF),
	load_files(library(RF),[silent(true)]),
	assert(loaded_strategy(F)).

/********************* FINE INTERFACCIA DIDATTICA ***************************/
