DROP VIEW IF EXISTS economic_trends_view

CREATE VIEW economic_trends_view AS
WITH distinct_yearly_data AS (
	SELECT DISTINCT 
		category_code,
		price_year,
		avg_price,
		avg_salary_by_year_czechia,
		gdp
	FROM t_ondrej_simanek_project_SQL_primary_final AS os
)
SELECT *
FROM distinct_yearly_data;

-- Vytvoření CTE pro výpočet průměrných hodnot
WITH avg_food_salary AS (
	SELECT 
		price_year 
		,round(avg(avg_price)::numeric, 2) AS avg_food
		,round(avg(avg_salary_by_year_czechia), 2) AS avg_salary_by_year_czechia
		,round(avg(GDP)::numeric, 2) AS gdp
	FROM 
		economic_trends_view AS etv 
	GROUP BY 
		price_year
)
-- Vytvoření finální tabulky, která obsahuje procentuální nárůst cen, platů a HDP
-- cíl: označit roky, ve kterých HDP vzrostlo o více než 5 %, nebo
-- roky následující po roce s výrazným růstem HDP
-- 5% jsem si určil
, yearly_percent_changes AS (
	SELECT 
		afs.price_year
		,afs.avg_food
		,afs.avg_salary_by_year_czechia
		,afs.gdp
		,round((afs.avg_food - LAG(afs.avg_food) OVER (ORDER BY afs.price_year)) / 
			(LAG(afs.avg_food) OVER (ORDER BY afs.price_year)/100), 2) AS percent_food_increase
		,round((afs.avg_salary_by_year_czechia - LAG(afs.avg_salary_by_year_czechia) OVER (ORDER BY afs.price_year)) / 
			(LAG(afs.avg_salary_by_year_czechia) OVER (ORDER BY afs.price_year)/100), 2) AS percent_salary_increase
		,round((afs.GDP - LAG(afs.GDP) OVER (ORDER BY afs.price_year)) / 
			(LAG(afs.GDP) OVER (ORDER BY afs.price_year)/100), 2) AS percent_GDP_increase
	FROM 
		avg_food_salary AS afs
)
, gdp_growth_flagged_years AS (
	SELECT 
		*,
		CASE 
			WHEN percent_GDP_increase > 5 THEN 1
			WHEN LAG(percent_GDP_increase) OVER (ORDER BY price_year) > 5 THEN 1
			ELSE 0
		END AS flag
	FROM 
		yearly_percent_changes
)
-- výpis let ve kterých došlo k vyššímu růstu HDP a také výpis roku následujícího po tomto roku
SELECT * 
FROM 
	gdp_growth_flagged_years
WHERE 
	flag = 1
ORDER BY 
	price_year;