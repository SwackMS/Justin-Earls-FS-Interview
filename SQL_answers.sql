-- NOTE: Microsoft T-SQL used

-- Question #1
-- Based on the ERD provided, write a SQL query to find the number of occurrences that an ingredient named “Lobster Ravioli” was sold at each store. Rank the stores by dishes sold with the highest occurrence first.
SELECT   COUNT(ing.ingredient_name) LobsterRavioliSold,
         sto.store_id
FROM     Sales sal
INNER    JOIN Ingredient ing
INNER    JOIN Store sto
WHERE    ing.ingredient_name = 'Lobster Ravioli'
GROUP BY sto.store_id
ORDER BY sto.store_id DESC

-- Question #2
-- Revise the query from Question #1 to limit the dataset queried between April 1st, 2021 to May 1st, 2021. Return only the stores that have sold more than 45 Lobster Ravioli dishes.
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

-- Question #3
-- Referencing the Sales table, write the corresponding `CREATE` SQL DDL statement. Include and provide justification for any improvements or add-ons as you see fit.
CREATE TABLE dbo.Sales (
    sale_id INT PRIMARY KEY CLUSTERED,
    store_id INT FOREIGN KEY,
    business_date DATE DEFAULT GETDATE() NOT NULL,
    ingredient_id INT FOREIGN KEY,
    sold_price FLOAT NOT NULL
);