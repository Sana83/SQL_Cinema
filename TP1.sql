/*verifiaction de la cardinalitÃ©(partie 2)*/

SELECT FILM
FROM SEANCE
WHERE FILM is null;

SELECT COUNT (*)
FROM SEANCE
WHERE FILM is null;

SELECT cine
FROM seance
WHERE cine is null;

SELECT *
FROM cinema
WHERE nom is null;

ALTER TABLE seance
set film is not null;

/*Correction partie 2*/

SELECT idfilm
FROM film
where idflim not in (select idflim from casting);

/*acteur sans film*/
select idacteur, nom
from acteur
where idacteur not in (select idacteur from casting);

/*film sans seance*/
select iffilm,titre
from film
where idfilm not in (select film form seance);

/*y a t-il des cinemas sans seance*/
select count(*)
from cinema
where idcine not in (select cine from service);

/*Modification de la structure de la base(partie 3)*/

ALTER TABLE ACTEUR
add sexe char(1) default 'M' not null;
update acteur 
set sexe = 'F'
where idacteur in (1,3,5,7,8,9,11,12,16,20,25,28,32,33);

ALTER TABLE CINEMA
DROP COLUMN ADRESSE;

ALTER TABLE CINEMA
add ( Adresse1 char(40), Adresse2 char(40) default null, CP char(5) default '13000' not null,Ville char(10) default 'Marseille' not null);

UPDATE CINEMA SET Adresse1 = '80, ave du Prado' WHERE IDCINE=1;
UPDATE CINEMA SET Adresse1 = '2, rue des alouettes' WHERE IDCINE=2;
UPDATE CINEMA SET Adresse1 = '7, place Castellane' WHERE IDCINE=3;
UPDATE CINEMA SET Adresse1 = '277, ave du Prado' WHERE IDCINE=4;

commit;
rollback;

/*Partie 4: Requêtes d'interrogation et de mise à jour*/
select idfilm, titre
from film
where datesortie>='01/01/1990';

select *
from acteur
where sexe = 'F';

select film, cine, titre
from seance
inner join film on seance.film = film.idfilm
where film = '6';



/*Partie 5: Mise à jour de la base*/
