PROGRAM bataille_navale;

//BUT : 1) Deux joueurs placent sur une grille 5 bateaux : 1 bateau de 5 cases, 1 bateau de 4 cases, 2 bateaux
//      de 3 cases et un bateau de 2 cases.

//      2) Phase d'attaque au tour par tour
//      Le but du jeu est couler la flotte adverse, le jeu se joue en tour par tour, ou chaque joueur tire à son tour
//      sur une case de la grille de son adversaire.
//      Un bateau est considéré comme coulé lorsque que toutes ses cases sont touchées par l'adversaire

//      Bateau : ( 5 cases ) = %%%%% ... etc
//      Tir : X ( Bateau touché : ( 5 cases ) = %%X%% ( sur sa propre grille) ); O : touché / X : raté ( sur la grille de tir du joueur )
//      Les grilles sont de dimensions 10x10 : ( A à J / 1 à 10)

//ENTREES : Placement des bateaux ( la flotte entière )
//          Tirs

//SORTIES : Affichage de la grille du joueur
//          Affichage de la grille des tirs du joueur

USES crt;

TYPE

	// RECORD CASE

	record_case = record
		ligne, colonne : integer;
		touche : boolean;
	end;

	// RECORD BATEAU

	record_bateau = record
		position : array[1..5] of record_case;
	end;

	// RECORD FLOTTE

	record_flotte = record
		taille : array[1..5] of record_bateau;
	end;

	array_bateau = array[1..5] of record_case;

VAR

	creation_bateau:array_bateau; // Tableau de création d'un bateau
	case_array:record_case;

	victoire_integer : integer;

	flotte_j1 : record_flotte; // Flotte du joueur 1
	flotte_j2 : record_flotte; // Flotte du joueur 2

	joueur1 : string;
	joueur2 : string;

	parcours_bateau:record_bateau;
	parcours_case:record_case;
	parcours_flotte:record_flotte;

	// Fonction de création d'une case

	function creerCase(ligne, colonne : integer) : record_case;
	VAR nouvelle_case:record_case;
	BEGIN
		nouvelle_case.ligne := ligne;
		nouvelle_case.colonne := colonne;
		creerCase := nouvelle_case;
	END;

	// Fonction de comparaison de deux cases

	function comparerCases(c1, c2 : record_case) : boolean;
	BEGIN
		IF (c1.ligne <> 0) AND (c1.colonne <> 0) THEN
		BEGIN
			IF (c2.ligne <> 0) AND (c2.colonne <> 0) THEN
			BEGIN
				IF (c1.ligne = c2.ligne) AND (c1.colonne = c2.colonne) THEN
				BEGIN
					comparerCases := true;
				END
				ELSE 
				BEGIN
					comparerCases := false;
				END;
			END
			ELSE
			BEGIN
				comparerCases := false;
			END;
		END
		ELSE
		BEGIN
			comparerCases := false;
		END;
	END;

	// Fonction de création d'un bateau

	function creerBateau(creation_bateau : array_bateau) : record_bateau;
	VAR nouveau_bateau:record_bateau;
	BEGIN
		nouveau_bateau.position := creation_bateau;
		creerBateau := nouveau_bateau;
	END;

	// Fonction de vérification de l'appartenance d'une case à un bateau

	function verifieCaseBateau(bateau : record_bateau; cellule : record_case) : boolean;
	VAR case_array:record_case;
	BEGIN
		FOR case_array IN bateau.position DO
		BEGIN
			IF comparerCases(case_array, cellule) = true THEN
			BEGIN
				verifieCaseBateau := true;
				Break;
			END
			ELSE 
			BEGIN
				verifieCaseBateau := false;
			END;
		END;
	END;

	// Fonction de vérification de l'appartenance d'une case à une flotte

	function verifieCaseFlotte(flotte : record_flotte; cellule : record_case) : boolean;
	VAR bateau_array:record_bateau;
	BEGIN
		FOR bateau_array IN flotte.taille DO
		BEGIN
			IF verifieCaseBateau(bateau_array, cellule) = true THEN
			BEGIN
				verifieCaseFlotte := true;
				Break;
			END
			ELSE 
			BEGIN
				verifieCaseFlotte := false;
			END;
		END;
	END;

	// Fonction de création de la flotte

	function creationFlotte(nouvelle_flotte : record_flotte) : record_flotte;
	VAR i, j, k : integer; creation_bateau : array_bateau;
	BEGIN

 		// Porte-avions
 
 		FOR i:= 1 TO 5 DO
 		BEGIN
 			REPEAT
 
 				REPEAT
 					writeln('Porte-avions : Case ', i , ' VERTICALE A-J (1-10) : ? ');
 					readln(j);
 				UNTIL (j >= 1) AND (j <= 10);
 	
 				REPEAT 
 					writeln('Porte-avions : Case ', i , ' HORIZONTALE 1-10  : ? ');
 					readln(k);
 				UNTIL (k >= 1) AND (k <= 10);
 
 			UNTIL verifieCaseFlotte(nouvelle_flotte, creerCase(j, k)) = false;
 			creation_bateau[i] := creerCase(j,k);
 		END;
 
 		// Le Porte-avions peut-être créé
 
 		nouvelle_flotte.taille[1] := creerBateau(creation_bateau);
 		writeln('Porte-avions place en : [');
 		FOR i:= 1 TO 5 DO
 		BEGIN
 			write(nouvelle_flotte.taille[1].position[i].ligne);
 			write(',');
 			write(nouvelle_flotte.taille[1].position[i].colonne);
 			write(' ');
 		END;
 		writeln('].');
 
 		// Croiseur
 		
 		FOR i:= 1 TO 4 DO
 		BEGIN
 			REPEAT
 
 				REPEAT
 					writeln('Croiseur : Case ', i , ' VERTICALE A-J (1-10) : ? ');
 					readln(j);
 				UNTIL (j >= 1) AND (j <= 10);
 	
 				REPEAT 
 					writeln('Croiseur : Case ', i , ' HORIZONTALE 1-10  : ? ');
 					readln(k);
 				UNTIL (k >= 1) AND (k <= 10);
 
 			UNTIL verifieCaseFlotte(nouvelle_flotte, creerCase(j, k)) = false;
 			creation_bateau[i] := creerCase(j,k);
 		END;
 
 		// Le Croiseur peut-être créé
 
 		nouvelle_flotte.taille[1] := creerBateau(creation_bateau);
 		writeln('Croiseur place en : [');
 		FOR i:= 1 TO 4 DO
 		BEGIN
 			write(nouvelle_flotte.taille[1].position[i].ligne);
 			write(',');
 			write(nouvelle_flotte.taille[1].position[i].colonne);
 			write(' ');
 		END;
 		writeln('].');
 
 		// Contre-torpilleur
 		
 		FOR i:= 1 TO 3 DO
 		BEGIN
 			REPEAT
 
 				REPEAT
 					writeln('Contre-torpilleur : Case ', i , ' VERTICALE A-J (1-10) : ? ');
 					readln(j);
 				UNTIL (j >= 1) AND (j <= 10);
 	
 				REPEAT 
 					writeln('Contre-torpilleur : Case ', i , ' HORIZONTALE 1-10  : ? ');
 					readln(k);
 				UNTIL (k >= 1) AND (k <= 10);
 
 			UNTIL verifieCaseFlotte(nouvelle_flotte, creerCase(j, k)) = false;
 			creation_bateau[i] := creerCase(j,k);
 		END;
 
 		// Le Contre-torpilleur peut-être créé
 
 		nouvelle_flotte.taille[1] := creerBateau(creation_bateau);
 		writeln('Contre-torpilleur place en : [');
 		FOR i:= 1 TO 3 DO
 		BEGIN
 			write(nouvelle_flotte.taille[1].position[i].ligne);
 			write(',');
 			write(nouvelle_flotte.taille[1].position[i].colonne);
 			write(' ');
 		END;
 		writeln('].');
 
 		// Sous-marin
 		
 		FOR i:= 1 TO 3 DO
 		BEGIN
 			REPEAT
 
 				REPEAT
 					writeln('Sous-marin : Case ', i , ' VERTICALE A-J (1-10) : ? ');
 					readln(j);
 				UNTIL (j >= 1) AND (j <= 10);
 	
 				REPEAT 
 					writeln('Sous-marin : Case ', i , ' HORIZONTALE 1-10  : ? ');
 					readln(k);
 				UNTIL (k >= 1) AND (k <= 10);
 
 			UNTIL verifieCaseFlotte(nouvelle_flotte, creerCase(j, k)) = false;
 			creation_bateau[i] := creerCase(j,k);
 		END;
 
 		// Le Sous-marin peut-être créé
 
 		nouvelle_flotte.taille[1] := creerBateau(creation_bateau);
 		writeln('Sous-marin place en : [');
 		FOR i:= 1 TO 3 DO
 		BEGIN
 			write(nouvelle_flotte.taille[1].position[i].ligne);
 			write(',');
 			write(nouvelle_flotte.taille[1].position[i].colonne);
 			write(' ');
 		END;
 		writeln('].');
 
		// Torpilleur
		
		FOR i:= 1 TO 2 DO
		BEGIN
			REPEAT

				REPEAT
					writeln('Torpilleur : Case ', i , ' VERTICALE A-J (1-10) : ? ');
					readln(j);
				UNTIL (j >= 1) AND (j <= 10);
	
				REPEAT 
					writeln('Torpilleur : Case ', i , ' HORIZONTALE 1-10  : ? ');
					readln(k);
				UNTIL (k >= 1) AND (k <= 10);

			UNTIL verifieCaseFlotte(nouvelle_flotte, creerCase(j, k)) = false;
			creation_bateau[i] := creerCase(j,k);
		END;

		// Le Torpilleur peut-être créé

		nouvelle_flotte.taille[1] := creerBateau(creation_bateau);
		writeln('Torpilleur place en : [');
		FOR i:= 1 TO 2 DO
		BEGIN
			write(nouvelle_flotte.taille[1].position[i].ligne);
			write(',');
			write(nouvelle_flotte.taille[1].position[i].colonne);
			write(' ');
		END;
		writeln('].');

		creationFlotte := nouvelle_flotte;
	END;

	function victoireVerification(flotte_adverse : record_flotte; joueur : integer) : integer;
	VAR
		case_array:record_case;
		bateau_array:record_bateau;
		victoire_bool:integer;
	BEGIN

		victoire_bool := 0;

		FOR bateau_array IN flotte_adverse.taille DO
		BEGIN
			FOR case_array IN bateau_array.position DO
			BEGIN
				IF (case_array.ligne >= 1) AND (case_array.ligne <= 10) AND (case_array.colonne >= 1) AND (case_array.colonne <= 10) THEN
				BEGIN
					IF case_array.touche = false THEN
					BEGIN
						victoire_bool := 1;
					END
					ELSE
					BEGIN
					END;
				END
				ELSE
				BEGIN
				END;
			END;
		END;

		IF victoire_bool = 0 THEN 
		BEGIN 
			victoireVerification := joueur;
		END
		ELSE
			victoireVerification := 0;
		BEGIN
		END;

	END;

	// Fonction correspondant à la phase d'attaque

	function attaquePhase(joueur : integer; flotte_adverse : record_flotte) : record_flotte;
	VAR j, k, l, m : integer;
	BEGIN
	writeln('Joueur ', joueur , ' a vous de tirer : ');

		REPEAT
			writeln('Tir ? VERTICALE : ');
			readln(j);
			writeln('Tir ? HORIZONTALE : ');
			readln(k);
		UNTIL (j >= 1) AND (j <= 10) AND (k >= 1) AND (k <= 10);

		writeln('Tir en [', j, ',' , k , '] !');

		IF verifieCaseFlotte(flotte_adverse, creerCase(j,k)) = true THEN
		BEGIN
			 FOR l:= 1 TO 5 DO
			 BEGIN
			 	FOR m := 1 TO 5 DO
			 	BEGIN
			 		IF ((flotte_adverse.taille[l].position[m].ligne >= 1) AND (flotte_adverse.taille[l].position[m].ligne <= 10)) AND ((flotte_adverse.taille[l].position[m].colonne >= 1) AND (flotte_adverse.taille[l].position[m].colonne <= 10)) THEN
			 		BEGIN 
			 			IF (flotte_adverse.taille[l].position[m].ligne = j) AND (flotte_adverse.taille[l].position[m].colonne = k) THEN
			 			BEGIN
			 				writeln('Le tir a touche !');
			 				flotte_adverse.taille[l].position[m].touche := true;
			 			END
			 			ELSE
			 			BEGIN
			 			END;
			 		END 
			 		ELSE 
			 		BEGIN
			 		END;
			 	END;
			 END;
	 	END
	 	ELSE
	 	BEGIN
	 		writeln('Le tir a rate !');
	 	END;

		attaquePhase := flotte_adverse;

	END;

BEGIN

	ClrScr; // Efface les entrées de la console

		// Début du jeu

		// Phase de création des flottes

		writeln('Bienvenu a la bataille navale ! Entrez le nom des joueurs : ');
		writeln('Joueur 1 ? : '); readln(joueur1);
		writeln('Joueur 2 ? : '); readln(joueur2);

		ClrScr; // Efface les entrées de la console

		writeln(joueur1, ' cree maintenant votre flotte : ');
		flotte_j1 := creationFlotte(flotte_j1);

		ClrScr;

		writeln(joueur2, ' cree maintenant votre flotte : ');
		flotte_j2 := creationFlotte(flotte_j2);

		ClrScr;

		// Phase de bataille

		REPEAT

			flotte_j2 := attaquePhase(1, flotte_j2);
			victoire_integer := victoireVerification(flotte_j2, 1);
			IF victoire_integer <> 0 THEN Break;

			flotte_j1 := attaquePhase(2, flotte_j1);	
			victoire_integer := victoireVerification(flotte_j1, 2);
			IF victoire_integer <> 0 THEN Break;

		UNTIL victoire_integer <> 0;

		// Victoire

		IF victoire_integer = 1 THEN 
		BEGIN
			writeln(joueur1, ' : vous avez remporte cette partie !');
		END
		ELSE
		BEGIN
			writeln(joueur2, ' : vous avez remporte cette partie !');
		END;

	readln;

END.