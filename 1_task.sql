-- tabulka industry_salary_trend ukazuje vývoj průměrných ročních mezd v jednotlivých odvětvích (industry) a meziroční rozdíl mezd.

DROP TABLE IF EXISTS industry_salary_trend

CREATE TABLE industry_salary_trend as
WITH base_salary_by_industry AS (
	SELECT DISTINCT
		industry_year
		,industry_branch_code
		,avg_salary_by_year
	FROM t_ondrej_simanek_project_sql_primary_final AS os
)
SELECT 
	industry_year
	,industry_branch_code
	,avg_salary_by_year
	,avg_salary_by_year - LAG(avg_salary_by_year) -- rozdíl mezi aktuální a předchozí mzdou v tom samém odvětví
		OVER (PARTITION BY industry_branch_code ORDER BY industry_year) AS difference_salary_from_previous -- bere každé odvětví
FROM 
	base_salary_by_industry
ORDER BY 
	industry_branch_code, industry_year;

-- tento dotaz identifikuje případy, kdy v konkrétním odvětví a roce došlo ke snížení průměrné mzdy oproti předchozímu roku
-- podle výsledku je na tom nejhůře odvětví B - Těžba a dobývání, která měla pokles hned 4x, ostatní jsou v rozmezí 1-2x
SELECT 
	industry_salary_trend.*
	,cpib."name"
FROM 
	industry_salary_trend 
INNER JOIN 
	czechia_payroll_industry_branch cpib 
ON 
	industry_salary_trend.industry_branch_code = cpib.code 
WHERE 
	industry_salary_trend.difference_salary_from_previous < 0

-- naopak tyto odvětví stoupali každý rok: 
-- Doprava a skladování 
-- Administrativní a podpůrné činnosti 
-- Zdravotní a sociální péče
-- Ostatní činnosti
-- Zpracovatelský průmysl
SELECT 
	cpib."name" AS industry_name,
	COUNT(*) AS "count"
FROM 
	industry_salary_trend ist
INNER JOIN 
	czechia_payroll_industry_branch cpib 
	ON ist.industry_branch_code = cpib.code 
WHERE 
	ist.difference_salary_from_previous > 0
GROUP BY cpib."name"
ORDER BY "count" DESC;