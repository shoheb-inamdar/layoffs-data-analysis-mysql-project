-- Layoffs Data Analysis Project
-- Tool: MySQL

USE world_layoffs;


-- 1. Total Records

SELECT COUNT(*) AS total_records
FROM layoff_staging2;


-- 2. Maximum Layoffs by Company

SELECT 
company,
MAX(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY company
ORDER BY total_layoffs DESC;


-- 3. Top 10 Companies with Highest Layoffs

SELECT 
company,
SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY company
ORDER BY total_layoffs DESC
LIMIT 10;



-- 4. Industry Wise Layoffs

SELECT
industry,
SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY industry
ORDER BY total_layoffs DESC;



-- 5. Country Wise Layoffs

SELECT
country,
SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY country
ORDER BY total_layoffs DESC;



-- 6. Year Wise Layoffs Trend

SELECT
YEAR(`date`) AS year,
SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY year
ORDER BY year;



-- 7. Company Stage Analysis

SELECT
stage,
SUM(total_laid_off) AS total_layoffs
FROM layoff_staging2
GROUP BY stage
ORDER BY total_layoffs DESC;



-- 8. Top Companies Per Year

WITH yearly_company_layoffs AS
(
SELECT
company,
YEAR(`date`) AS year,
SUM(total_laid_off) AS layoffs
FROM layoff_staging2
GROUP BY company, YEAR(`date`)
),

ranking AS
(
SELECT *,
DENSE_RANK() OVER(
PARTITION BY year
ORDER BY layoffs DESC
) AS ranking
FROM yearly_company_layoffs
)

SELECT *
FROM ranking
WHERE ranking <= 5;



-- 9. Rolling Total Layoffs

WITH monthly_layoffs AS
(
SELECT
YEAR(`date`) year,
MONTH(`date`) month,
SUM(total_laid_off) layoffs
FROM layoff_staging2
GROUP BY YEAR(`date`), MONTH(`date`)
)

SELECT *,
SUM(layoffs) OVER(
ORDER BY year, month
) AS rolling_total
FROM monthly_layoffs;
