CREATE TABLE products (
    index INT,
    name TEXT,
    description TEXT,
    brand TEXT,
    category TEXT,
    price NUMERIC,
    currency VARCHAR(3),
    stock INT,
    EAN NUMERIC,
    color VARCHAR(10),
    size TEXT,
    availability TEXT,
    internal_id INT
)
SELECT *
FROM products

ALTER TABLE products
ALTER COLUMN color TYPE TEXT
USING color::TEXT;




COPY products
FROM '/Users/macbook/Documents/Data_Analytics/SQL/SQL_projects_protfolio/products-10000.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');