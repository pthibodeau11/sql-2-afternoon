-- PRACTICE JOINS

-- #1

SELECT * 
FROM invoice
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
WHERE invoice_line.unit_price > .99;

-- #2

SELECT invoice_date, first_name, last_name, total
FROM invoice
JOIN customer ON invoice.customer_id = customer.customer_id

-- #3

SELECT customer.first_name, customer.last_name, employee.first_name, employee.last_name
FROM customer
JOIN employee ON customer.support_rep_id = employee.employee_id

-- #4

SELECT album.title, artist.name
FROM album
JOIN artist ON artist.artist_id = album.album_id

-- #5

SELECT playlist_track.track_id
FROM playlist_track
JOIN playlist ON playlist_track.playlist_id = playlist.playlist_id
WHERE playlist.name = 'Music'

-- #6

SELECT track.name
FROM track
JOIN playlist_track ON playlist_track.track_id = track.track_id
WHERE playlist_track.playlist_id = 5

-- #7

SELECT track.name, playlist.name
FROM track
JOIN playlist_track ON playlist_track.track_id = track.track_id
JOIN playlist ON playlist.playlist_id = playlist_track.playlist_id

-- #8
SELECT track.name, album.title
FROM track
JOIN album ON track.album_id = album.album_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name = 'Alternative & Punk'


-- Nested queries practice 

-- #1
SELECT * 
FROM invoice
WHERE invoice_id IN (SELECT invoice_id FROM invoice_line WHERE unit_price > .99)

-- #2
SELECT * 
FROM playlist_track
WHERE playlist_id IN (SELECT playlist_id FROM playlist WHERE name = 'Music')

-- #3
SELECT name 
FROM track
WHERE track_id IN (SELECT track_id FROM playlist_track WHERE playlist_id = 5)

-- #4
SELECT *
FROM track
WHERE genre_id IN (SELECT genre_id FROM genre WHERE name = 'Comedy')

-- #5
SELECT *
FROM track
WHERE album_id IN (SELECT album_id FROM album WHERE title = 'Fireball')

-- #6
SELECT *
FROM track
WHERE album_id IN 
(SELECT album_id FROM album WHERE artist_id IN 
(SELECT artist_id from artist WHERE name = 'Queen'))


-- Updating rows practice

-- #1
UPDATE customer
SET fax = null
WHERE fax IS NOT NULL

-- #2
UPDATE customer
SET company = 'Self'
WHERE company IS NULL

-- #3
UPDATE customer
SET last_name = 'Thompson'
WHERE first_name = 'Julia' AND last_name = 'Barnett'

-- #4
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'

-- #5
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id IN 
(SELECT genre_id FROM genre WHERE name = 'Metal')
AND composer IS NULL


-- Group by practice

-- #1
SELECT COUNT(track_id), genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name

-- #2
SELECT COUNT(track_id), genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name = 'Pop' OR genre.name = 'Rock'
GROUP BY genre.name

-- #3
SELECT artist.name, COUNT(album.title)
FROM album
JOIN artist ON artist.artist_id = album.album_id
GROUP BY artist.name

-- Use distinct practice

-- #1
SELECT DISTINCT composer
FROM track

-- #2
SELECT DISTINCT billing_postal_code
FROM invoice

-- #3
SELECT DISTINCT company
FROM customer

-- Delete rows practice

-- #1
CREATE TABLE practice_delete ( name TEXT, type TEXT, value INTEGER );
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);

SELECT * FROM practice_delete;

-- #2
DELETE FROM practice_delete
WHERE type = 'bronze';

-- #3
DELETE FROM practice_delete
WHERE type = 'silver';

-- #4
DELETE FROM practice_delete
WHERE value = 150;


-- E-commerce website

-- #1 Creating 3 tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
)

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    price INTEGER NOT NULL
)

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    user_id INTEGER REFERENCES users(user_id)
)

-- #2 adding some data

INSERT INTO users
(user_name, email)
VALUES
('Pat', 'pat@gmail.com'),
('Jess', 'jess@gmail.com'),
('June', 'june@gmail.com')

INSERT INTO products
(product_name, price)
VALUES
('shirt', 9.99),
('hat', 4.99),
('shoes', 19.99)

INSERT INTO orders
(product_id, user_id)
VALUES
(1, 2),
(2, 2),
(3, 3)

-- #3 run queries against data

-- -- get all products for first order
SELECT products.product_name
FROM products
JOIN orders ON products.product_id = orders.product_id
WHERE orders.order_id = 1

-- -- get all orders
SELECT * FROM orders

-- -- get the total cost of an order (sum price of all products on an order)
SELECT SUM(products.price)
FROM products
JOIN orders ON products.product_id = orders.product_id
WHERE orders.order_id = 2


-- #4 Add a foreign key reference from orders to users
-- #5 Update orders table to link a user to each order

-- added below to orders table
product_id INTEGER NOT NULL REFERENCES products(product_id),
user_id INTEGER REFERENCES users(user_id)

-- #6 Run queries against data

-- -- get all orders for user
SELECT * FROM orders
WHERE user_id = 2


-- -- get how many orders each user has
SELECT COUNT(order_id) FROM orders
GROUP BY user_id
