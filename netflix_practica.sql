--------------------------------------------------------------------------------------------------------
-- Actor con mayor cantidad de pelicular 

SELECT a.nombre_apellido ,COUNT(s.id_tipo) AS 'Cantidad de pelis' 
FROM elenco e 
INNER JOIN actor a ON e.id_actor = a.id_actor
INNER JOIN show s ON e.id_show = s.id_show
-- INNER JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
WHERE s.id_tipo = 1
GROUP BY a.nombre_apellido
ORDER BY 'Cantidad de pelis' DESC

--------------------------------------------------------------------------------------------------------
-- Directores con mayor cantidad de categorias de peliculas 
SELECT * FROM categoria


-- Buscamos el id del director con mayor cantidad de peliculas 
SELECT sd.id_director AS 'Director', COUNT(DISTINCT id_categoria) AS 'Cantidad de cate'
FROM show s
INNER JOIN show_director sd ON s.id_show = sd.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN director d ON sd.id_director = d.id_director
GROUP BY sd.id_director
ORDER BY 'Cantidad de cate' DESC;

-- ID DIRECTOR con mayor cantidad de categorias de peliculas 2960   
-------------------------------------------------------------------------------------------------
-- Buscamos el nombre del director y la cantidad de categorias de peliculas que realizo 

SELECT d.nombre_apellido AS 'Director', COUNT(DISTINCT id_categoria) AS 'Cantidad de cate'
FROM show s
INNER JOIN show_director sd ON s.id_show = sd.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN director d ON sd.id_director = d.id_director
GROUP BY d.nombre_apellido
ORDER BY 'Cantidad de cate' DESC;

-------------------------------------------------------------------------------------------------
-- Verificacion donde buscamos
-- TODAS las categorias que realizo el id 2960
-- de esta forma mostramos la consistencia de la consulta 

SELECT DISTINCT c.descripcion AS "Nombre Categoria"
FROM show s
INNER JOIN show_director sd ON s.id_show = sd.id_show 
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN director d ON sd.id_director = d.id_director
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
WHERE sd.id_director = 2960;

-------------------------------------------------------------------------------------------------
-- Que pelicula se hizo en la mayor cantidad de paises y su rating y su elenco

SELECT * FROM rating
SELECT * FROM pais 
WHERE descripcion LIKE 'Uni%' 

SELECT p.descripcion
FROM show_pais sp
INNER JOIN pais p ON sp.id_pais = p.id_pais
INNER JOIN show s ON sp.id_show = s.id_show 
GROUP BY p.descripcion

-------------------------------------------------------------------------------------------------

-- En que pais se realizo mas pelicualas 

SELECT p.descripcion, COUNT(s.id_show) AS 'Cantidad de pelis'
FROM show_pais sp
INNER JOIN pais p ON sp.id_pais = p.id_pais
INNER JOIN show s ON sp.id_show = s.id_show 
GROUP BY p.descripcion
ORDER BY 'Cantidad de pelis' DESC

-------------------------------------------------------------------------------------------------
-- ID US = 116 LAs pelis que corresponden a ese id

SELECT p.descripcion, s.titulo
FROM show_pais sp
INNER JOIN pais p ON sp.id_pais = p.id_pais
INNER JOIN show s ON sp.id_show = s.id_show 
WHERE p.id_pais = 116 

-------------------------------------------------------------------------------------------------

-- Categoria del show con mas elenco
SELECT * FROM categoria


SELECT s.titulo AS 'Peli / Serie', COUNT(a.id_actor) AS 'CAntidad de Actores'
FROM elenco e 
INNER JOIN actor a ON e.id_actor = a.id_actor
INNER JOIN show s ON e.id_show = s.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY s.titulo


SELECT c.descripcion AS "Categoria", s.titulo AS "Peli / Serie", COUNT(e.id_actor) AS "Cantidad de Actores"
FROM elenco e
INNER JOIN show s ON e.id_show = s.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY c.descripcion, s.id_show, s.titulo
HAVING 
    s.id_show = (
        SELECT TOP 1 e.id_show
        FROM elenco e
        GROUP BY e.id_show
        ORDER BY COUNT(e.id_actor) DESC
    )
ORDER BY 
    "Cantidad de Actores" DESC;

-- En este caso, estamos usando HAVING para filtrar el show que tiene el mayor elenco. Primero se agrupa el id_show y se cuenta la cantidad de actores en cada show. Luego, HAVING te permite filtrar para que solo se muestre el show que tiene el id_show con el mayor número de actores, encontrado con la subconsulta.


-------------------------------------------------------------------------------------------------

--  Todos los directores que no han dirigido ningún show

SELECT nombre_apellido , s.titulo
FROM show_director sd 
FULL OUTER JOIN director d ON sd.id_director = d.id_director
FULL OUTER JOIN show s ON sd.id_show = s.id_show
WHERE s.titulo IS NULL


-- Correcto angau 

SELECT d.nombre_apellido
FROM director d
LEFT JOIN show_director sd ON d.id_director = sd.id_director
WHERE sd.id_director IS NULL;


------------------------------------------------------------------------------------------------
-- Mostrar todo los actores de las pelicula 
-- | PELI |   |ACTORES|  --

SELECT s.titulo AS 'Peli / Serie', STRING_AGG (a.nombre_apellido, ', ') AS 'ACTOR'
FROM actor a
INNER JOIN elenco e ON a.id_actor = e.id_actor
INNER JOIN show s ON e.id_show = s.id_show
GROUP BY  s.titulo
ORDER BY 'Peli / Serie'



SELECT s.titulo AS 'Peli / Serie', a.nombre_apellido AS 'ACTOR'
FROM elenco e 
INNER JOIN actor a ON e.id_actor = a.id_actor
INNER JOIN show s ON e.id_show = s.id_show
GROUP BY a.nombre_apellido, s.titulo
ORDER BY 'Peli / Serie'

------------------------------------------------------------------------------------------------
--  Todos los shows que no tienen una categoría asignada

SELECT * 
FROM show s
FULL JOIN show_categoria sc ON s.id_show = sc.id_show
FULL JOIN categoria c ON c.id_categoria = sc.id_categoria
WHERE c.id_categoria is NULL

SELECT s.titulo
FROM show s 
LEFT JOIN show_categoria sc ON s.id_show = sc.id_show
WHERE sc.id_categoria is NULL


-- CORRECTO 

SELECT titulo
FROM show
LEFT JOIN show_categoria sc ON show.id_show = sc.id_show
WHERE sc.id_categoria IS NULL


------------------------------------------------------------------------------------------------
-- muestra el número total de shows por cada año de lanzamiento

SELECT COUNT(s.id_show) as 'Catidad de pelis', s.año_lanzamiento 
FROM show s 
GROUP BY s.año_lanzamiento 


------------------------------------------------------------------------------------------------
--  muestra el total de shows agrupados por tipo y categoría

SELECT ts.descripcion AS'Tipo - categoria', c.descripcion AS 'Categoria', COUNT(s.id_show) AS 'Toltal show'
FROM categoria c 
INNER JOIN show_categoria sc ON c.id_categoria = sc.id_categoria
INNER JOIN show s ON sc.id_show = s.id_show
INNER JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
GROUP BY ts.descripcion, c.descripcion
ORDER BY 'Toltal show' DESC


--Correcto 
SELECT tipo_show.descripcion, categoria.descripcion, COUNT(show.id_show) AS 'TotalShows'
FROM show
INNER JOIN tipo_show ON show.id_tipo = tipo_show.id_tipo
INNER JOIN show_categoria ON show.id_show = show_categoria.id_show
INNER JOIN categoria ON show_categoria.id_categoria = categoria.id_categoria
GROUP BY tipo_show.descripcion, categoria.descripcion
ORDER BY 'TotalShows' DESC

------------------------------------------------------------------------------------------------
-- Encuentra los shows con una duración promedio de episodios mayor a 40 minutos.

SELECT * FROM show

SELECT titulo, duracion
FROM show
WHERE duracion > '40 min'

------------------------------------------------------------------------------------------------
-- Encuentra el promedio de actores por show en cada categoría.

-- SELECT c.descripcion, AVG(a.id_actor) AS 'Promedio de actores'
-- FROM actor a 
-- INNER JOIN elenco e ON a.id_actor = e.id_actor 
-- INNER JOIN show s ON e.id_show = s.id_show
-- INNER JOIN show_categoria sc ON s.id_show = sc.id_show
-- INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
-- GROUP BY c.descripcion


-- SELECT c.descripcion, AVG(a.id_actor) AS 'Promedio de actores'
-- FROM actor a 
-- INNER JOIN elenco e ON a.id_actor = e.id_actor 
-- INNER JOIN show s ON e.id_show = s.id_show
-- INNER JOIN show_categoria sc ON s.id_show = sc.id_show
-- INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
-- WHERE c.id_categoria = 23
-- GROUP BY sc.id_categoria, c.descripcion

SELECT 
    c.descripcion AS "Categoria", 
    COUNT(e.id_actor) / COUNT(DISTINCT s.id_show) AS "Promedio de Actores"
FROM show s
INNER JOIN elenco e ON s.id_show = e.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY c.descripcion;


SELECT 
    c.descripcion AS "Categoria", 
    AVG(CantidadActores) AS "Promedio de Actores"
FROM ( -- tabla derivada cuando esta en el from
    SELECT sc.id_categoria, s.id_show, COUNT(e.id_actor) AS "CantidadActores"
    FROM show s
    INNER JOIN elenco e ON s.id_show = e.id_show
    INNER JOIN show_categoria sc ON s.id_show = sc.id_show
    GROUP BY sc.id_categoria, s.id_show
) AS ActoresPorShow
INNER JOIN categoria c ON ActoresPorShow.id_categoria = c.id_categoria
GROUP BY c.descripcion;


------------------------------------------------------------------------------------------------
-- Lista los show que se emitieron en más de un país.

SELECT s.titulo, COUNT(sp.id_pais) AS 'Cantidad de show que se emitiron'
FROM show s
INNER JOIN show_pais sp ON s.id_show = sp.id_show
GROUP BY s.titulo
HAVING COUNT(sp.id_pais) > 1


SELECT 
    s.titulo AS "Peli / Serie", 
    COUNT(sp.id_pais) AS "Países"
FROM  show s
INNER JOIN show_pais sp ON s.id_show = sp.id_show
GROUP BY s.id_show, s.titulo
HAVING COUNT(sp.id_pais) > 1;



select s.titulo from show s
inner join show_pais sp on sp.id_show = s.id_show
inner join pais p on p.id_pais = sp.id_pais
group by s.titulo
having count(sp.id_pais)>1



select s.titulo,count(sp.id_pais) from show s
inner join show_pais sp on sp.id_show = s.id_show
inner join pais p on p.id_pais = sp.id_pais
group by s.titulo
having count(sp.id_pais)>1
order by count(sp.id_pais) desc 

------------------------------------------------------------------------------------------------
-- ¿Cuántos actores únicos aparecen en cada show?
SELECT s.titulo AS "Peli / Serie", COUNT(DISTINCT e.id_actor) AS "Actores Únicos"
FROM elenco e
INNER JOIN show s ON e.id_show = s.id_show
GROUP BY s.id_show, s.titulo;


------------------------------------------------------------------------------------------------

-- ¿Cuántos actores únicos aparecen en un solo show ?
SELECT COUNT(a.id_actor)AS 'Actores que  participaron en una sola pelicula'
FROM actor a
INNER JOIN elenco e ON a.id_actor = e.id_actor
WHERE a.id_actor IN( SELECT a.id_actor -- Esto es una sub consulta porque esta dentro del WHERE
    FROM actor a
    INNER JOIN elenco e ON a.id_actor = e.id_actor
    GROUP BY a.id_actor
    HAVING COUNT(e.id_show) =1)


------------------------------------------------------------------------------------------------
-- Encuentra el número de shows dirigidos por cada director en cada categoría.
SELECT 
    d.nombre_apellido AS "Director", 
    c.descripcion AS "Categoria", 
    COUNT(s.id_show) AS "Cantidad de Shows"
FROM show_director sd
INNER JOIN director d ON sd.id_director = d.id_director
INNER JOIN show s ON sd.id_show = s.id_show
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY d.nombre_apellido, c.descripcion;
------------------------------------------------------------------------------------------------
-- ¿Cuántos shows tiene cada categoría?

SELECT 
    c.descripcion AS "Categoria", 
    COUNT(s.id_show) AS "Cantidad de Shows"
FROM show s
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY c.descripcion;

------------------------------------------------------------------------------------------------
-- Lista los títulos de los shows que tienen más de 3 actores.
SELECT s.titulo AS "Peli / Serie"
FROM elenco e
INNER JOIN show s ON e.id_show = s.id_show
GROUP BY s.id_show, s.titulo
HAVING COUNT(e.id_actor) > 3;

------------------------------------------------------------------------------------------------
-- Encuentra los directores que hayan trabajado en más de 2 shows
SELECT 
    d.nombre_apellido AS "Director", 
    COUNT(sd.id_show) AS "Cantidad de Shows"
FROM show_director sd
INNER JOIN director d ON sd.id_director = d.id_director
GROUP BY d.nombre_apellido
HAVING COUNT(sd.id_show) >= 2
ORDER BY "Cantidad de Shows" DESC

------------------------------------------------------------------------------------------------
--Cantidad de show distintos
SELECT COUNT(DISTINCT id_show) FROM show --8807

--CUantos show asignados a un pais
SELECT COUNT( s.id_show) AS 'show asignados a un pais'
FROM show s
INNER JOIN show_pais sp ON s.id_show = sp.id_show  --10012

--CUantos show distintos asignados a un pais
SELECT COUNT(DISTINCT  s.id_show) AS 'show distintos asignados a un pais'
FROM show s
INNER JOIN show_pais sp ON s.id_show = sp.id_show --7976

--CUantos show distintos con categorias
SELECT COUNT(DISTINCT  s.id_show) AS 'show distintos con categorias'
FROM show s 
INNER JOIN show_categoria sc ON s.id_show = sc.id_show --8807

--CUantos show  con categorias
SELECT COUNT( s.id_show) AS 'show  con categorias'
FROM show s
INNER JOIN show_categoria sc ON s.id_show = sc.id_show --19323

------------------------------------------------------------------------------------------------

-- Motrar los show con sus respectivos pais
SELECT p.descripcion AS 'Pais', s.titulo AS 'Peli / Serie '
FROM show_pais sp 
INNER JOIN pais p ON sp.id_pais = p.id_pais
INNER JOIN show s ON sp.id_show = s.id_show
GROUP BY p.descripcion, s.titulo 
------------------------------------------------------------------------------------------------

-- Mostrar todo los actores tengan o no shows
SELECT * 
FROM actor a
FULL JOIN elenco sd ON a.id_actor = sd.id_actor
FULL JOIN show s ON sd.id_show = s.id_show
WHERE a.id_actor is NULL AND s.fecha_salida is NULL

------------------------------------------------------------------------------------------------
-- Mostrar los Show con sus respectivos directo pais categoria tipo show rating elenco (BASICAMENTE MOSTRAR TODO)
SELECT s.titulo, s.fecha_salida, s.duracion, p.descripcion, c.descripcion, ts.descripcion, d.nombre_apellido AS 'Director',STRING_AGG (a.nombre_apellido, ', ') AS 'ACTOR' -- Verificar que todos los campos dedeados esten 
FROM show s 
FULL JOIN show_director sd ON s.id_show = sd.id_show
FULL JOIN director d ON sd.id_director = d.id_director
FULL JOIN show_pais sp ON s.id_show = sp.id_show
FULL JOIN pais p ON sp.id_pais = p.id_pais
FULL JOIN show_categoria sc ON s.id_show = sc.id_show
FULL JOIN categoria c ON sc.id_categoria = c.id_categoria
FULL JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
FULL JOIN elenco e ON s.id_show = e.id_show
FULL JOIN actor a ON e.id_actor = a.id_actor
GROUP BY s.titulo, s.fecha_salida, s.duracion, p.descripcion, c.descripcion, ts.descripcion, d.nombre_apellido

------------------------------------------------------------------------------------------------
----Cantidad de shows por director y su pais correspondiente que tengan al menos un show

SELECT d.nombre_apellido AS 'Directores', p.descripcion AS 'Pais', COUNT(DISTINCT s.id_show) AS 'Cantidad de show' 
FROM show s
INNER JOIN show_director sd ON s.id_show = sd.id_show
INNER JOIN director d ON sd.id_director = d.id_director 
INNER JOIN show_pais sp ON s.id_show = sp.id_show
INNER JOIN pais p ON sp.id_pais = p.id_pais
GROUP BY d.nombre_apellido, p.descripcion
HAVING COUNT(sd.id_show) > 1
ORDER BY 'Cantidad de show' DESC

------------------------------------------------------------------------------------------------
-----Muestra la cantidad de shows por tipo y año de lanzamiento, en países donde no se registraron directores.

select año_lanzamiento,
       COUNT(case when id_tipo = 1 then 1 end) AS 'Cantidad pelis',
       COUNT(case when id_tipo = 2 then 1 end) AS 'Cantidad serie'
from show s
FULL JOIN show_director sd ON s.id_show = sd.id_show 
WHERE sd.id_director is NULL
GROUP BY año_lanzamiento





select COUNT(case when id_tipo = 1 then 1 end) AS 'Cantidad pelis',
       COUNT(case when id_tipo = 2 then 1 end) AS 'Cantidad serie'
from show


SELECT * FROM show

SELECT ts.descripcion, s.año_lanzamiento 
FROM show s 
INNER JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
INNER JOIN show_pais sp ON s.id_show = sp.id_show
INNER JOIN pais p ON sp.id_pais = p.id_pais
FULL JOIN show_director sd ON s.id_show = sd.id_director
GROUP BY ts.descripcion, s.año_lanzamiento

SELECT COUNT(id_show) 
FROM show s 
INNER JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
WHERE ts.id_tipo = 1

SELECT COUNT(id_show) 
FROM show s 
INNER JOIN tipo_show ts ON s.id_tipo = ts.id_tipo
WHERE ts.id_tipo = 2



------------------------------------------------------------------------------------------------
----Encuentra los actores que participan en shows que están clasificados en más de una categoría. Muestra el nombre del actor y el título del show.


SELECT c.descripcion as 'Categoria', a.nombre_apellido as 'Actor', s.titulo
FROM show s
INNER JOIN elenco e ON s.id_show = e.id_show
INNER JOIN actor a ON e.id_actor = a.id_actor
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY c.descripcion, a.nombre_apellido, s.titulo
HAVING COUNT(c.id_categoria) > 1

------------------------------------------------------------------------------------------------
---Cantidad de shows dirigidos por director que hayan dirgido mas de 3 shows y ademas que sea el año actual

-- Encuentra los directores que hayan trabajado en más de 2 shows
SELECT 
    d.nombre_apellido AS "Director", 
    COUNT(sd.id_show) AS "Cantidad de Shows"
FROM show_director sd
INNER JOIN director d ON sd.id_director = d.id_director
INNER JOIN show s ON sd.id_show = s.id_show
--WHERE YEAR(s.año_lanzamiento) IN (2010 , 2018)
GROUP BY d.nombre_apellido
HAVING COUNT(sd.id_show) >= 1
ORDER BY "Cantidad de Shows" DESC


select * FROM categoria 

SELECT a.nombre_apellido AS actor, s.titulo AS show
FROM actor a
INNER JOIN elenco e ON a.id_actor = e.id_actor
INNER JOIN show s ON e.id_show = s.id_show
WHERE s.id_show IN (
    SELECT id_show ----Encuentra los actores que participan en shows que están clasificados en más de una categoría. Muestra el nombre del actor y el título del show.
    FROM show_categoria
    GROUP BY id_show
    HAVING COUNT(id_categoria) > 1
)
------------------------------------------------------------------------------------------------
-- Cantidad de catigorias por show
SELECT 
    s.id_show, 
    COUNT(sc.id_categoria) AS "Cantidad de Categorías"
FROM show s
INNER JOIN show_categoria sc ON s.id_show = sc.id_show
INNER JOIN categoria c ON sc.id_categoria = c.id_categoria
GROUP BY s.id_show
HAVING COUNT(sc.id_categoria) > 1; 

------------------------------------------------------------------------------------------------
--Actores con mas de un show en el mismo pais

SELECT 
    a.nombre_apellido AS "Actor", 
    p.descripcion AS "País", 
    COUNT(s.id_show) AS "Cantidad de Shows"
FROM elenco e
INNER JOIN actor a ON e.id_actor = a.id_actor
INNER JOIN show s ON e.id_show = s.id_show
INNER JOIN show_pais sp ON s.id_show = sp.id_show
INNER JOIN pais p ON sp.id_pais = p.id_pais
GROUP BY a.nombre_apellido, p.descripcion
HAVING COUNT(s.id_show) > 1
ORDER BY "Cantidad de Shows" DESC;
