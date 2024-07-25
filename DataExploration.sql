Select *
from layoffs_staging2;

-- seeing highest total laid off and percentage laid off
Select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;


Select *
from layoffs_staging2
where percentage_laid_off ='1'
order by funds_raised_millions desc;

Select company , sum(total_laid_off)
from layoffs_staging2
group by company
order 
by 2 desc
limit 10;

-- seeing the starting duration of layoff and ending 
Select min(date), max(date)
from layoffs_staging2
;

-- query for seeing which industry had the most lay off
 Select industry , sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

 Select *
from layoffs_staging2;

-- query for seeing which country had the most lay off
 Select country , sum(total_laid_off)
from layoffs_staging2
group by country
order by 1 desc;

 Select year(date) , sum(total_laid_off)
from layoffs_staging2
group by year(date)
order by 1 desc;

 Select stage , sum(total_laid_off)
from layoffs_staging2
group by stage 
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, avg(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select * from layoffs_staging2;

select substring(date,1,7) as Month , sum(total_laid_off)
from layoffs_staging2
where substring(date,1,7) is not null
group by Month
order by 1 asc; 

-- getting the rolling total of layoff by months 
with Rolling_Total as
(
select substring(date,1,7) as Month , sum(total_laid_off) as total_off
from layoffs_staging2
where substring(date,1,7) is not null
group by Month
order by 1 asc
)
select Month, total_off,
sum(total_off) over(order by Month) as rolling_total
from Rolling_Total;

-- query for getting the top 5 company in a particular year to have highest lay off
select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

with Company_Year (company, years, total_laid_off) as 
(
select company, year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
),
Company_Year_Rank as 
(
select *, 
Dense_Rank() over( Partition By years order by total_laid_off Desc) as Ranking
from Company_Year
where years is not null
)
select * 
from Company_Year_Rank
where Ranking <=5
;





