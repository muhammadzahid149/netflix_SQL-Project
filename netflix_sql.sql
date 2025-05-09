-- netflix project--
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
);
select * from netflix;
select
      count (*) as total_content
from netflix;
select distinct type
        from netflix;
		
-- count the number of movies vs tv

select 
	type,
	count (*) as total_content
from netflix
group by type;


-- find the most common rating movies & tv shows

select type,rating
from
 (select
 		type,
		 rating,
		 count(*),
		 rank() over (partition by type order by count(*) desc) as ranking
from netflix	
group by 1,2) as ti
where ranking=1;

-- list all movies release in a specfic year (e.g 2020)
select * from netflix
where type = 'Movie'
				AND
				release_year = 2020;


-- find the top 5 countries ith most content on ntflix
select
	trim(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5;




-- identify the longest movie duration

SELECT
    type,
    title,
    CAST(split_part(duration, ' ', 1) AS INTEGER) AS duration_minutes
FROM
    netflix
WHERE
    type = 'Movie'
    AND duration IS NOT NULL
ORDER BY
    duration_minutes DESC
LIMIT 1;

-- find content added in last 5 year ...

select *
from netflix
where 
to_date(date_added, 'Month DD,yyyy')>= current_date - interval '5 years'

-- 7 find all the movies/tv show by director Peter Segal...?

select * from netflix
where director= 'Peter Segal'
 
-- 8 list all tv shows more than 5 seasons
 select * from netflix
 where 
    type ='TV Show'
	and
	SPLIT_PART(duration,' ',1)::numeric > 5  

-- count the number of content item in each genre 

select 
 unnest(string_to_array(listed_in,',')) as genre,
 COUNT(show_id)
 from netflix
 group by 1;

 --10--find each and the average numbers of content release in india on netflix.
 return top 5 year with highest avg content release

select
extract(year from to_date(date_added, 'Month DD,YYYY')) as year,
count(*)as yearly_content,
round(
count(*) :: numeric /(select count(*)from netflix where country = 'India')::numeric * 100 ,2)as avg_content_per_year
from netflix
where country = 'India'
group by 1;
 


--11--list all movies that are documentaries

select * from netflix
where listed_in ilike'%documentaries%';

-- 12--find all content without director

select * from netflix
where director is null;

--13-- find how many movies actor salman khan appeared in last 10 year

select * from netflix
where  casts ilike '%Salman Khan%'
and 
release_year > extract (year from current_date) - 10;

--14- find top 10 ator who appeared in the highest number of movies produced in india

select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10


--15-- categpries the content based on the presence of keyword 'kill'and 'violence' in the description field.
label content containing these keywords as 'bad'and all other content as 'good'.count how many item fall into each category.


with new_table
as
(

select *,
case
when description ilike '%kill%'or
	description ilike '%violence%' then 'Bad Content'
	else 'Good_content'
	end category
from netflix)
select  category,
		count(*)
		from new_table
		group by 1;























 













