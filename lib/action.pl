:- use_module(mr).
% pred(transition(action, stato, stato, number)).
%      transition(?A, +S1, ?S2, ?Cost) nondet
%      Spec: A manda S1 in S2 con costo Cost

transition(Action, State, NewState, Cost) :-
	add_del(Action,State,Add, Del, Cost),
	list_to_ord_set(Add, OrdAdd),
	list_to_ord_set(Del, OrdDel),
	ord_subtract(State, OrdDel,St),
	ord_union(St, OrdAdd, NewState).


% pred(transition(stato, stato)).
% 	   transition(+S1, ?S2) nondet
%      Spec: da S1 si passa a S2 con una azione

transition(S1,S2) :-
	transition(_,S1,S2,_).


% pred(solution(list(action),number)).
%      solution(-LA, -C) semidet
%      Spec: LA è una soluzione con costo C

:- dynamic(last_solution/3).

% usato localmente come memorizzazione temporanea per l eventuale
% esecuzione successiva.
% Effettuata modifica per stampare GAME OVER in caso non sia stata trovata una soluzione
% e per chiedere all utenete se desidera riprovare a giocare con lo stesso mondo,
% in caso affermativo verrà cercata una soluzione con i nuovi dati inseriti 

solution(Sol, Cost) :-
	starting_state(S0),
	(
		solve(S0,nc(S, Path, Cost)) -> 
		(
			reverse([S|Path], SL),
			states_to_actions(SL, Sol),
			retractall(sol(_)),
			assert(sol(Sol))
		)
		;
		(
			writeln("\n\n\n"),
			ansi_format([bold, fg(red)],'             GAME OVER~n',[]),
			writeln("Shaun purtroppo è morto di fame, le caselle erbetta soffice non sono state disposte nei punti giusti."),
			ansi_format([],'Digitare 1 per riprovare, 0 per terminare~n',[]),
			readln(Z),
			nth0(0,Z,Risp),
			writeln("\n"),
			Risp = 1 -> (backupterreno(T),add_erbettaSoffice(T,3),writeln(" "),solution(Sol,Cost));true 
		)
	).


% pred default_strategy.
% comando, carica astar con pota_chiusi

default_strategy :-
	strategy(astar),
    strategy(pota_chiusi).


% pred vicini(TNP, list(TNP)).
%      vicini(+N, -L) det
%      Spec: L è la lista dei "vicini di L" (collegati ad L da un arco)

vicini(S,L) :-
	setof(S1, transition(S,S1), L),! ; L=[].


% pred costo(TNP, TNP, number).
% 	   costo(+N1,+N2,-C) det
%      Spec: C è il costo dell arco (N1,N2)

costo(S1,S2,C) :-
	transition(_,S1,S2,C).


% pred(states_to_actions(list(stato), list(action))).
% 	   states_to_actions(+LS, -LA) semidet
% 	   Spec: Se  LS è una lista di stati percorribile, LA è la
% 			 lista delle azioni che la percorre
% 			 Se non è percorribile, fallisce

states_to_actions([],[]).
states_to_actions([_S],[]).
states_to_actions([S1,S2|SL],[A|AL]) :-
	transition(A,S1,S2,_),
	states_to_actions([S2|SL], AL).
