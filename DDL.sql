
-- Original code, authored by: Lily Kim and Chanda Decker, Group 47, Amplitude Music
-- CS340 Project Step 3 Draft 
-- SQL file contains DDL and Populates all database tables with sample data.
-- Date last modified: 05/08/2024

-- Disable default foreign key checks and keep single SQL transaction open.
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;

-- Set up table framework for 7 tables.
CREATE OR REPLACE TABLE Customers (
    id_customer int AUTO_INCREMENT NOT NULL UNIQUE,
    cust_fname varchar(15) NOT NULL,
    cust_lname varchar(15) NOT NULL,
    cust_email varchar(30) NOT NULL,
    cust_birthday date,
    cust_established datetime NOT NULL,
    total_expenditures decimal(8,2) default 0.00,
    PRIMARY KEY (id_customer),
    CONSTRAINT customer_details UNIQUE (cust_fname, cust_lname, cust_email)
);

CREATE OR REPLACE TABLE Discount_Codes (
    id_discount_code int(3) AUTO_INCREMENT NOT NULL UNIQUE,
    discount_percent decimal(3,2),
    discount_description varchar(30),
    PRIMARY KEY (id_discount_code),
    CONSTRAINT discount_details UNIQUE (discount_percent, discount_description)
);

CREATE OR REPLACE TABLE Song_Titles (
    id_title int AUTO_INCREMENT NOT NULL UNIQUE,
    song_title varchar(30) NOT NULL,
    PRIMARY KEY (id_title)
);

CREATE OR REPLACE TABLE Artists (
    id_artist int AUTO_INCREMENT NOT NULL UNIQUE,
    artist_name varchar(30) NOT NULL,
    PRIMARY KEY (id_artist)
);

CREATE OR REPLACE TABLE Albums (
    id_album int AUTO_INCREMENT NOT NULL UNIQUE,
    album_title varchar(50) NOT NULL,
    album_year varchar(4) NOT NULL,
    PRIMARY KEY (id_album),
    CONSTRAINT album_details UNIQUE (album_title, album_year)
);

CREATE OR REPLACE TABLE Songs (
    id_song int AUTO_INCREMENT NOT NULL UNIQUE,
    title int,
    artist int,
    album int,
    song_price decimal(6,2) NOT NULL,
    CONSTRAINT FOREIGN KEY (title)
    REFERENCES Song_Titles(id_title) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (artist)
    REFERENCES Artists(id_artist) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (album)
    REFERENCES Albums(id_album) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_song),
    CONSTRAINT song_details UNIQUE (title, artist, album)
);

CREATE OR REPLACE TABLE Customers_Songs_Sales (
    id_sale bigint AUTO_INCREMENT NOT NULL UNIQUE,
    customer int,
    song int,
    discount int,
    sale_completed datetime NOT NULL,
    sale_expenditure decimal(6,2) NOT NULL,
    CONSTRAINT FOREIGN KEY (customer)
    REFERENCES Customers(id_customer) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (song)
    REFERENCES Songs(id_song) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (discount)
    REFERENCES Discount_Codes(id_discount_code) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (id_sale),
    CONSTRAINT sale_details UNIQUE (customer, song, sale_completed)
);

-- Populate 7 tables with sample data.
INSERT INTO Customers (cust_fname, cust_lname, cust_email, cust_birthday, cust_established) 
VALUES ( 'Zuri', 'Jefferson', 'zurijefferson@gmail.com', 20000522, 20241001121733),
('Joaquin', 'Ruiz', 'joaquin@ruizsports.com', 19850413, 20241003174409),
('Benjamin', 'Ackler', 'benjaiminackler@yahoo.com', 19941018, 20241002205505),
('Dae', 'Lee', 'daelee@gmail.com', 20060905, 20241024223052),
('Adria', 'Belov', 'belovadr@oregonstate.edu', NULL, 20241127102024);

INSERT INTO Discount_Codes (discount_percent, discount_description)
VALUES ( 0.20, 'Christmas sale'),
 (0.25, 'Black Friday'),
 (0.15, 'New Album Release'),
 (0.12, 'Mix number 3'),
 (0.05, 'Special Promo');
 
INSERT INTO Song_Titles (song_title)
VALUES ('Down Bad'),
('Training Season'),
('Cruel Summer'),
('Feel Good Inc.'),
('Fortnight');																																																																																																													   

INSERT INTO Artists (artist_name)
VALUES ('Taylor Swift'),
('Dua Lipa'),
('Gorillaz'),
('Bruno Mars'),
('Miley Cirus');																																																																																															   

INSERT INTO Albums (album_title, album_year)
VALUES ('The Tortured Poets Department: The Anthology', '2024'),
('Radical Optimism', '2024'),
('Demon Days', '2015'),
('Emotion', '2015'),
('Lover', '2019');																																																																																																																																										

INSERT INTO Songs (title, artist, album, song_price)
VALUES ((SELECT id_title FROM Song_Titles WHERE song_title = 'Down Bad'),
(SELECT id_artist FROM Artists WHERE artist_name = 'Taylor Swift'),
(SELECT id_album FROM Albums WHERE album_title = 'The Tortured Poets Department: The Anthology' and album_year = '2024'),
2.00),
((SELECT id_title FROM Song_Titles WHERE song_title = 'Training Season'),
(SELECT id_artist FROM Artists WHERE artist_name = 'Dua Lipa'),
(SELECT id_album FROM Albums WHERE album_title = 'Radical Optimism' and album_year = '2024'),
2.00),
((SELECT id_title FROM Song_Titles WHERE song_title = 'Cruel Summer'),
(SELECT id_artist FROM Artists WHERE artist_name = 'Taylor Swift'),
(SELECT id_album FROM Albums WHERE album_title = 'Lover' and album_year = '2019'),
1.70),
((SELECT id_title FROM Song_Titles WHERE song_title = 'Feel Good Inc.'),
(SELECT id_artist FROM Artists WHERE artist_name = 'Gorillaz'),
(SELECT id_album FROM Albums WHERE album_title = 'Demon Days' and album_year = '2015'),
0.85),
((SELECT id_title FROM Song_Titles WHERE song_title = 'Fortnight'),
(SELECT id_artist FROM Artists WHERE artist_name = 'Taylor Swift'),
(SELECT id_album FROM Albums WHERE album_title = 'The Tortured Poets Department: The Anthology' and album_year = '2024'),
2.00);

INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (2, 1, 3, 20241205000917, ((SELECT song_price FROM Songs WHERE id_song = 1) * (1-(SELECT discount_percent FROM Discount_Codes WHERE id_discount_code = 3))));
UPDATE Customers 
SET total_expenditures = total_expenditures + (SELECT sale_expenditure FROM Customers_Songs_Sales WHERE id_sale = 1)
WHERE id_customer = 2;

INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (2, 4, 2, 20241117000811, ((SELECT song_price FROM Songs WHERE id_song = 4) * (1-(SELECT discount_percent FROM Discount_Codes WHERE id_discount_code = 2))));
UPDATE Customers 
SET total_expenditures = total_expenditures + (SELECT sale_expenditure FROM Customers_Songs_Sales WHERE id_sale = 2)
WHERE id_customer = 2;

INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (5, 2, 5, 20240523000305, ((SELECT song_price FROM Songs WHERE id_song = 2) * (1-(SELECT discount_percent FROM Discount_Codes WHERE id_discount_code = 5))));
UPDATE Customers 
SET total_expenditures = total_expenditures + (SELECT sale_expenditure FROM Customers_Songs_Sales WHERE id_sale = 3)
WHERE id_customer = 5;

INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (1, 5, 3, 20240813000920, ((SELECT song_price FROM Songs WHERE id_song = 5) * (1-(SELECT discount_percent FROM Discount_Codes WHERE id_discount_code = 3))));
UPDATE Customers 
SET total_expenditures = (total_expenditures + (SELECT sale_expenditure FROM Customers_Songs_Sales WHERE id_sale = 4))
WHERE id_customer = 1;

INSERT INTO Customers_Songs_Sales (customer, song, discount, sale_completed, sale_expenditure)
VALUES (3, 5, 3, 20240608000917, ((SELECT song_price FROM Songs WHERE id_song = 5) * (1-(SELECT discount_percent FROM Discount_Codes WHERE id_discount_code = 3))));
UPDATE Customers 
SET total_expenditures = (total_expenditures + (SELECT sale_expenditure FROM Customers_Songs_Sales WHERE id_sale = 5))
WHERE id_customer = 3;

-- Enable foreign key checks and commit transaction.
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;


-- View table setups and inserted data.
DESCRIBE Customers;
DESCRIBE Song_Titles;
DESCRIBE Artists;
DESCRIBE Albums;
DESCRIBE Discount_Codes;
DESCRIBE Songs;
DESCRIBE Customers_Songs_Sales;

SELECT * FROM Customers;
SELECT * FROM Song_Titles;
SELECT * FROM Artists;
SELECT * FROM Albums;
SELECT * FROM Discount_Codes;
SELECT * FROM Songs;
SELECT * FROM Customers_Songs_Sales;
