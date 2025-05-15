USE HEXAWARE_FSD;

CREATE TABLE BOOK(bid INT auto_increment PRIMARY KEY , 
	btitle varchar(50) NOT NULL, 
    bprice decimal(10,2) NOT NULL , 
    bauthor varchar(100) NOT NULL , 
    publication_house ENUM('Mcgraw Hill', 'DreamFolks', 'Warner Bros') NOT NULL,
    category ENUM('FICTION', 'WAR', 'COMEDY', 'SPORTS') NOT NULL,
    book_count INT NOT NULL,
    b_status ENUM('IN STOCK', 'OUT_OF_STOCK') NOT NULL);
    
INSERT INTO BOOK (btitle, bprice, bauthor, publication_house, category, book_count, b_status) VALUES
('The Silent War', 499.99, 'John Keegan', 'Warner Bros', 'WAR', 12, 'IN STOCK'),
('Laugh Out Loud', 299.50, 'Ellen Lee', 'DreamFolks', 'COMEDY', 8, 'IN STOCK'),
('Dream Beyond', 399.00, 'Samuel Harris', 'DreamFolks', 'FICTION', 0, 'OUT_OF_STOCK'),
('Battlefront', 559.25, 'Rick Thompson', 'Mcgraw Hill', 'WAR', 3, 'IN STOCK'),
('Game On!', 349.75, 'Chris Nolan', 'Warner Bros', 'SPORTS', 10, 'IN STOCK'),
('Funny Bones', 199.99, 'Maya Angelou', 'DreamFolks', 'COMEDY', 0, 'OUT_OF_STOCK'),
('Fields of Glory', 425.00, 'Tom Brokaw', 'Mcgraw Hill', 'WAR', 5, 'IN STOCK'),
('Run to Win', 379.99, 'Lisa Runner', 'Warner Bros', 'SPORTS', 6, 'IN STOCK'),
('Tales of Imagination', 289.00, 'Ava Blake', 'DreamFolks', 'FICTION', 7, 'IN STOCK'),
('The Comedy Club', 249.50, 'Kevin Hart', 'DreamFolks', 'COMEDY', 2, 'IN STOCK'),
('Mind Games', 475.20, 'Sophie Green', 'Mcgraw Hill', 'FICTION', 9, 'IN STOCK'),
('Warrior Code', 599.00, 'James Clavell', 'Warner Bros', 'WAR', 4, 'IN STOCK'),
('Laughter Lane', 215.30, 'Nina West', 'DreamFolks', 'COMEDY', 0, 'OUT_OF_STOCK'),
('The Final Play', 305.75, 'Tom Brady', 'Mcgraw Hill', 'SPORTS', 11, 'IN STOCK'),
('Echoes of the Past', 389.99, 'Emma Frost', 'Mcgraw Hill', 'FICTION', 3, 'IN STOCK'),
('Strike Hard', 509.49, 'Robert Gates', 'Warner Bros', 'WAR', 0, 'OUT_OF_STOCK'),
('Whistle and Win', 330.00, 'Alex Morgan', 'DreamFolks', 'SPORTS', 5, 'IN STOCK'),
('Storyteller', 412.60, 'Neil Gaiman', 'Mcgraw Hill', 'FICTION', 6, 'IN STOCK'),
('Match Point', 350.00, 'Serena Sparks', 'Warner Bros', 'SPORTS', 8, 'IN STOCK'),
('Comedy Central', 275.25, 'Dave Chappelle', 'DreamFolks', 'COMEDY', 1, 'IN STOCK');

SELECT * FROM Book;

/* PROCEDURE 1: Fetch all Books that are "IN STOCK" and price is less than given value. */

DELIMITER $$

CREATE PROCEDURE proc_books_instock_below_price(IN p_price DECIMAL(10,2))
BEGIN
    SELECT * FROM BOOK
    WHERE b_status = 'IN STOCK' AND bprice < p_price;
END;

CALL proc_books_instock_below_price(400.00);
CALL proc_books_instock_below_price(250.00);

/* PROCEDURE 2: Delete books that are from given publication house. do not activate safe mode. */

DELIMITER $$

CREATE PROCEDURE proc_delete_books_by_publication(IN p_publication_house VARCHAR(100))
BEGIN
    DELETE FROM BOOK
    WHERE bid IN (
        SELECT bid FROM (
            SELECT bid FROM BOOK WHERE publication_house = p_publication_house
        ) AS safe_subquery
    );
END;

CALL proc_delete_books_by_publication("Warner Bros");

/* PROCEDURE 3: Update the price of books by given percent based on given category. do not activate safe mode. */

DELIMITER $$
CREATE PROCEDURE proc_update_price_by_category(
		IN p_category varchar(100),
        IN p_percentage double)
BEGIN
	UPDATE Book
    SET bprice = bprice + (bprice * (p_percentage / 100))
    WHERE bid IN (SELECT bid FROM (SELECT bid FROM Book WHERE category = p_category) AS subquery);
    SELECT * FROM Book WHERE category = p_category;
END;

CALL proc_update_price_by_category('FICTION' , 10);
