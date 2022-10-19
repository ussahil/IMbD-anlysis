USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) FROM director_mapping;
SELECT COUNT(*) FROM  genre;
SELECT COUNT(*) FROM  movie;
SELECT COUNT(*) FROM  names;
SELECT COUNT(*) FROM  ratings;
SELECT COUNT(*) FROM  role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT title FROM movie WHERE title IS NULL; -- not null
SELECT year FROM movie WHERE year IS NULL; -- not null 
SELECT date_published FROM movie WHERE date_published IS NULL; -- not null 
SELECT duration FROM movie WHERE duration IS NULL; -- not null 
SELECT country FROM movie WHERE country IS NULL; --  null value
SELECT worlwide_gross_income FROM movie WHERE worlwide_gross_income IS NULL; --  null value
SELECT languages FROM movie WHERE languages IS NULL; --  null value
SELECT production_company FROM movie WHERE production_company IS NULL; --  null value


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
SELECT Year , COUNT(title) as number_of_movies FROM movie group by year;
-- Movies have decreased in quantity from 2017 to a little bit in 2018 and a huge drop in 2019 


SELECT MONTH(date_published) AS month_num , COUNT(title) AS number_of_movies
	FROM movie
	GROUP BY month_num
	ORDER BY number_of_movies;

-- The general trend is that during the middle of the year and the end the number of movies is the lowest .. highest is in march






/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(title) AS movies_num 
	FROM movie
	WHERE (year ='2019') AND (country LIKE '%India%' OR country LIKE '%USA%'  ); -- 1059  (only india and USA 887) 







/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT(genre) from genre;









/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT COUNT(movie.id) as number_of_movies,genre 
	FROM genre 
	INNER JOIN movie on movie.id = genre.movie_id
	GROUP BY genre ;
-- DRAMA has the highest number


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH one_genre_movies as 
	(
	SELECT movie_id, count(movie_id)  AS genre_count
		FROM genre
		GROUP BY movie_id
		HAVING count(genre)=1
	)
    SELECT COUNT(*) FROM one_genre_movies;







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
SELECT genre,AVG(duration) as avg_duration 
	FROM genre 
	INNER JOIN movie on movie.id = genre.movie_id
	GROUP BY genre
    ORDER BY avg_duration DESC;

-- highest ACTION






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

SELECT 
	genre,
	COUNT(movie.id) as movie_count,
	RANK() OVER(ORDER BY COUNT(movie.id) DESC) as Ranking
	FROM genre 
	INNER JOIN movie on movie.id = genre.movie_id
	GROUP BY genre ;








/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT 
	MIN(avg_rating) as min_avg_rating,
    MAX(avg_rating) as max_avg_rating,
    MIN(total_votes) as min_total_votes,
    MAX(total_votes) as max_total_votes,
    MIN(median_rating) as min_median_rating,
	MAX(median_rating) as min_median_rating
    FROM ratings;




    

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
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT 
	title,
	avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) as movie_rank
    FROM movie
    INNER JOIN ratings ON
    movie.id = ratings.movie_id
    LIMIT 10;







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

SELECT
	median_rating,
    count(movie.id) as movie_count
    FROM movie
    INNER JOIN ratings ON
    movie.id = ratings.movie_id
    GROUP BY median_rating
    ORDER BY movie_count DESC
    ;



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

SELECT 
	production_company,
    COUNT(m.id) as movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as prod_company_rank
    FROM movie as m
    INNER JOIN ratings as r
    on m.id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY production_company;


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
SELECT
	genre,
    COUNT(m.id) AS movie_count
    FROM genre AS g
    INNER JOIN movie AS m ON
    g.movie_id = m.id
    INNER JOIN ratings AS r ON
    m.id = r.movie_id
    WHERE (MONTH(m.date_published) =3 ) and (total_votes > 1000)
    GROUP BY genre
    ORDER BY movie_count DESC;








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

SELECT 
	title,
    avg_rating,
    genre
    FROM genre AS g
    INNER JOIN movie AS m ON
    g.movie_id = m.id
    INNER JOIN ratings AS r ON
    m.id = r.movie_id
    WHERE (avg_rating > 8) AND (title LIKE 'The%');







-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	COUNT(id) as num_of_movies,
    median_rating 
    FROM ratings AS r
    INNER JOIN movie AS m ON
    r.movie_id = m.id
    WHERE (median_rating =8) and (date_published BETWEEN '2018-04-01' AND '2019-04-01' );


-- 361



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


SELECT 
	country,
    SUM(total_votes) AS votes_count_per_country
	FROM movie AS m
	INNER JOIN ratings AS r ON
	r.movie_id = m.id
	WHERE country ='germany' OR country ='italy'
	GROUP BY country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT 
	SUM(CASE WHEN name is null THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height is null THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth is null THEN 1 ELSE 0  END) AS date_of_birth_nulls,
	SUM(CASE WHEN known_for_movies is null THEN 1 ELSE 0  END) AS known_for_movies_nulls 
    FROM names;







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
WITH top_3_genre
	AS
    (
		SELECT 
			genre,
			COUNT(g.movie_id) as movie_count
			FROM genre g
			INNER JOIN ratings r
			ON g.movie_id = r.movie_id
			WHERE avg_rating > 8
			GROUP BY genre
			ORDER BY movie_count DESC
			LIMIT 3 -- this is to get the top 3 genres
	)
		SELECT
				n.name as director_name,
				COUNT(d.movie_id) as movie_count
				FROM names n
				INNER JOIN director_mapping d
				ON n.id = d.name_id
				INNER JOIN ratings r
				ON r.movie_id = d.movie_id
				INNER JOIN genre g
				ON g.movie_id = d.movie_id,
				top_3_genre
				WHERE r.avg_rating > 8 AND g.genre IN (top_3_genre.genre)
				GROUP BY n.name
				ORDER BY movie_count DESC
                LIMIT 3;
        
	
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
SELECT
	DISTINCT category
    FROM role_mapping;

SELECT	
	n.name AS actor_name,
    COUNT(rm.movie_id) AS movie_count
    FROM role_mapping rm 
    INNER JOIN names n
    ON n.id = rm.name_id
    INNER JOIN ratings as r
    ON r.movie_id = rm.movie_id
    WHERE (category ='actor') AND (r.median_rating >= 8)
    GROUP BY n.name
    ORDER BY movie_count DESC
    LIMIT 2;
    





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

SELECT 
	production_company,
    SUM(total_votes) AS vote_count, 
    RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
    FROM movie m
    INNER JOIN ratings r 
    ON m.id = r.movie_id
    GROUP BY production_company
    ORDER BY vote_count DESC
    LIMIT 3;








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

SELECT
	n.name AS actor_name,
    r.total_votes AS total_votes,
    COUNT(r.movie_id) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) /SUM(total_votes),2) AS actor_avg_rating,
    RANK() OVER(ORDER BY  ROUND(SUM(avg_rating * total_votes) /SUM(total_votes),2) DESC ) AS actor_rank
    FROM names n
    INNER JOIN role_mapping rm
    ON n.id = rm.name_id
    INNER JOIN movie m 
    ON rm.movie_id = m.id
    INNER JOIN ratings r
    ON r.movie_id = rm.movie_id
    WHERE rm.category = 'actor' AND m.country ='India'
    GROUP BY n.name
    HAVING COUNT(r.movie_id) >= 5;
-- THE logic behind the weighted average is basically an arthimetic in a aggreation sum(weight * votes)/sum(votes)


SELECT * FROM ratings;



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
SELECT
	n.name AS actor_name,
    r.total_votes AS total_votes,
    COUNT(m.id) AS movie_count,
    ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actoress_avg_rating,
    RANK() OVER(ORDER BY  ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC ) AS actor_rank
    FROM names n
    INNER JOIN role_mapping rm
    ON n.id = rm.name_id
    INNER JOIN movie m 
    ON rm.movie_id = m.id
    INNER JOIN ratings r
    ON r.movie_id = rm.movie_id
    WHERE rm.category = 'actress' AND m.country ='India'and m.languages LIKE '%Hindi%'
    GROUP BY n.name
    HAVING COUNT(r.movie_id) >= 3
    LIMIT 5;








/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT title,r.avg_rating,
	CASE 
		WHEN avg_rating > 8 THEN 'Superhit movies'
		WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
		WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
		WHEN avg_rating < 5 THEN 'Flop movies'
	END AS avg_rating_category
FROM movie AS m
INNER JOIN genre AS g
ON m.id=g.movie_id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE genre='thriller'
ORDER BY r.avg_rating DESC;



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

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

SELECT 
	genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(AVG(duration)) OVER(ORDER BY genre) AS running_total_duration,
    AVG(AVG(duration)) OVER(ORDER BY genre) AS moving_avg_duration
    FROM movie AS m
    INNER JOIN genre AS g
    on m.id=g.movie_id
    GROUP BY genre
    ORDER BY genre
  ;
    


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
WITH top_3_genres
AS
	(
    SELECT 
		genre,
        COUNT(movie_id) as movie_count
        FROM genre
        GROUP BY genre
        ORDER BY movie_count DESC
        LIMIT 3
    ),
top_5_movies
AS
	(
    SELECT 
		genre,
        year,
        title as movie_name,
        worlwide_gross_income,
        DENSE_RANK() OVER (PARTITION BY year ORDER BY worlwide_gross_income DESC) as movie_rank
        FROM movie as m
        INNER JOIN genre as g
        ON m.id = g.movie_id 
        WHERE genre IN (SELECT genre FROM top_3_genres) 
    )
SELECT * FROM top_5_movies WHERE movie_rank <=5;








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
SELECT 
	production_company,
    COUNT(id) AS movie_count,
    RANK() OVER(ORDER BY count(id) DESC) as prod_comp_rank
    FROM movie AS m
    INNER JOIN ratings AS r
    ON m.id = r.movie_id
    WHERE median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages) > 0
    GROUP BY production_company
    LIMIT 2;




-- star cinema and 20th century FOX

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

SELECT 
	name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    avg_rating,
    RANK() OVER (ORDER BY avg_rating DESC) AS actress_rank
    FROM names AS n
	INNER JOIN role_mapping AS rm
	ON n.id = rm.name_id
	INNER JOIN ratings AS r
	ON r.movie_id = rm.movie_id
	INNER JOIN genre AS g
	ON r.movie_id = g.movie_id
	WHERE category = 'actress' AND avg_rating > 8 AND genre = 'drama'
	GROUP BY name
LIMIT 3;






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

WITH movie_date_info AS
(
SELECT 
	d.name_id,
    name,
    d.movie_id,
	m.date_published, 
	LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
    FROM director_mapping d
	JOIN names AS n 
	ON d.name_id=n.id 
	JOIN movie AS m 
	ON d.movie_id=m.id
),

date_diff AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_info
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_diff
	 GROUP BY name_id
 )
 SELECT d.name_id AS director_id,
	name AS director_name,
	COUNT(d.movie_id) AS number_of_movies,
	ROUND(avg_inter_movie_days) AS avg_inter_movie_days,
	ROUND(AVG(avg_rating),2) AS avg_rating,
	SUM(total_votes) AS total_votes,
	MIN(avg_rating) AS min_rating,
	MAX(avg_rating) AS max_rating,
	SUM(duration) AS total_duration,
	ROW_NUMBER() OVER(ORDER BY COUNT(d.movie_id) DESC) AS director_rank
	FROM
	names AS n 
	JOIN director_mapping AS d 
	ON n.id=d.name_id
	JOIN ratings AS r 
	ON d.movie_id=r.movie_id
	JOIN movie AS m 
	ON m.id=r.movie_id
	JOIN avg_inter_days AS a 
	ON a.name_id=d.name_id
	GROUP BY director_id
	LIMIT 9; 







