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




--
