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
FROM (
    SELECT 
        sc.id_categoria, 
        s.id_show, 
        COUNT(e.id_actor) AS "CantidadActores"
    FROM show s
    INNER JOIN elenco e ON s.id_show = e.id_show
    INNER JOIN show_categoria sc ON s.id_show = sc.id_show
    GROUP BY sc.id_categoria, s.id_show
) AS ActoresPorShow
INNER JOIN categoria c ON ActoresPorShow.id_categoria = c.id_categoria
GROUP BY c.descripcion;











SELECT DISTINCT * 
FROM categoria
WHERE descripcion Like ('Mus%')