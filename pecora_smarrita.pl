:- use_module(lib/mr).
:- consult(lib/action).


genera_mondo:-
	retractall(backupterreno(_)),
	retractall(larghezza(_)),
	retractall(altezza(_)),
	crea_mondo(10,10,ListaMondo),
	assert(backupterreno(ListaMondo)),
	assert(larghezza(10)),
	assert(altezza(10)),
% STAMPA TESTO /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	writeln("\nShaun(P) deve affrontare una discesa non priva di fatiche per tornare al recinto(R).
Tenendo a mente i valori dei terreni, posizionare le 3 caselle di erbetta soffice(E) nella giusta posizione.
	e = arida erba (tempo impiegato per oltrepassare ogni radura erbosa:         1 ora)
	b = fitto bosco (tempo impiegato per oltrepassare ogni sottobosco:           5 ore)
	r = impervia roccia (tempo impiegato per oltrepassare ogni parete rocciosa: 10 ore)\n
	Punti Vita vengono decrementati di 1 ogni ora
	Punti Vita ottenuti rifocillandosi nelle caselle erbetta soffice(E) = 8.\n"),
% STAMPA TESTO */ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	add_erbettaSoffice(ListaMondo,3),
	starting_state(ST),
	myprint(ST),
	member(vita(V),ST),
	ansi_format([],'Vita: ~w~n',[V]),
% STAMPA TESTO /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	writeln("\nDopo aver ottenuto i poteri divini e aver caricato la strategia di ricerca,
per vedere se si ha giocato bene od invece male con la vita di Shaun, digitare 'solution(Movimenti,Ore_Totali).'").
% STAMPA TESTO */ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


add_erbettaSoffice(T,0):-!,
	retractall(terreno(_)),
	assert(terreno(T)).
add_erbettaSoffice(T,E):-
	starting_state(ST),
	retractall(terreno(_)),
	assert(terreno(T)),
	myprint(ST),
	member(vita(V),ST),
	ansi_format([],'Vita: ~w~n',[V]),
	writeln("\nDove vuoi posizionare la casella erbetta soffice?"),	
	writeln("Inserisci la x:"),
	readln(Z),
	nth0(0,Z,X),
	writeln("Inserisci la y:"),
	readln(W),
	writeln(" "),
	nth0(0,W,Y),
	add_and_del(X,Y,T,NT),
	E1 is E-1,
	add_erbettaSoffice(NT,E1).


add_and_del(_X,_Y,[],[]):-!.
add_and_del(X,Y,[Z|Tail],Tail1):-
	Z=..[_P,X,Y],!,
	append([erbetta_soffice(X,Y)],Tail,Tail1).
add_and_del(X,Y,[Z|Tail],[Z|Tail1]):-
	add_and_del(X,Y,Tail,Tail1).


crea_mondo(0,10,[]):-!.
crea_mondo(X,0,List):-!,
	NewX is X-1,
	crea_mondo(NewX,10,List).
crea_mondo(X,Y,[E|Coda]):-
	RandNum is random(3),
       (RandNum == 0 -> E=bosco(X,Y);
	RandNum == 1 -> E=roccia(X,Y);
			 E=erba(X,Y)),
	NewY is Y-1,
	crea_mondo(X,NewY,Coda).


calcolacosto(XN,YN,Costo,Erbetta):-
	terreno(T),
	(
	    (member(erba(XN,YN), T) -> (Costo = 1, Erbetta = 0,!));
	    (member(bosco(XN,YN),T) -> (Costo = 5,Erbetta = 0,!));
	    (member(roccia(XN,YN),T) ->(Costo = 10,Erbetta = 0,!));
	    (member(erbetta_soffice(XN,YN),T) -> Costo = 2,Erbetta=10)
	).


starting_state(S) :-
	list_to_ord_set([pos_pecora(10,10),pos_recinto(1,1), vita(30)],S).


trovato(ST) :-
	member(pos_pecora(X,Y),ST),
	member(pos_recinto(X,Y),ST).


add_del(sinistra(GX,GY,NX),ST,Fluenti,[pos_pecora(GPX,GPY),vita(X)],Costo):-
		member(pos_pecora(GPX,GPY),ST),
		member(vita(X),ST),
		GX is GPX+1,
		GY is GPY,
		calcolacosto(GX,GY,Costo,E),
		NX is X - Costo + E ,
		NX>0,
		((E>0 , member(visitata_erbetta(GX,GY),ST)) -> fail;true),
		(E>0 -> Fluenti = [pos_pecora(GX,GY),vita(NX),visitata_erbetta(GX,GY)];Fluenti = [pos_pecora(GX,GY),vita(NX)]).

				
add_del(destra(GX,GY,NX),ST,Fluenti,[pos_pecora(GPX,GPY),vita(X)],Costo):-
		member(pos_pecora(GPX,GPY),ST),
		member(vita(X),ST),
		GX is GPX-1,
		GY is GPY,
		calcolacosto(GX,GY,Costo, E),
		NX is X - Costo + E,
		NX>0,
		((E>0 , member(visitata_erbetta(GX,GY),ST)) -> fail;true),
		(E>0 -> Fluenti = [pos_pecora(GX,GY),vita(NX),visitata_erbetta(GX,GY)];Fluenti = [pos_pecora(GX,GY),vita(NX)]).
	
		
add_del(sopra(GX,GY,NX),ST,Fluenti,[pos_pecora(GPX,GPY),vita(X)],Costo):-
		member(pos_pecora(GPX,GPY),ST),
		member(vita(X),ST),
		GX is GPX,
		GY is GPY+1,
		calcolacosto(GX,GY,Costo, E),
		NX is X - Costo + E,
		NX>0,
		((E>0 , member(visitata_erbetta(GX,GY),ST)) -> fail;true),
		(E>0 -> Fluenti = [pos_pecora(GX,GY),vita(NX),visitata_erbetta(GX,GY)];Fluenti = [pos_pecora(GX,GY),vita(NX)]).
		
		
add_del(sotto(GX,GY,NX),ST,Fluenti,[pos_pecora(GPX,GPY),vita(X)],Costo):-
		member(pos_pecora(GPX,GPY),ST),
		member(vita(X),ST),
		GX is GPX,
		GY is GPY-1,
		calcolacosto(GX,GY,Costo, E),
		NX is X - Costo + E,
		NX>0,
		((E>0 , member(visitata_erbetta(GX,GY),ST)) -> fail;true),
		(E>0 -> Fluenti = [pos_pecora(GX,GY),vita(NX),visitata_erbetta(GX,GY)];Fluenti = [pos_pecora(GX,GY),vita(NX)]).
		
		
mr:h(ListNodo,H):-
	member(pos_pecora(X,Y),ListNodo),
	member(pos_recinto(XR,YR),ListNodo),
	member(vita(Vita),ListNodo),
	H is 5*sqrt((XR-X)*(XR-X)+(Y-YR)*(Y-YR))+10/Vita.


/***************** STAMPA *************************************************************************************************/


stampa:-
	writeln("\n"),
 	starting_state(ST),
	myprint(ST),
	member(vita(V),ST),
	ansi_format([],'Vita: ~w~n',[V]),
	writeln("\npremi 'invio' per passare allo stato successivo"),
	readln(_Z),
	member(pos_recinto(X,Y),ST),
	sol(S),
	print_story(S,pos_recinto(X,Y)).


print_story([St], X):-!,
	myprint([St,X]),
% STAMPA TESTO /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	writeln("\nGrazie al tuo aiuto la pecora Shaun è riuscita a tornare nel suo amato recinto.
Ti ringrazia per averla comandata con le giuste istruzioni e averle fatto trovare nei punti giusti della preziosa erbetta soffice.\n
(Se desideri provare con un mondo differente digitare 'invio' seguito da 'genera_mondo.')").
% STAMPA TESTO */ %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
print_story([St1|St2], X):-
	myprint([St1, X]),
	St1 =.. [_,_,_,V],
	ansi_format([],'Vita: ~w~n',[V]),
	readln(_Z),
	print_story(St2, X).


myprint(ST):-
	larghezza(Larg),
	altezza(Alt),
	print_raw(ST, Larg, Alt).


print_raw(_ST, _Larg, 0):-!.
print_raw(ST, Larg, Alt):-	
	((Alt = 10) -> writeln("  10 9 8 7 6 5 4 3 2 1"),ansi_format([],'~w ',[Alt]) ; ansi_format([],' ~w ',[Alt])),
	print_column(ST,Larg, Alt),
	NewAlt is Alt - 1,
	print_raw(ST, Larg, NewAlt).


print_column(_ST, 0, _Y):-!, write("\n").
print_column(ST, X, Y):-
	(
		(member(Pred, [pos_pecora,destra, sinistra, sopra, sotto]),(Obj1 =..[Pred,X,Y,_V];Obj1 =..[Pred,X,Y]),member(Obj1, ST)
				-> (!,ansi_format([bold, fg(white)],'P',[]))
				;
				(member(pos_recinto(X,Y), ST)-> (!,ansi_format([bold, fg(red)],'R',[])))
		)
		;
	    (terreno(T),
		 member(E, T),
		 E =.. [Tipo, X,Y],!,
		 (Tipo == bosco -> (ansi_format([bold, fg(blue)],'b',[]),!)
		 ;
		 (Tipo == roccia -> (!,ansi_format([bold, fg(black)],'r',[]))
		 ;
		 (Tipo == erbetta_soffice -> (!,ansi_format([bold, fg(green)],'E',[]))
		 ;
		 (!,ansi_format([bold, fg(green)],'e',[])))))
	    )
	),
	NewX is X-1,
	ansi_format([],' ',[]),
	print_column(ST,NewX,Y).
	
