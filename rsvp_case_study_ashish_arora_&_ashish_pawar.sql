USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Segment 1:
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
WITH table_summary AS	
	(
		(SELECT  	'director_mapping' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		director_mapping)

				UNION ALL 
				
		(SELECT		'genre' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		genre)

				UNION ALL
				
		(SELECT 	'movie' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		movie) 

				UNION ALL 
				
		(SELECT 	'names' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		names) 

				UNION ALL 
				
		(SELECT 	'ratings' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		ratings) 

				UNION ALL 
				
		(SELECT 	'role_mapping' AS Table_names, 
					COUNT(*) AS Total_Rows 
		FROM 		role_mapping)
	)
	SELECT * 
    FROM table_summary
    order by Total_Rows;
 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

WITH null_summary AS
(
	(SELECT   'id' AS Column_Names, 
			  SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
						union all
	(SELECT   'title' AS Column_Names,      
			  SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
						union all
	(SELECT   'year' AS Column_Names, 
			  SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
						union all		
	(SELECT   'date_published' AS Column_Names,      
			  SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
						union all
	(SELECT   'duration' AS Column_Names, 
			  SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM 	  movie)
						union all
	(SELECT   'country' AS Column_Names,      
			  SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) 	AS Null_Count
	FROM      movie)
						union all
	(SELECT   'worlwide_gross_income' AS Column_Names,      
			  SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM	  movie)
						union all
	(SELECT   'languages' AS Column_Names, 
			  SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
						union all
	(SELECT   'production_company' AS Column_Names,      
			  SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS Null_Count
	FROM      movie)
)
	SELECT 	 Column_Names
    FROM     null_summary
    WHERE    Null_Count >0;

/*
country					 		20	 null_counts
languages					    194	 null_counts
production_company		 		528	 null_counts		
worldwide_gross_income_null 	3724 null_counts	
*/
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 


-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+
Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans1:
SELECT	 	Year, 
			COUNT(id) AS number_of_movies
FROM 	 	movie
GROUP BY 	Year
ORDER BY 	Year;
-- In 2017 MOST movies (3052) are produced
-- IN 2019 LEAST movies (2001) are produced.

-- Ans2:
SELECT 	 	MONTH(date_published) AS month_num,
			COUNT(id) AS number_of_movies
FROM	 	movie
GROUP BY 	MONTH(date_published)
ORDER BY 	month_num;

-- IN DECEMBER MINIMUM MOVIES ARE RELEASED(438)
-- IN MARCH MAXIMUM MOVIES ARE RELEASED (824).

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 

We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

                        
SELECT Count(id) AS Movie_Count
FROM   movie
WHERE  year = 2019
       AND country REGEXP 'USA|India'; 
            
            

-- INDIA PRODUCED 295 MOVIES WHEREAS USA PRODUCED 592 MOVIES IN 2019. 
-- USA PRODUCED ALMOST DOUBLE OF WHAT INDA PRODUCED IN 2019.

-- USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.



-- Exploring table Genre would be fun!! 
/*
SELECT SUM( CASE WHEN GENRE IS NULL THEN 1 ELSE 0 END) GENRE_NULL_COUNT
FROM GENRE;*/

-- NO NULL VALUES IN GENRE

/*Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT		genre 
FROM 		genre
GROUP BY 	genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

WITH genre_summary AS
	(
		SELECT 		gen.genre, 
					COUNT(mov.id) AS genre_count_movie,
					ROW_NUMBER() OVER (ORDER BY COUNT(mov.id) DESC )AS row_numbers	
		FROM 		genre AS gen
		INNER JOIN 	movie AS mov
		ON 			gen.movie_id = mov.id
		GROUP BY 	gen.genre
	)
	SELECT 		genre, genre_count_movie
	FROM 		genre_summary
	WHERE 		row_numbers = 1;


-- Drama genre had the higheset number of movies produced overall.


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movie_genre_summary AS 
	(
		SELECT 		mov.id AS movies_id, 
					COUNT(gen.genre) AS count_genre
		FROM 		genre AS gen
		INNER JOIN 	movie AS mov
		ON 			gen.movie_id = mov.id
		GROUP BY 	mov.id
		HAVING 		count(gen.genre)=1
	)
	SELECT 		count(movies_id) AS total_movies_with_one_genre
	FROM 		movie_genre_summary;

-- 3289 MOVIES ARE ONLY BASED ON ONE GENRE.


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 	 	gen.genre, 
			ROUND(AVG(duration)) AS avg_duration
FROM 		genre AS gen
INNER JOIN 	movie AS mov
ON 			gen.movie_id = mov.id 
GROUP BY  	gen.genre
ORDER BY 	gen.genre DESC;

-- AVG ROUNDED DURATION OF DRAMA IS 107 MINS.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_rank_summary AS
	(
		SELECT 		genre,
					COUNT(movie_id) AS movie_count,
					Rank() OVER (ORDER BY COUNT(movie_id) DESC ) AS genre_rank	
		FROM 		genre 
		GROUP BY 	genre
	)
	SELECT 		*
	FROM 		genre_rank_summary
	WHERE 		genre = "thriller";

-- Thriller ranks 3rd with 1484 of movies count.

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Segment 2:
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Q10.  Find the minimum and maximum values in each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT 		ROUND(MIN(avg_rating))    AS min_avg_rating,
			ROUND(MAX(avg_rating))    AS max_avg_rating,
			ROUND(MIN(total_votes))   AS min_total_votes,
			ROUND(MAX(total_votes))   AS max_total_votes,
			ROUND(MIN(median_rating)) AS min_median_rating,
			ROUND(MAX(median_rating)) AS min_median_rating
FROM 		ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too.

WITH top_movies AS
	(
		SELECT 		mov.title,
					rtg.avg_rating,
					Dense_rank() OVER(ORDER BY rtg.avg_rating DESC) AS movie_rank
		FROM   		movie AS mov
		INNER JOIN 	ratings AS rtg
		ON 			mov.id = rtg.movie_id
	)
	SELECT 		*
	FROM   		top_movies
	WHERE  		movie_rank < 11; 






/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.

/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


SELECT 		rat.median_rating,
			COUNT(mov.id) AS movie_count
FROM 		movie AS mov
INNER JOIN 	ratings AS rat
ON 			rat.movie_id = mov.id
GROUP BY 	median_rating
ORDER BY 	rat.median_rating;

-- Movies with 7 median_rating are the most.
-- Whereas median_rating of 9 and 10 are less than 500.


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 		mov.production_company,
			count(mov.id) as movie_count,
			dense_rank() over( order by count(mov.id) desc) as prod_company_rank
from 		movie as mov
left join 	ratings as rat
on 			rat.movie_id = mov.id
where 		avg_rating >8 
				and 
			production_company is not null
group by 	mov.production_company;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 		gen.genre, 
			COUNT(mov.id) AS movie_count
FROM		movie AS mov
INNER JOIN	genre AS gen 
ON 			gen.movie_id = mov.id
INNER JOIN 	ratings AS rat 
ON 			rat.movie_id = mov.id
WHERE		DATE_FORMAT(mov.date_published, '%M %Y') = 'March 2017'
				AND 
			mov.country regexp  'USA'
				AND 
			rat.total_votes > 1000
GROUP BY 	gen.genre
ORDER BY 	gen.genre desc;

-- mostly drama movies (24) are realeased in usa in march 2017, having total votes greater than 1000.


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 		mov.title,
			rat.avg_rating,
			gen.genre
FROM		movie AS mov
INNER JOIN 	genre AS gen
ON 			gen.movie_id = mov.id
INNER JOIN 	ratings AS rat
ON 			rat.movie_id = mov.id
WHERE 		rat.avg_rating > 8 
				AND 
			title REGEXP '^the.*'
ORDER BY 	genre DESC;




-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
/*
SELECT mov.title,
		rat.avg_rating,
        rat.median_rating,
        gen.genre
FROM movie AS mov
INNER JOIN genre AS gen
ON gen.movie_id = mov.id
INNER JOIN ratings AS rat
ON rat.movie_id = mov.id
WHERE rat.avg_rating > 8 AND title REGEXP '^the.*'
ORDER BY genre, avg_rating DESC;
*/



-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 		COUNT(mov.id) AS total_movies
FROM 		movie AS mov
INNER JOIN 	ratings AS rat
ON 			rat.movie_id = mov.id
WHERE 		rat.median_rating = 8 
				AND 
			mov.date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- Insights
-- 361 movies have released between 1 April 2018 and 1 April 2019. 

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

(
	SELECT 		'Italian' AS languages, 
				SUM(rat.total_votes) AS total_votes
	FROM 		movie AS mov
	INNER JOIN 	ratings AS rat
	ON 			mov.id = rat.movie_id
	WHERE 		languages REGEXP 'italian'
)
		UNION ALL
(
	SELECT 		'German' AS languages, 
				SUM(rat.total_votes) AS total_votes
	FROM 		movie AS mov
	INNER JOIN 	ratings AS rat
	ON 			mov.id = rat.movie_id
	WHERE 		languages REGEXP 'german'
);

-- Insights
-- ITALIAN	2559540
-- GERMAN	4421525

-- Answer is Yes
/*
Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.
*/

-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Segment 3:
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

/*-- Q18. Which columns in the names table have null values??
Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

SELECT 		SUM(CASE 
					WHEN name IS NULL 
                    THEN 1 
                    ELSE 0
				END) AS name_nulls,
			SUM(CASE 
					WHEN height	IS NULL 
                    THEN 1 
                    ELSE 0
				END) AS height_nulls,
			SUM(CASE 
					WHEN date_of_birth 	IS NULL 
                    THEN 1 
                    ELSE 0 
				END) AS date_of_birth_nulls,
			SUM(CASE 
					WHEN known_for_movies IS NULL 
                    THEN 1 
                    ELSE 0 
				END) AS known_for_movies_nulls
FROM		names;

/*
height_nulls - 17335, 
date_of_birth_nulls - 13431
known_for_movies_nulls - 15226 
*/		

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH genre_summary AS
	( 
		SELECT  		gen.genre, 
						count(gen.movie_id),
						RANK() OVER (ORDER BY count(gen.movie_id) DESC) AS ranks
		FROM 			genre AS gen
		INNER JOIN 		ratings AS rat
		ON 				rat.movie_id = gen.movie_id
		WHERE 			rat.avg_rating > 8
		GROUP BY 		gen.genre
	),
	top_three_directors AS
		(
			SELECT 		nm.name AS director_name,
						count(dir.movie_id) AS movie_count,
						RANK() OVER (ORDER BY count(dir.movie_id) DESC) AS ranks_director
			FROM 		names AS nm
			INNER JOIN 	director_mapping AS dir 
			ON 			dir.name_id = nm.id
			INNER JOIN 	genre AS gnr 
			ON 			gnr.movie_id = dir.movie_id
			INNER JOIN  ratings AS rtg 
			ON 			rtg.movie_id = gnr.movie_id
			WHERE 		rtg.avg_rating >8
							AND
						gnr.genre IN ( SELECT 	genre 
									   FROM 	genre_summary 
                                       WHERE 	ranks <=3) 
			GROUP BY 	nm.name
		)
		SELECT 		director_name, movie_count, ranks_director
		FROM 		top_three_directors
		WHERE 		ranks_director <=3;
						


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_actor_summary AS
	(
		SELECT 		nm.name AS actor_name,
					count(rtg.movie_id) AS movie_count,
					RANK() over (ORDER BY count(rtg.movie_id) DESC) AS ranks
		FROM 		role_mapping AS role_map
		INNER JOIN 	names AS nm
		ON 			nm.id = role_map.name_id
		INNER JOIN 	ratings AS rtg
		on 			role_map.movie_id = rtg.movie_id
		WHERE 		role_map.category = 'actor' 
							AND 
					rtg.median_rating >= 8
		GROUP BY 	nm.name
	)
	SELECT 		actor_name,
				movie_count
	FROM 		top_actor_summary
	WHERE 		ranks<=2;






/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_comp_rank_summary AS
	(
		SELECT 		mov.production_company,
					SUM(rtg.total_votes) AS vote_count,
					RANK() OVER (ORDER BY SUM(rtg.total_votes) DESC) AS prod_comp_rank
		FROM 		movie AS mov
		INNER JOIN 	ratings AS rtg
		ON 			rtg.movie_id = mov.id
		GROUP BY 	mov.production_company
	)
	SELECT 		* 
	FROM 		prod_comp_rank_summary
	WHERE 		prod_comp_rank <=3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 		nm.name AS actor_name, 
			SUM(total_votes) AS total_votes,
			COUNT(mov.id) AS movie_count,
			ROUND(SUM(rtg.avg_rating*rtg.Total_votes) / SUM(rtg.total_votes), 2) AS actor_avg_rating,
			RANK() OVER(ORDER by SUM(rtg.avg_rating*rtg.Total_votes) / SUM(rtg.total_votes) DESC) AS actor_rank 
FROM 		role_mapping AS role_map
INNER JOIN 	names AS nm
ON 			nm.id = role_map.name_id
INNER JOIN 	movie AS mov
ON 			mov.id = role_map.movie_id
INNER JOIN 	ratings AS rtg
ON 			mov.id = rtg.movie_id
WHERE 		role_map.category = 'actor' 
					and 
			mov.country REGEXP 'India'
GROUP BY 	nm.name
having 		count(mov.id) >=5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_name_movie_count_summary AS
	(
		SELECT 		nm.name AS actress_name, 
					sum(total_votes) AS Total_votes,
					count(mov.id) AS movie_count,
					ROUND(SUM(rtg.avg_rating*Total_votes) / SUM(Total_votes), 2) AS actress_avg_rating,
					RANK() OVER(ORDER BY SUM(rtg.avg_rating * Total_votes) / SUM(Total_votes) DESC) AS actress_rank 
		FROM 		role_mapping AS role_map
		INNER JOIN 	names AS nm
		ON 			nm.id = role_map.name_id
		INNER JOIN 	movie AS mov
		ON 			mov.id = role_map.movie_id
		INNER JOIN 	ratings AS rtg
		ON 			mov.id = rtg.movie_id
		WHERE 		role_map.category = 'actress' 
							AND 
					mov.languages REGEXP 'HINDI' 
							AND 
					mov.country REGEXP 'INDIA'
		GROUP BY 	nm.name
		HAVING 		count(mov.id) >=3
	)
	SELECT 		*
	FROM 		actress_name_movie_count_summary
	WHERE 		actress_rank <=5;
    
    
    /* Output:
			+---------------+---------------+---------------+-------------------+---------------+
			| actress_name	|  total_votes	|  movie_count	|actress_avg_rating	| actress_rank	|
			+---------------+---------------+---------------+-------------------+---------------+
			|Taapsee Pannu	|	   18061	|	 	3	  	|	   7.74	    	|		1	    |
			|Kriti Sanon	|	   21967	|	    3		|	   7.05	    	|		2	    |
			|Divya Dutta	|	   8579		|	    3		|	   6.88	    	|		3	    |
			|Shraddha Kapoor|	   26779	|	    3		|	   6.63	    	|		4	    |
			|Kriti Kharbanda|	   2549		|	    3		|	   4.80	    	|		5	    |
            +---------------+---------------+---------------+-------------------+---------------+*/
    

-- Taapsee Pannu tops with average rating 7.74. 




/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT  	mov.id, 
			mov.title, 
			gen.genre, 
			rtg.avg_rating, 
			(CASE WHEN avg_rating > 8 THEN 'Superhit movies'
				  WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
				  WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
				  WHEN avg_rating < 5 THEN 'Flop movies'
			END) AS Rating_classify
FROM 		movie AS mov
INNER JOIN 	genre AS gen
ON 			mov.id = gen.movie_id
INNER JOIN 	ratings AS rtg
ON 			mov.id = rtg.movie_id
WHERE 		gen.genre = 'thriller'
ORDER BY 	rtg.avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/



-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
-- Segment 4:
-- >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_duration_summary AS
(
	SELECT 		gen.genre, 
				AVG(mov.duration) AS avg_durat
	FROM 		movie AS mov
	INNER JOIN 	genre AS gen
	ON 			mov.id = gen.movie_id
	GROUP BY 	gen.genre
)
SELECT genre, 
		ROUND(avg_durat) as avg_duration,
		ROUND(SUM(avg_durat) OVER W,1) AS running_total_duration,
		ROUND(AVG(avg_durat) OVER W ,2) AS moving_avg_duration
FROM genre_duration_summary
WINDOW W AS ( ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW);

/* Output:
			+---------------+---------------+-----------------------+-------------------+
			|	  genre		| avg_duration	|running_total_duration |moving_avg_duration|
			+---------------+---------------+-----------------------+-------------------+
            |	Action		|	  113		|		  112.9			|	  112.88		|
			|	Adventure	|	  102		|		  214.8			|	  107.38		|
			|	Comedy		|	  103		|		  317.4			|	  105.79		|
			|	Crime		|	  107		|		  424.5			|	  106.11		|
			|	Drama		|	  107		|		  531.3			|	  106.24		|
			|	Family		|	  101		|		  632.3			|	  105.36		|
			|	Fantasy		|	  105		|		  737.4			|	  105.33		|
			|	Horror		|	  93		|		  830.1			|	  103.75		|
			|	Mystery		|	  102		|		  931.9			|	  103.54		|
			|	Others		|	  100		|		 1032.1			|	  103.20		|
			|	Romance		|	  110		|		 1141.6			|	  103.77		|
			|	Sci-Fi		|	  98		|		 1239.5			|	  103.29		|
			|	Thriller	|	  102		|		 1341.1			|	  103.16		|
			+---------------+---------------+-----------------------+-------------------+*/
	







-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_three_genre AS
	(
		SELECT  gen.genre, 
				count(mov.id),
				RANK() OVER (ORDER BY count(mov.id) DESC) AS ranks
		FROM genre AS gen
		INNER JOIN movie AS mov
		ON gen.movie_id = mov.id
		GROUP BY gen.genre
	),
        top_three_genre_movies AS
			( 	
				SELECT  mo.id as movie_id,
						ge.genre as genre,
						YEAR(mo.date_published) AS year,
                        mo.title AS movie_name,
                        CAST(REPLACE(REPLACE( ifnull(mo.worlwide_gross_income,0), '$', ''), 'INR', '') AS DECIMAL(20)) AS worlwide_gross_income
                FROM movie AS mo
                INNER JOIN genre AS ge
                ON ge.movie_id = mo.id
                WHERE ge.genre IN ( SELECT genre 
									FROM top_three_genre 
                                    WHERE ranks<4)
			),
				rank_gross_income AS
						(
							SELECT genre,
									year,
									movie_name,
									worlwide_gross_income,
									rank() over( partition by year order by worlwide_gross_income desc) as movie_rank
							FROM top_three_genre_movies
                            GROUP BY movie_id
                         )
							SELECT * 
                            FROM rank_gross_income
                            where movie_rank<=5;
		
       /* Output:
			+-----------+-------+-------------------------------+-----------------------+-----------+
			|   genre	|  year	|movie_name						|worlwide_gross_income	|movie_rank	|
			+-----------+-------+-------------------------------+-----------------------+-----------+
			|Thriller	| 2017	|The Fate of the Furious		|	  1236005118		|	  1		|
			|Comedy		| 2017	|Despicable Me 3				|	  1034799409		|	  2		|
			|Comedy		| 2017	|Jumanji: Welcome to the Jungle	|	  962102237			|	  3		|
			|Drama		| 2017	|Zhan lang II					|	  870325439			|	  4		|
			|Comedy		| 2017	|Guardians of the Galaxy Vol. 2	|	  863756051			|	  5		|
			|Thriller	| 2018	|The Villain					|	  1300000000		|	  1		|
			|Drama		| 2018	|Bohemian Rhapsody				|	  903655259			|	  2		|
			|Thriller	| 2018	|Venom							|	  856085151			|	  3		|
			|Thriller	| 2018	|Mission: Impossible - Fallout	|	  791115104			|	  4		|
			|Comedy		| 2018	|Deadpool 2						|	  785046920			|	  5		|
			|Drama		| 2019	|Avengers: Endgame				|	  2797800564		|	  1		|
			|Drama		| 2019	|The Lion King					|	  1655156910		|	  2		|
			|Comedy		| 2019	|Toy Story 4					|	  1073168585		|	  3		|
			|Drama		| 2019	|Joker							|	  995064593			|	  4		|
			|Thriller	| 2019	|Ne Zha zhi mo tong jiang shi	|	  700547754			|	  5		|
			+-----------+-------+-------------------------------+-----------------------+-----------+ */ 
                
        
 


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_summary AS 
	(
		SELECT 		mov.production_company AS production_company,
					count(mov.id) AS movie_count,
					rank() over (order by count(mov.id) desc) as prod_comp_rank
		FROM 		movie AS mov
		INNER JOIN 	ratings AS rtg
		ON 			rtg.movie_id = mov.id
		WHERE 		mov.languageS regexp ',' 
							AND 
					rtg.median_rating >=8 
							AND 
					mov.production_company IS NOT NULL
		GROUP BY mov.production_company
	)
    SELECT * 
    FROM production_company_summary
    WHERE prod_comp_rank <=2;
   
   /*
			+-----------------------+-----------+---------------+
			|production_company 	|movie_count| prod_comp_rank|
			+-----------------------+-----------+---------------+
			| Star Cinema			|	  7		|		1	  	|
			| Twentieth Century Fox	|	  4		|		2		|
			+-----------------------+-----------+---------------+*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:




WITH actress_name_movie_drama_summary AS
	(
		SELECT 		nm.name AS actor_name, 
					SUM(rtg.total_votes) AS total_votes,
					COUNT(mov.id) AS movie_count,
                    ROUND(Sum(rtg.avg_rating * rtg.total_votes) / Sum(rtg.total_votes), 2) AS actress_avg_rating,
					DENSE_RANK() OVER w AS actress_rank,
					RANK() OVER w as ranks
		FROM 		role_mapping AS role_map
		INNER JOIN 	names AS nm
		ON 			nm.id = role_map.name_id
		INNER JOIN 	movie AS mov
		ON 			mov.id = role_map.movie_id
		INNER JOIN 	ratings AS rtg
		ON 			mov.id = rtg.movie_id
		INNER JOIN 	genre AS gen
		ON 			mov.id = gen.movie_id
		WHERE 		role_map.category = 'actress' 
							AND 
					gen.genre = 'drama' 
							AND 
					rtg.avg_rating >8
		GROUP BY 	nm.name
		WINDOW 		w AS (ORDER BY count(mov.id) DESC)
	)
	SELECT 	actor_name,
			total_votes,
			movie_count,
			actress_avg_rating,
			actress_rank
	FROM 	actress_name_movie_drama_summary
	WHERE 	ranks <= 3;

/* Output:
			+-------------------+-----------+-----------+--------------------+------------+
			|   actress_name	|total_votes|movie_count| actress_avg_rating |actress_rank|
			+-------------------+-----------+-----------+--------------------+------------+
			|Parvathy Thiruvothu|	4974	|	  2 	|	    8.25	     |		1	  |
			|Susan Brown		|	656		|	  2     |	    8.94   		 |		1	  |
			|Amanda Lawrence	|	656		|	  2     |	    8.94   		 |		1	  |
            |Denise Gough		|	656		|	  2     |	    8.94   		 |		1	  |
			+---------------+---------------+-----------+----------+----------------------+
		Insights:  "Parvathy Thiruvothu is the top actress based on number of Super Hit movies in drama genre*/







/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH DIRECTOR_SUMMARY AS
	(
		SELECT 		dir.name_id AS director_id,
					nm.name AS director_name,
					mov.id AS movies_id,
					rtg.avg_rating AS avg_ratings,
					rtg.total_votes	AS votes,
					mov.duration AS durations,
					DATEDIFF(LEAD(mov.date_published,1) OVER( PARTITION BY dir.name_id ORDER BY mov.date_published), 
							mov.date_published) AS inter_movies_duration
		FROM 		movie AS mov
		INNER JOIN 	ratings AS rtg
		ON 			mov.id  = rtg.movie_id
		INNER JOIN 	director_mapping AS dir
		ON 			mov.id = dir.movie_id
		INNER JOIN 	names AS nm
		ON 			nm.id = dir.name_id
	), 
	TOP_DIRECTOR_SUMMARY AS
		(
			SELECT 		director_id,
						director_name,
						COUNT(movies_id) 			AS number_of_movies,
						ROUND(AVG(inter_movies_duration))	AS avg_inter_movie_days,
						Round(Sum(avg_ratings*votes)/Sum(votes), 2) as avg_rating,
						sum(votes) 					AS total_votes,
						MIN(avg_ratings)			AS min_rating,
						MAX(avg_ratings)			AS max_rating,
						SUM(durations)			    AS total_duration,
						ROW_NUMBER() OVER (ORDER BY COUNT(movies_id) DESC) AS ROWS_NUMBER
			FROM		DIRECTOR_SUMMARY
			GROUP BY director_id
		)
		SELECT  	director_id,
					director_name,
					number_of_movies,
					avg_inter_movie_days,
					avg_rating,
					total_votes,
					min_rating,
					max_rating,
					total_duration
		FROM 		TOP_DIRECTOR_SUMMARY
		WHERE 		ROWS_NUMBER <=9;

/* Output:
+---------------+-------------------+-------------------+-----------------------+---------------+-----------+-----------+------------+----------------+
| director_id	|	director_name	| number_of_movies	| avg_inter_movie_days	|	avg_rating	|total_votes|min_rating	| max_rating | total_duration |
+---------------+-------------------+-------------------+-----------------------+---------------+-----------+-----------+------------+----------------+
|	nm1777967	|A.L. Vijay			|		  5			|		    177			|	  5.65		|	1754	|	  3.7	|	  6.9	 |		613		  |
|	nm2096009	|Andrew Jones		|		  5			|			191			|	  3.04		|	1989	|	  2.7	|	  3.2	 |		432		  |
|	nm0001752	|Steven Soderbergh	|		  4			|			254			|	  6.77		|	171684	|	  6.2	|	  7.0	 |		401		  |
|	nm0425364	|Jesse V. Johnson	|		  4			|			299			|	  6.10		|	14778	|	  4.2	|	  6.5	 |		383		  |
|	nm0515005	|Sam Liu			|		  4			|			260			|	  6.32		|	28557	|	  5.8	|	  6.7	 |		312		  |
|	nm0814469	|Sion Sono			|		  4			|			331			|	  6.31		|	2972	|	  5.4	|	  6.4	 |		502		  |
|	nm0831321	|Chris Stokes		|		  4			|			198			|	  4.32		|	3664	|	  4.0	|	  4.6	 |		352		  |
|	nm2691863	|Justin Price		|		  4			|			315			|	  4.93		|	5343	|	  3.0	|	  5.8	 |		346		  |
|	nm6356309	|Özgür Bakar		|		  4			|			112			|	  3.96		|	1092	|	  3.1	|	  4.9	 |		374		  |
+---------------+-------------------+-------------------+-----------------------+---------------+-----------+-----------+------------+----------------+*/

/*

