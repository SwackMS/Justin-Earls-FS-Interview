PYTHON 3.11
DJANGO 4.1.3

Package                  Version
------------------------ ----------
asgiref                  3.5.2
cachetools               4.2.4
certifi                  2022.9.24
charset-normalizer       2.1.1
distlib                  0.3.6
Django                   4.1.3
filelock                 3.8.0
google-api-core          1.33.2
google-api-python-client 2.66.0
google-auth              1.35.0
google-auth-httplib2     0.1.0
google-cloud             0.34.0
google-cloud-bigquery    2.6.1
google-cloud-core        2.3.2
google-cloud-storage     2.6.0
google-crc32c            1.5.0
google-resumable-media   2.4.0
googleapis-common-protos 1.57.0
grpcio                   1.50.0
grpcio-status            1.48.2
httplib2                 0.21.0
idna                     3.4
pip                      22.3.1
pipenv                   2022.11.11
platformdirs             2.5.4
proto-plus               1.22.1
protobuf                 3.20.3
pyasn1                   0.4.8
pyasn1-modules           0.2.8
pyparsing                3.0.9
pytz                     2022.6
requests                 2.28.1
rsa                      4.9
setuptools               65.5.0
six                      1.16.0
sqlparse                 0.4.3
tzdata                   2022.6
uritemplate              4.1.1
urllib3                  1.26.12
virtualenv               20.16.7
virtualenv-clone         0.5.7

JSON File has been included for Google Service Account, required for Google Cloud BigQuery.

Google has informed me that publishing my own service account JSON file is bad practice, so I have disabled it and removed the file. Please insert your own JSON for Google BigQuery into the root folder of the program.

# Earls Technical Assignment

Please download this repository and import all the contents into a new repository. Ensure that it has "Public" visibility to be shared with us.

Feel free to use any online resources available to help solve this assignment. Once you have completed the assignment, submit it by sharing your repository link with us.

There are two parts to this assignment:
1. Build a Django application to display data from a BigQuery public dataset. You will need to compile two queries and create separate views to display the requested dataset.
2. Based on an ERD, compile queries to solve three questions.


## Part 1: Django BigQuery Application

1. Set up the Django web framework with the `google-cloud-bigquery` client library from pip. Use the skeleton code in `bigquery_sample/` as your foundation.
2. Verify that the application can run on localhost.
3. Using the function `hacker_news` found in `views.py`, create a view accessible by users via this url [localhost:8080/latest_hacker_news](localhost:8080/latest_hacker_news). The view should return the following results:
    - Displays the title, author's name, and date of publication of the latest 5 articles from the `stories` table . The dataset can be obtained from the public dataset `hacker_news` (`bigquery-public-data.hacker_news.stories`).

NOTE1: Can use either time_ts or time to determine order for sorting stories
NOTE2: Asks for date, time left in to demonstrate correct order, easily removed with 'EXTRACT(DATE, time_ts) as date'


4. Using the function `github` found in `views.py`, create a view accessible by users via this url [localhost:8080/most_commits](localhost:8080/most_commits). The view should return the following results:
    - Displays the individuals with the most commits from the `sample_commits` table in 2016. Display the name and number of commits sorted from most to least commits. The dataset can be obtained from the public dataset `github_repos` (`bigquery-public-data.github_repos.sample_commits`).
5. If applicable, compile a README for the project.

___

## Part 2: SQL Questions

Use the following ERD to answer the next set of questions. Please record your answers in the `SQL_answers.sql` file.

![Sales ERD](Sales_ERD.jpeg)

NOTE: Microsoft T-SQL used

1. Based on the ERD provided, write a SQL query to find the number of occurrences that an ingredient named “Lobster Ravioli” was sold at each store. Rank the stores by dishes sold with the highest occurrence first.

SELECT   COUNT(ing.ingredient_name) LobsterRavioliSold,
         sto.store_id
FROM     Sales sal
INNER    JOIN Ingredient ing
INNER    JOIN Store sto
WHERE    ing.ingredient_name = 'Lobster Ravioli'
GROUP BY sto.store_id
ORDER BY sto.store_id DESC

2. Revise the query from Question #1 to limit the dataset queried between April 1st, 2021 to May 1st, 2021. Return only the stores that have sold more than 45 Lobster Ravioli dishes.

WITH CTE (LobsterRavioliSold, store_id)
AS
(
    SELECT   COUNT(ing.ingredient_name) LobsterRavioliSold,
             sto.store_id
    FROM     Sales sal
    INNER    JOIN Ingredient ing
    INNER    JOIN Store sto
    WHERE    ing.ingredient_name = 'Lobster Ravioli'
    AND      (sal.business_date >= '2021/04/01'
             AND sal.business_date <= '2021/05/01')
    GROUP BY sto.store_id
)
SELECT *
FROM   CTE
WHERE  LobsterRavioliSold > 45
ORDER BY sto.store_id DESC

 

3. Referencing the Sales table, write the corresponding `CREATE` SQL DDL statement. Include and provide justification for any improvements or add-ons as you see fit.

CREATE TABLE dbo.Sales (
    sale_id INT PRIMARY KEY CLUSTERED,
    store_id INT FOREIGN KEY,
    business_date DATE DEFAULT GETDATE() NOT NULL,
    ingredient_id INT FOREIGN KEY,
    sold_price FLOAT NOT NULL
);