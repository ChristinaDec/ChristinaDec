-- Original code, authored by: Lily Kim and Chanda Decker, Group 47, Amplitude Music
-- CS340 Project Step 3 Draft 
-- SQL file contains DML - Create and retrieve for all tables and update and delete for intersection table.
-- Date last modified: 05/08/2024


-- Query Customers table for all rows for the Browse Customers Page.
SELECT id_customer, cust_fname, csut_lname, cust_email, cust_birthday, cust_established, total_expenditure
FROM Customers;

-- Add a new row to the Customers table.
INSERT INTO Customers (cust_fname, cust_lname, cust_email, cust_birthday, cust_established, total_expenditure)
VALUES (:cust_fnameInput, :cust_lnameInput, :cust_emailInput, :custbirthdayInput, :cust_eestablishedInput, :total_expenditureInput);



-- Query Discount_Codes table for all rows for the Browse Discount_Codes Page.
SELECT id_discount_code, discount_percent, discount_description
FROM Discount_Codes;

-- Add a new row to the Discount_Codes table.
INSERT INTO Discount_Codes (discount_percent, discount_description)
VALUES (:discount_percentInput, :discount_descriptionInput);



-- Query Song_Titles table for all rows for the Browse Song_Titles Page.
SELECT id_title, song_title
FROM Song_Titles;

-- Add a new row to the Song_Titles table.
INSERT INTO Song_Titles (song_title)
VALUES (:song_titleInput);




-- Query Artists for all rows for the Browse Artists Page.
SELECT id_artist, artist_name
FROM Artists; 

-- Add a new row to the Artists table.
INSERT INTO Artists (artist_name)
VALUES (:artist_nameInput);



--Query Albums for all rows for the Browse Albums Page.
SELECT id_album, album_title, album_year
FROM Albums;

-- Add a new row to the Albums table.
INSERT INTO Albums (album_title, album_year)
VALUES (:album_titleInput, :album_yearlenput);



-- Query Songs for all rows for the Browse Songs Page.
-- Abstract title, artist, and album to song_title, artist_name and album_title, respectively.
SELECT id_song, Song_Titles.song_title AS title, Artists.artist_name as artist, Albums.album_title as album, sale_price
FROM Songs
INNER JOIN Song_Titles ON title = Song_Titles.id_title
INNER JOIN Artists ON artist = Artists.id_artist
INNER JOIN Albums on album = Albums.id_album;

-- Add a new row to the Songs table using drop-down menus.

-- Query Song_Titles for rows for the id_title drop-down.
SELECT CONCAT(id_title,',', song_title) AS title
FROM Song_Titles;

-- Query Artists for rows for the id_artist drop-down.
SELECT CONCAT(id_artist,',', artist_name) AS artist
FROM Artists; 

-- Query Albums for rows for the id_album drop-down.
SELECT CONCAT(id_album,',', album_title,',',album_year) AS album
FROM Albums;

-- Add selections from drop-down menus (and text entry field) to Songs table as a new row.
INSERT INTO Songs (title, artist, album, sale_price)
VALUES (:title_dropdownInput, :artist_dropdownInput, :album_dropdownInput, :sale_priceInput);



-- Query Customers_Songs_Sales for all rows for the Browse Customers_Songs_Sales Page.
-- Abstract customer, song, and discount to cust_fname/cust_lname, title, and discount_percent.
SELECT id_sale, CONCAT(Customers.cust_fname,' ',Customers.cust_lname) AS customer, Song_Titles.song_title as title, Discount_Codes.discount_percent as discount, 
sale_completed, sale_expenditure
FROM Customers_Songs_Sales
INNER JOIN Customers ON Customers.id_customer
INNER JOIN Songs ON Song_Titles.id_title = Songs.id_song
INNER JOIN Song_Titles ON title = Song_Titles.id_title
INNER JOIN Discount_Codes ON discount = Discount_Codes.discount_percent;

-- Add a new row to Customers_Songs_Sales using drop-down menus (and text entry).

-- Query Customers for rows for the customers dropdown.
SELECT CONCAT(Customers.cust_fname,' ', Customers.cust_lname,' ', Customers.cust_email) AS customer
FROM Customers;

-- Query Songs for rows for the songs drop-down.
SELECT CONCAT(Song_Titles.song_title,' ', Artists.artist_name,' ', Albums.album_title) AS song
FROM Songs
INNER JOIN Song_Titles ON title = Song_Titles.id_title
INNER JOIN Artists ON artist = Artists.id_artist
INNER JOIN Albums on album = Albums.id_album;

-- Query Discount_Codes for rows for the discount drop-down.
SELECT CONCAT(Discount_Codes.discount_percent,' ', Discount_Codes.discount_description) AS discount
FROM Discount_Codes;

-- Add selections from drop-down menus (and text entry fields) to Customers_Songs_Sales table as a new row.
INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (:customer_dropdownInput, :song_dropdownInput, :discount_dropdownInput, :sale_completedInput, :sale_expenditureInput);

-- Delete a row from the Customers_Songs_Sales table.
DELETE FROM Customers_Songs_Sales 
WHERE id_sale = :id_saleSelected

-- Update a row from Customers_Songs_Sales table.

-- Query Customers_Songs_Sales for the single row selected for edit in the Customers_Songs_Sales table.
-- Abstract customer, song, and discount to cust_fname/cust_lname, title, and discount_percent.
SELECT id_sale, CONCAT(Customers.cust_fname,' ',Customers.cust_lname) AS customer, Song_Titles.song_title as title, Discount_Codes.discount_percent as discount,
sale_completed, sale_expenditure
FROM Customers_Songs_Sales
WHERE id_sale = id_salesSelected
INNER JOIN Customers ON Customers.id_customer
INNER JOIN Songs ON Song_Titles.id_title = Songs.id_song
INNER JOIN Song_Titles ON title = Song_Titles.id_title
INNER JOIN Discount_Codes ON discount = Discount_Codes.discount_percent;

-- Edit a row in the Customers_Songs_Sales using drop-down menus (and text entry).

-- Query Customers for rows for the customers dropdown.
SELECT CONCAT(Customers.cust_fname,' ', Customers.cust_lname,' ', Customers.cust_email) AS customer
FROM Customers;

-- Query Songs for rows for the songs drop-down.
SELECT CONCAT(Song_Titles.song_title,' ', Artists.artist_name,' ', Albums.album_title) AS song
FROM Songs
INNER JOIN Song_Titles ON title = Song_Titles.id_title
INNER JOIN Artists ON artist = Artists.id_artist
INNER JOIN Albums on album = Albums.id_album;

-- Query Discount_Codes for rows for the discount drop-down.
SELECT CONCAT(Discount_Codes.discount_percent,' ', Discount_Codes.discount_description) AS discount
FROM Discount_Codes;

-- Add selections from drop-down menus (and text entry fields) to Customers_Songs_Sales table as a new row.
UPDATE Customers_Songs_Sales
SET customer = :customer_dropdownInput, song = :song_dropdownInput, discount = :discount_dropdownInput, 
sale_completed = :sale_completedInput, sale_expenditure = :sale_expenditureInput
WHERE id_sale = id_salesSelected;
