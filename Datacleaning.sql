SELECT * FROM world_layoffs.layoffs;
Create Table world_layoffs.layoffs_staging
Like layoffs;
select * from world_layoffs.layoffs_staging;
-- INSERT layoffs_staging:
select * 
from world_layoffs.layoffs;

-- REMOVING DUPLICATES:
select company,location,industry,total_laid_off, percentage_laid_off, 'date',
row_number() over(
partition by company,location,industry,total_laid_off, percentage_laid_off, 'date') AS row_num
from world_layoffs.layoffs_staging;



SELECT *
FROM (
	SELECT company, industry, total_laid_off,`date`,
		ROW_NUMBER() OVER (
			PARTITION BY company, industry, total_laid_off,`date`
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1;

select * from 
layoffs_staging where company ='Oda';

-- removing actual duplicates where row_num is more than 1
select *
from (
     select company, location, total_laid_off, percentage_laid_off,'date',
     stage, country, funds_raised_millions,
     row_number() over(
     partition by company, location, total_laid_off, percentage_laid_off,'date',
     stage, country, funds_raised_millions
) As row_num
from world_layoffs.layoffs_staging
) duplicates
where 
row_num > 1;

-- deleting the actual duplicates 
WITH DELETE_CTE AS 
(
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging
) duplicates
WHERE 
	row_num > 1
)
DELETE
FROM DELETE_CTE
;

-- since the above approach is not possible we have to create a new column and add those row numbers in. Then delete where row numbers are over 2, then delete that column

SELECT *
FROM world_layoffs.layoffs_staging
;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `world_layoffs`.`layoffs_staging2`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		world_layoffs.layoffs_staging;
        
select * from world_layoffs.layoffs_staging2 ;
-- deletin the rows where row_num is greater than 1
delete from world_layoffs.layoffs_staging2 where row_num >=2;

-- deleted all duplicates 
 
 -- standardizing data
 select company, trim(company)
 from world_layoffs.layoffs_staging2;
 
 Update world_layoffs.layoffs_staging2
 set company = trim(company);
 
 select *
 from world_layoffs.layoffs_staging2
 where industry like 'Crypto%';
 
update world_layoffs.layoffs_staging2
set industry ='Crypto'
where industry like 'Crypto%';

select country
 from world_layoffs.layoffs_staging2
 where country like 'United States%';
 update world_layoffs.layoffs_staging2
 set country = 'United States'
 where country like 'United States%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;
 update world_layoffs.layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');
select * from 
world_layoffs.layoffs_staging2;

Alter table layoffs_staging2
MODIFY column `date` Date;

-- DEALING WITH NULL VALUES

select * from 
layoffs_staging2 
where total_laid_off is null
and percentage_laid_off is null;

select t1.company ,t2.company
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where 
t1.industry is null 
and t2.industry is not null;
 
 update layoffs_staging2
 set industry = null where industry=' ';

select * from layoffs_staging2;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;
 delete
 from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

alter table  layoffs_staging2
drop column row_num;

select *
from layoffs_staging2;










