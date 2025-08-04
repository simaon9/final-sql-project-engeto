-- tato tabulka obsahuje meziroční procentuální změnu ceny každé kategorie potravin

-- CASE porovnává aktuální cenu avg_price s cenou v předchozím roce pro stejnou potravinu a vypočítává procentuální nárůst podle vzorce:
-- (cena_dnes - cena_loni) / cena_loni / 100

DROP TABLE IF EXISTS food_price_growth_by_year

CREATE TABLE food_price_growth_by_year AS
WITH base_food_price_by_year AS (
	SELECT DISTINCT 
		category_code
		,price_year
		,avg_price
		,avg_salary_by_year_czechia
		,gdp
	FROM t_ondrej_simanek_project_SQL_primary_final AS os
)
SELECT 
	category_code
	,pc."name"
	,price_year
	,avg_price
	,avg_salary_by_year_czechia
	,CASE 
		WHEN category_code = LAG(category_code) OVER (PARTITION BY category_code ORDER BY price_year) THEN
			ROUND((avg_price - LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year)) / (LAG(avg_price) OVER (PARTITION BY category_code ORDER BY price_year) / 100), 2)
		ELSE 
			NULL 
	END AS percent_increase 
FROM 
	base_food_price_by_year
LEFT JOIN 
    czechia_price_category pc
ON 
	category_code = pc.code
ORDER BY 
	category_code, price_year;


-- tento dotaz (CTE) obsahuje průměrný meziroční procentuální nárůst cen (percent_increase) pro každou potravinovou kategorii (category_code)
-- druhá část dotazu připojí název číselníku czechia_price_category a filtruje jen kategorie s kladným nárůstem cen
-- seřazeno od nejnižšího procentuálního růstu

WITH avg_price_growth_by_category AS(
	SELECT 
		fp.category_code,
		avg(fp.percent_increase) AS avg_increase 
	FROM 
		food_price_growth_by_year AS fp 
	WHERE 
		percent_increase IS NOT NULL 
	GROUP BY 
		fp.category_code 
)
SELECT 
	apg.category_code
	,cpc.name 
	,apg.avg_increase
FROM 
	avg_price_growth_by_category AS apg
LEFT JOIN 
	czechia_price_category AS cpc 
ON 
	apg.category_code = cpc.code 
WHERE 
	apg.avg_increase > 0
ORDER BY 
	apg.avg_increase ASC
