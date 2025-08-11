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

### Odpovědi:
1. Podle výsledků datové analýzy lze říci, že mzdy v průběhu let nerostou ve všech odvětvích. Největší pokles zaznamenalo odvětví **Těžba a dobývání**, kde došlo k meziročnímu snížení mezd hned **čtyřikrát**. V ostatních odvětvích se pokles vyskytl pouze 1–2krát.

Naopak v následujících odvětvích mzdy rostly každý rok bez výjimky:
- Doprava a skladování
- Administrativní a podpůrné činnosti
- Zdravotní a sociální péče
- Ostatní činnosti
- Zpracovatelský průmysl

2. V roce **2006** bylo možné si za průměrnou mzdu koupit:  
- **1 172,57 kg** chleba  
- **1 308,99 l** mléka  

V roce **2018** to bylo již:  
- **1 278,8 kg** chleba  
- **1 563,98 l** mléka  

Z toho vyplývá, že dostupnost obou potravin se v průběhu sledovaného období **zvýšila** – a to i přes růst jejich cen, protože průměrná mzda rostla rychleji.

3. Podle dat mají nejnižší průměrný meziroční procentuální nárůst ceny tyto potraviny  
(seřazeno od nejpomaleji zdražujících - vybráno TOP 5 potravin):

1. **Banány žluté** – **0,81 %**  
2. **Vepřová pečeně s kostí** – **0,99 %**  
3. **Přírodní minerální voda uhličitá** – **1,03 %**  
4. **Šunkový salám** – **1,86 %**  
5. **Jablka konzumní** – **2,02 %**  

Z toho vyplývá, že **banány žluté** zdražují v průměru nejpomaleji.

4. Ano, v dostupných datech existuje více případů, kdy byl meziroční nárůst cen potravin výrazně vyšší než růst mezd — a to o více než **10 procentních bodů**.  

Nejvýraznější rozdíly byly zaznamenány zejména u těchto kombinací rok–potravina:  

1. **2011 – Máslo**: růst ceny **+250,90 %** vs. růst mezd **+2,22 %** → rozdíl **+248,68 p. b.**  
2. **2007 – Eidamská cihla**: **+199,49 %** vs. **+6,75 %** → **+192,74 p. b.**  
3. **2013 – Eidamská cihla**: **+180,39 %** vs. **−0,13 %** → **+180,52 p. b.**  
4. **2012 – Vejce slepičí čerstvá**: **+125,10 %** vs. **+2,58 %** → **+122,52 p. b.**  
5. **2010 – Máslo**: **+122,00 %** vs. **+2,08 %** → **+119,92 p. b.**  

Tyto extrémní rozdíly se objevují napříč sledovanými lety, ale často se týkají **másla**, **eidamské cihly** a **vajec**.

5. Na základě dostupných dat **nelze prokázat jednoznačný a přímý vliv růstu HDP na výraznější růst mezd nebo cen potravin** ve stejném či následujícím roce.  

V letech s vyšším růstem HDP (např. **2007**, **2015**, **2017**) sice často dochází i k růstu mezd,  
ale změny cen potravin jsou méně konzistentní — v některých letech (např. **2015** a **2016**) dokonce ceny potravin v průměru **klesaly**.  

**Příklady:**  
- **2017**: HDP **+5,17 %**, mzdy **+6,94 %**, ceny potravin **+9,63 %**  
- **2015**: HDP **+5,39 %**, mzdy **+3,17 %**, ceny potravin **−0,54 %**  

To naznačuje, že **mzdová úroveň může na růst HDP reagovat častěji než ceny potravin**,  
ale vztah není dostatečně silný ani pravidelný, aby se dal považovat za jasný vzorec.

### Výsledné skripty:
1. ***primary_table.sql*** - skript vytváří tabulku kombinující průměrné mzdy podle odvětví, průměrné ceny potravin, celostátní průměrné mzdy a HDP ČR v letech 2006–2018. Data pocházejí z více zdrojů a jsou sjednocena podle roku pro následnou analýzu.
2. ***secondary_table.sql*** - skript vytváří tabulku s údaji o HDP, GINI indexu a populaci evropských zemí v letech 2006–2018 pro další analýzu.
3. ***1_task.sql*** - skript vytváří tabulku s vývojem průměrných mezd v jednotlivých odvětvích v čase, včetně meziročního rozdílu. Následně identifikuje odvětví s poklesem nebo trvalým růstem mezd.
4. ***2_task.sql*** - skript porovnává, kolik chleba a mléka si mohl člověk koupit za průměrnou mzdu v roce 2006 a 2018, a hodnotí tak vývoj dostupnosti těchto potravin v čase.
5. ***3_task.sql*** - skript počítá meziroční procentuální změnu cen všech potravinových kategorií a následně analyzuje průměrný růst cen za celé období.
6. ***4_task.sql*** - skript porovnává meziroční růst cen potravin s růstem průměrné mzdy v ČR a identifikuje potraviny, jejichž ceny rostly výrazně rychleji než mzdy.
7. ***5_task.sql*** - skript analyzuje meziroční vývoj cen potravin, mezd a HDP v ČR a identifikuje roky, kdy HDP vzrostlo o více než 5 % (mnou vybrané procento) nebo kdy na takový růst bezprostředně navázal další rok.

Do skriptů jsem se snažil popsat proměnné nebo co jednotlivé části SQL skriptů dělají, pro lepší pochopení a orinetaci.
Snažil jsem se vytvářet jak view tak tabulky, snad je jejich použití správné.

Ondřej Šimánek