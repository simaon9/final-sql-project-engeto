-- tabulka zobrazuje kolik kusů/litrů chleba (111301) a mléka (114201) si mohl člověk v prvním a posledním roce sledovaného období (2006 - 2018) koupit za průměrnou mzdu.
-- pro přehlednost jsem přidal i název potraviny
-- minimální a maximální rok jsem si vytáhl nejdříve - funkce min a max mi nešla použít ve WHERE a také mi to pak přišlo i přehlednější

CREATE TABLE affordability_comparison AS
WITH minmax_years AS (
	SELECT 
		MIN(price_year) AS min_year, -- minumum v daných letech
		MAX(price_year) AS max_year -- maximum v daných letech 
	FROM t_ondrej_simanek_project_SQL_primary_final 
),
selected_products_minmax_years AS (
	SELECT DISTINCT 
		os.category_code,
		os.price_year,
		os.avg_price,
		os.avg_salary_by_year_czechia,
		os.gdp
	FROM t_ondrej_simanek_project_SQL_primary_final AS os,
	minmax_years AS mm
	WHERE (os.price_year = mm.min_year OR os.price_year = mm.max_year)
		AND os.category_code IN(111301, 114201)
)
SELECT 
	category_code 
	,price_year
	,avg_price
	,avg_salary_by_year_czechia
	,pc.name AS product_name
	,pc.price_unit
	,round(selected_products_minmax_years.avg_salary_by_year_czechia / selected_products_minmax_years.avg_price, 2) how_many 
FROM 
	selected_products_minmax_years
LEFT JOIN 
	czechia_price_category pc
ON 
	category_code = pc.code
ORDER BY 
	category_code, price_year;

-- z dat vyplývá, že chleba i mléko jsou dostupnější než dříve -> i přes stoupající cenu potraviny, protože stoupala i průměrná mzda
SELECT * FROM affordability_comparison