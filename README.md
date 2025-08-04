# Finální SQL projekt

## Cíl projektu:
Připravit datové podklady pro analýzu dostupnosti základních potravin ve vztahu k průměrným příjmům obyvatel v ČR a porovnání s evropskými státy pomocí HDP, GINI indexu a populace.

## Výstup projektu:
Výstupem by měly být dvě tabulky v databázi, ze kterých se požadovaná data dají získat. Tabulky pojmenujte t_{jmeno}_{prijmeni}_project_SQL_primary_final (pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období – společné roky) a t_{jmeno}_{prijmeni}_project_SQL_secondary_final (pro dodatečná data o dalších evropských státech).

### Výzkumné otázky:
1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2. Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3. Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)? 
4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5. Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

### Výsledné skripty:
1. primary_table.sql - skript vytváří tabulku kombinující průměrné mzdy podle odvětví, průměrné ceny potravin, celostátní průměrné mzdy a HDP ČR v letech 2006–2018. Data pocházejí z více zdrojů a jsou sjednocena podle roku pro následnou analýzu.
2. secondary_table.sql - skript vytváří tabulku s údaji o HDP, GINI indexu a populaci evropských zemí v letech 2006–2018 pro další analýzu.
3. 1_task.sql - skript vytváří tabulku s vývojem průměrných mezd v jednotlivých odvětvích v čase, včetně meziročního rozdílu. Následně identifikuje odvětví s poklesem nebo trvalým růstem mezd.
4. 2_task.sql - skript porovnává, kolik chleba a mléka si mohl člověk koupit za průměrnou mzdu v roce 2006 a 2018, a hodnotí tak vývoj dostupnosti těchto potravin v čase.
5. 3_task.sql - skript počítá meziroční procentuální změnu cen všech potravinových kategorií a následně analyzuje průměrný růst cen za celé období.
6. 4_task.sql - skript porovnává meziroční růst cen potravin s růstem průměrné mzdy v ČR a identifikuje potraviny, jejichž ceny rostly výrazně rychleji než mzdy.
7. 5_task.sql - skript analyzuje meziroční vývoj cen potravin, mezd a HDP v ČR a identifikuje roky, kdy HDP vzrostlo o více než 5 % (mnou vybrané procento) nebo kdy na takový růst bezprostředně navázal další rok.

Do skriptů jsem se snažil popsat proměnné nebo co jednotlivé části SQL skriptů dělají, pro lepší pochopení a orinetaci.
Snažil jsem se vytvářet jak view tak tabulky, snad je jejich použití správné.

Ondřej Šimánek