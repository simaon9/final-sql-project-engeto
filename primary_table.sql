-- průměrné mzdy pro jednotlivé roky a odvětví
DROP TABLE IF EXISTS industry_average_payroll;

CREATE TABLE industry_average_payroll as
	WITH avg_salary_by_industry AS(
		SELECT
			cp.payroll_year AS "year"
			,cp.industry_branch_code
			,avg(cp.value) AS avg_salary_by_year
		FROM 
			postgres.data_academy_content.czechia_payroll AS cp 
		WHERE 
			value_type_code = 5958 -- Průměrná hrubá mzda na zaměstnance
			AND calculation_code = 100 -- Fyzický
			AND cp.industry_branch_code IS NOT NULL 
		GROUP BY cp.payroll_year, cp.industry_branch_code 
		ORDER BY cp.industry_branch_code, cp.payroll_year 
	)
	SELECT 
		"year",
		industry_branch_code,
		avg_salary_by_year
	FROM avg_salary_by_industry;

-- průměrná mzda v ČR
DROP VIEW IF EXISTS avg_salary_by_year_czechia_view;

CREATE VIEW avg_salary_by_year_czechia_view AS 
	SELECT
		cp.payroll_year AS "year"
		,avg(cp.value) AS avg_salary_by_year_czechia
	FROM 
		postgres.data_academy_content.czechia_payroll AS cp 
	WHERE 
		cp.value_type_code = 5958 
		AND cp.calculation_code = 100 
		AND cp.industry_branch_code IS NULL 
		AND cp.payroll_year >= 2006 
		AND cp.payroll_year <= 2018
	GROUP BY cp.payroll_year 
	ORDER BY cp.payroll_year;

SELECT * FROM avg_salary_by_year_czechia_view

-- HDP (anglicky GPD) v ČR v letech 2006 až 2018
DROP VIEW IF EXISTS gpd_czechia_by_year_view;

CREATE VIEW gpd_czechia_by_year_view AS 
	SELECT 
		e.country AS country
		,e.year AS "year"
		,e.gdp AS gdp
	FROM 
		postgres.data_academy_content.economies AS e 
	WHERE 
		e.country = 'Czech Republic' 
		AND e.year >= 2006 
		AND e.year <= 2018 
	ORDER BY e.year;

SELECT * FROM gpd_czechia_by_year_view

-- průměrné ceny potravin, průměrný plat a HDP pro jednotlivé roky a jednotlivé potraviny
DROP TABLE IF EXISTS food_prices_with_salary_gdp_by_year;

CREATE TABLE food_prices_with_salary_gdp_by_year AS
WITH avg_prices AS (
	SELECT 
		category_code -- kód potraviny
		,EXTRACT(YEAR FROM date_from) AS "year" 
		,ROUND(avg(value)::NUMERIC, 2) avg_price -- průměrná cena potraviny v daném roce
	FROM 
		postgres.data_academy_content.czechia_price AS cp 
	WHERE 
		region_code IS NULL 
	GROUP BY category_code, EXTRACT(YEAR FROM date_from)
	ORDER BY category_code, "year"  
)
SELECT 
	ap.*
	,avgczechia.avg_salary_by_year_czechia
	,gpd.GDP
FROM 
	avg_prices AS ap
	,avg_salary_by_year_czechia_view AS avgczechia
	,gpd_czechia_by_year_view AS gpd 
WHERE 
	ap."year" = avgczechia."year" 
	AND ap."year" = gpd.YEAR
ORDER BY ap.category_code, ap."year";

SELECT * FROM food_prices_with_salary_gdp_by_year

-- finální 1. tabulka
DROP TABLE IF EXISTS t_ondrej_simanek_project_SQL_primary_final

CREATE TABLE t_ondrej_simanek_project_SQL_primary_final AS
SELECT 
    industry."year" as industry_year
    ,industry.industry_branch_code
	,industry.avg_salary_by_year
    ,price."year" as price_year
    ,price.avg_price
    ,price.avg_salary_by_year_czechia
    ,price.gdp
FROM 
	industry_average_payroll as industry
JOIN 
	food_prices_with_salary_gdp_by_year as price
ON 
    industry."year" = price."year";

SELECT * FROM t_ondrej_simanek_project_SQL_primary_final
