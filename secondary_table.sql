--Skript vybírá HDP, GINI a populaci evropských zemí (2006–2018) a ukládá je do jedné tabulky
DROP TABLE IF EXISTS t_ondrej_simanek_project_SQL_secondary_final

CREATE TABLE t_ondrej_simanek_project_SQL_secondary_final AS
SELECT 
	e.country
	,e."year"
	,e.gdp
	,e.gini
	,e.population
FROM postgres.data_academy_content.economies e 
WHERE country IN (
	SELECT country 
	FROM postgres.data_academy_content.countries c
	WHERE continent = 'Europe' 
) 
	AND "year" >= 2006 
	AND "year" <= 2018
ORDER BY country, "year" ASC;