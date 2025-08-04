-- spojení dat o cenách potravin a mzdách s názvy kategorií potravin.

DROP VIEW IF EXISTS food_price_vs_salary_view

CREATE VIEW food_price_vs_salary_view AS
WITH food_price_vs_salary AS (
	SELECT DISTINCT 
		category_code
		,price_year
		,avg_price
		,avg_salary_by_year_czechia
	FROM 
        t_ondrej_simanek_project_SQL_primary_final AS os
)
SELECT 
    category_code
    ,cpc."name"
    ,price_year
    ,avg_price
    ,avg_salary_by_year_czechia
FROM food_price_vs_salary
LEFT JOIN 
	czechia_price_category AS cpc 
ON 
	category_code = cpc.code 


-- CTE které ukazuje, jak moc rychle (či pomalu) rostly ceny v % vybraných potravin oproti průměrné mzdě v Česku
-- percent_food_increase = o kolik % vzrostla průměrná cena potravin oproti předchozímu roku
-- percent_salary_increase = o kolik % vzrostla průměrná mzda oproti předchozímu roku

WITH avg_food_salary AS (
    SELECT 
        price_year
        ,"name" --název potraviny
        ,ROUND(AVG(avg_price), 2) AS avg_food -- průměrná cena potraviny (zaokrouhlená na 2 desetinná místa)
        ,ROUND(AVG(avg_salary_by_year_czechia), 2) AS avg_salary -- průměrná mzda v ČR (zaokrouhlená)
    FROM 
    	food_price_vs_salary_view
    GROUP BY 
    price_year, "name"
),
food_vs_salary_growth AS (
    SELECT 
        price_year
        ,"name"
        ,avg_food
        ,avg_salary
        ,ROUND((avg_food - LAG(avg_food) OVER (PARTITION BY name ORDER BY price_year)) / (LAG(avg_food) OVER (ORDER BY price_year) / 100), 2) AS percent_food_increase -- meziroční procentuální změna ceny potraviny
        ,ROUND((avg_salary - LAG(avg_salary) OVER (PARTITION BY name ORDER BY price_year)) / (LAG(avg_salary) OVER (ORDER BY price_year) / 100), 2) AS percent_salary_increase -- meziroční procentuální změna mzdy
    FROM avg_food_salary
)
SELECT 
    price_year
    ,"name"
    ,percent_food_increase -- růst ceny potraviny v %
    ,percent_salary_increase -- růst mzdy v %
    ,ROUND(percent_food_increase - percent_salary_increase, 2) AS difference_percent -- rozdíl v růstech
FROM 
	food_vs_salary_growth
WHERE 
	(percent_food_increase - percent_salary_increase) > 10 -- filtrovat jen potraviny s nárůstem větším jak 10%
ORDER BY 
	difference_percent DESC;