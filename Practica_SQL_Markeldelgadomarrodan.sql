/* 2.Filtramos nombre pelicula cuyo rating es R*/

select "title"
from "film"
where "rating" = 'R';

/*3.Nombre de aquellos artistas cuyo artista id esta entre 30 y 40*/
select ("first_name")
from "actor"
where "actor_id" between 30 and 40;

/*-4. Peliculas lenguaje original REVISAR*/
select ("title")
from "film"
where language_id = '1';

/*-5.Peliculas ordenadas de manera ascendente*/
select "title", "length" as "duracion"
from "film"
order by "length" asc;

/*-6.Apellido Allen*/

select concat("first_name",' ',"last_name") as "nombre_completo"
from "actor"
where "last_name" = 'ALLEN';

/*7.cantidad total de peliculas y clasificacion (7)*/
select 
"special_features" as "Clasification",
count(*) as "total_peliculas"
from "film"
group by "special_features"
order by "total_peliculas" desc;

/*8.Peliculas PG-13*/
select ("title") as "titulo"
from "film"
where "rating" = 'PG-13';

/*9.Variabilidad de las peliculas*/
select variance("replacement_cost") as "variabilidad_coste_reparacion"
from "film";

/*10.Mayor y menor duración*/
select ("title") as "titulo", ("length") as "duracion"
from film f 
where length = (select MAX(length) from film) or
      length = (select MIN(length) from film)
      order by length asc;

/*11.Coste antepenultimo alquiler del dia*/

SELECT ("payment_date"), ("amount")
FROM (
    SELECT
        CAST(payment_date AS DATE) AS dia,
        payment_date,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY CAST(payment_date AS DATE)
            ORDER BY payment_date DESC
        ) AS posicion
    FROM payment p 
) t
WHERE posicion = 3
ORDER BY dia;

/*12.titulo peliculas que no sean ni NC-17 ni G en su clasificacioins*/
select ("title") as "titulo"
from film f
where rating not in ('NC-17', 'G');

/*13.Promedio duracion de cada una de las peliculas y su clasificacion*/
select("rating") as "clasificacion",
AVG(length) as "promedio_duracion"
from film f 
group by "rating"
order by "rating";

/*14.titulo peliculas duracion mas de 180 min*/
select ("title") as "titulo"
from film f 
where length < '180';

/*15.Ganancias de la empresa*/
select count("amount")
from payment p;

/* 16. 10 clientes con mayor valor de id*/
select ("customer_id")
from payment
order by "customer_id" desc 
limit 10;

/*17.Nombre y apellido de los actores que aparecen en la película con título Egg Igby*/
SELECT a.first_name AS nombre, a.last_name AS apellido
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';

/*18.Nombre de películas únicos*/
select distinct title
from film f
order by title asc;

/*19.Pelúclas comedia y tienen una duración mayor a 180 min*/
SELECT DISTINCT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;

/* 20.Peliculas duración mayor 110 min , nombre y promedio de la duración*/
SELECT c.name AS categoria, AVG(f.length) AS promedio_duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

/* 21.Media duración alquiler de las películas*/
select ROUND(AVG(rental_duration), 2) as media_duracion_alquiler
from film;

/* 22.Columna nombre y apellidos de los actores*/
SELECT CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM actor;

/* 23.Numero de alquileres por día, ordenados por cantidad de manera descendente*/
SELECT DATE(rental_date) AS dia, COUNT(*) AS numero_alquileres
FROM rental
GROUP BY DATE(rental_date)
ORDER BY numero_alquileres DESC;

/* 24.Peliculas con duración superior al promedio*/
select title, length
from film
where length > (
select AVG (length)
from film
);

/* 25.Numero de alquileres por mes */
SELECT EXTRACT(MONTH FROM rental_date) AS mes, COUNT(*) AS numero_alquileres
FROM rental
GROUP BY EXTRACT(MONTH FROM rental_date)
ORDER BY mes;


/* 26.Promedio, Varianza y desviacion estandar del total pagado*/
select
AVG(amount) as promedio,
STDDEV(amount) as desviacion_estandar,
VARIANCE(amount) as varianza
from payment;

/* 27.peliculas se alquilan por encima del precio medio */
SELECT title, rental_rate
FROM film
WHERE rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);

/* 28.ID de los actores que hayan participado en mas de 40 pelicu*/
select actor_id, COUNT(film_id) as numero_peliculas
from film_actor
group by actor_id
having count (film_id) > 40;

/* 29. mostrar todas las peliculas y mostrar cantidad si estan en el inventario*/
SELECT f.title,
       COUNT(i.inventory_id) AS cantidad_disponible
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

/* 30.Obtener actores y numero peliculas ha actuado*/
select a.actor_id,
a.first_name,
a.last_name,
COUNT (fa.film_id) as numero_peliculas
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
order by numero_peliculas desc;

/* 31.Obtener todas las películas y mostrar actores en ella, incluso aquellas sin actores asociados*/
SELECT f.title,
       CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title, actor;

/* 32.Obtener todos los actores y sus peliculas, ademas de acotres no han participado en ninguna*/SELECT f.title,
SELECT a.first_name,
       a.last_name,
       f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name, f.title;

/* 33.Obtener todas las películas y registros de alquiler*/
SELECT f.title,
       r.rental_id,
       r.rental_date,
       r.return_date
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;

/* 34. 5 Clientes que mas dinero se hayan gastado co nosotros*/
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC
LIMIT 5;

/* 35.Clientes cuyo primer nombre es Johnny*/
select *
from actor 
where first_name = 'JOHNNY';

/* 36.Renombra columna fisrt_name como nombre y last_name como apellido*/
select first_name as Nombre , last_name as Apellido
from actor;


/* 37. El ID mas alto y mas bajo de la tabla actor*/
select MAX(a.actor_id ), MIN(a.actor_id )
from actor a;

/* 38.Cuenta cuantos actores hay en la tabla actor*/
select COUNT(a.actor_id)
from actor a;

/* 39. Selecciona todos los actores y ordenalos de forma ascendente*/
select CONCAT (a.first_name,' ',a.last_name) as nombre_completo
from actor a
order by last_name asc;

/* 40.seleccionar las primeras 5 peliculas de la tabla film*/
select title
from film
limit 5;

/* 41.Agrupar los actores por su nombre y contar cuantos tienen el mismo nombre. ¿Nombre mas repetido?*/
SELECT first_name, COUNT(*) AS cantidad
FROM actor
GROUP BY first_name
ORDER BY cantidad DESC
LIMIT 1;

/* 42. Alquileres y clientes que lo realizaron*/
SELECT r.rental_id,
       c.first_name,
       c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_id;

/* 43.muestra clientes y sus alquileres si existen, incluyendo aquellos no tienen*/
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       r.rental_id,
       r.rental_date,
       r.return_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.customer_id, r.rental_date;

/*44. cr joi entre tabla film y category*/
SELECT f.title, c.name AS categoria
FROM film f
CROSS JOIN category c;
*/no tiene sentido el realizar esta query ya que no aporta valor practico al ejercicio, ya que combina cada pelicula con categoria aunque no tengan relacion entre si*/

/* 45.actores han participado en peliculas de accion*/
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/* 46.Actores no han participado en peliculas*/
SELECT a.actor_id,
       a.first_name,
       a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

/* 47.nombre de los actores y cantidad peliculas han participado*/
SELECT a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS cantidad_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY cantidad_peliculas DESC;

/* 48.crear una vista llamada "actor_num_peliculas" muestre nombre actores y el numero de peliculas que han hecho*/
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name,
       a.last_name,
       COUNT(fa.film_id) AS numero_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

/* 49.Total de alquileres por cliente*/
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

/*50.Duracion total peliculas accion*/
SELECT SUM(f.length) AS duracion_total
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

/* 51.Crea una tabla temporal "clientes_rentas_temporal" para almacenar el total aqluileres por cliente*/
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

/* 52.Tabla temporal llamada "peliculas_alquiladas" han sido alquiladas al menos 10 veces*/
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS total_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

/*53.Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película*/
SELECT DISTINCT f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title ASC;

/*54.Encuentra los nombres de los actores que han actuado en al menos una
película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados
alfabéticamente por apellido*/
SELECT DISTINCT a.first_name,
       a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name ASC, a.first_name ASC;

/*55.Encuentra el nombre y apellido de los actores que han actuado en
películas que se alquilaron después de que la película ‘Spartacus
Cheaper’ se alquilara por primera vez. Ordena los resultados
alfabéticamente por apellido.*/
SELECT DISTINCT a.first_name,
       a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM film f2
    JOIN inventory i2 ON f2.film_id = i2.film_id
    JOIN rental r2 ON i2.inventory_id = r2.inventory_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name ASC, a.first_name ASC;

/*56.Encuentra el nombre y apellido de los actores que no han actuado en
ninguna película de la categoría ‘Music’.*/
SELECT a.first_name,
       a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name ASC, a.first_name ASC;

/*57.Encuentra el título de todas las películas que fueron alquiladas por más
de 8 días.*/
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE (r.return_date::date - r.rental_date::date) > 8
ORDER BY f.title;

/*58.Encuentra el título de todas las películas que son de la misma categoría
que ‘Animation’.*/
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Animation'
ORDER BY f.title;

/*59.Encuentra los nombres de las películas que tienen la misma duración
que la película con el título ‘Dancing Fever’. Ordena los resultados
alfabéticamente por título de película.*/
SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title ASC;

/*60. Encuentra los nombres de los clientes que han alquilado al menos 7
películas distintas. Ordena los resultados alfabéticamente por apellido*/
SELECT c.first_name,
       c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name ASC, c.first_name ASC;

/*61.Encuentra la cantidad total de películas alquiladas por categoría y
muestra el nombre de la categoría junto con el recuento de alquileres.*/
SELECT c.name AS categoria,
       COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.category_id, c.name
ORDER BY total_alquileres DESC;

/*62.Encuentra el número de películas por categoría estrenadas en 2006*/

SELECT c.name AS categoria,
       COUNT(f.film_id) AS numero_peliculas
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
WHERE f.release_year = 2006
GROUP BY c.category_id, c.name
ORDER BY numero_peliculas DESC;

/*63. Obtén todas las combinaciones posibles de trabajadores con las tiendas
que tenemos.*/
SELECT CONCAT(s.first_name, ' ', s.last_name) AS trabajador,
       st.store_id AS tienda
FROM staff s
CROSS JOIN store st;

/*64Encuentra la cantidad total de películas alquiladas por cada cliente y
muestra el ID del cliente, su nombre y apellido junto con la cantidad de
películas alquiladas.*/
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(r.rental_id) AS cantidad_peliculas_alquiladas
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_peliculas_alquiladas DESC;





