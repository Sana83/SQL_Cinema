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
UPDATE CINEMA SET Adresse1 = '277, ave du Prado' WHERE IDCINE=4

/*commit permet de "sauvergarder" ce qu'on a fait sans que le roolback puisse faire quelque chose*/
commit;

/*permet de faire un retour en arriere des commande en non commit*/
rollback;

/*Partie 4: Requêtes d'interrogation et de mise à jour*/
--1
select idfilm, titre
from film
where datesortie>='01/01/1990';

--2
select *
from acteur
where sexe = 'F';

--3
select cinema.idcine, cinema.nom
from seance
inner join cinema on seance.cine = cinema.idcine
where film = '6';

--4
select casting.idfilm, film.titre
from casting
inner join film on film.idfilm= casting.idfilm
where casting.idacteur = '10'; 

--5
SELECT casting.idfilm, film.titre
FROM casting inner join film on film.idfilm=casting.idfilm
inner join acteur on casting.idacteur=acteur.idacteur
where upper(acteur.nom)='GAINSBOURG';

--6
SELECT COUNT(*)
from acteur
where sexe = 'F';

--7
SELECT COUNT(idcine) as nbcine
FROM cinema;

--8
SELECT COUNT(*) as nbseances
from seance
where seance.film=5
and seance.cine=1;

--9
select cinema.idcine, cinema.nom, count(*) as nbseance
from seance
inner join cinema on seance.cine = cinema.idcine
Where seance.film = 5
group by cinema.idcine, cinema.nom;

--10
select cinema.idcine, cinema.nom, count(*) as nbseance
from cinema
left join seance on seance.cine = cinema.idcine
Where seance.film = 5
group by cinema.idcine, cinema.nom;

--10
select casting.idfilm, casting.personnage, film.titre
from casting
inner join film on casting.idfilm = film.idfilm
where casting.idacteur=10;

--11
select cinema.idcine, cinema.nom
from cinema
where cinema.idcine not in (select seance.cine from seance where seance.film = 6);

--12
select cinema.idcine, cinema.nom
from cinema
inner join seance on cinema.idcine = seance.cine
where seance.film=6 and to_char(seance.heuredbt, 'HH24') > '15';

--13
select seance.idseance, seance.cine, cinema.nom, seance.film, film.titre, seance.prix, seance.heuredbt
from seance
inner join cinema on seance.cine = cinema.idcine
inner join film on seance.film = film.idfilm
where seance.prix= (select max(prix) from seance);

--14
select distinct cinema.idcine, cinema.nom
from cinema
inner join seance on cinema.idcine = seance.cine
where seance.prix= (select max(prix) from seance);

--15
select acteur.idacteur, acteur.nom, acteur.prenom
from acteur
where acteur.idacteur not in (select casting.idacteur from casting);

--16
select acteur.idacteur, acteur.nom, count(casting.idfilm) as nbfilms
from casting
right join acteur on casting.idacteur=acteur.idacteur
group by acteur.idacteur, acteur.nom;

--17
Select acteur.idacteur, acteur.nom, acteur.prenom
from acteur 
inner join casting on acteur.idacteur=casting.idacteur
group by acteur.idacteur, acteur.nom, acteur.prenom
having count(*) = (select max(count(*)) from casting group by casting.idacteur);

--18
select distinct cinema.idcine, cinema.nom
from seance
inner join cinema on cinema.idcine=seance.cine
inner join casting on casting.idfilm=seance.film
where casting.idacteur=10;

--19
select round(avg(prix),2) as moyenneprix
from seance;

--20
select cinema.idcine, cinema.nom, AVG(prix) as prixMoyen
from cinema
inner join seance on cinema.idcine= seance.cine
group by cinema.idcine, cinema.nom;

--21 - déjà fait

--22
update seance
set prix=prix*1.02
where cine=(select idcine from cinema where nom='Variete');

--23
Insert into film (idfilm, titre, datesortie)
values ('43','Warcraft','24/05/2016');

/*Partie 5: Mise à jour de la base*/
-- 2 solutions: creér une nouvelle table avec les id des films ou directement créer une colonne dans la table film en y ajoutant un genre et metttre les genre à la main.
-- ajout d'une colonne dans la table film avec les genres
ALTER TABLE film
add genre varchar(20);
update film set genre = 'indefini';

alter table film
modify genre default 'indefini' not null;

/*Partie 6: Modification de la structure de la base*/
delete from film where idfilm=6;
--avec cette requete = violation de contrainte d'intégrité
--donc faire 
delete from casting where idfilm=6;
delete from film where idfilm=6;

alter table casting drop constraint FKCASTFILM;
alter table casting add constraint fk_casting_film foreign key(idfilm)
references film(idfilm) on delete cascade;

select * from casting where idfilm=6;
select * from seance where idfilm=6;

delete from film where idfilm=6;
alter table seance drop constraint fkseancefilm;
alter table seance add constraint fk_seance_film foreign key(film)
references film(idfilm) on delete cascade;
