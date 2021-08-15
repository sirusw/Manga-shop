DROP TABLE IF EXISTS review ;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS productinventory;
DROP TABLE IF EXISTS warehouse;
DROP TABLE IF EXISTS orderproduct;
DROP TABLE IF EXISTS incart;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS ordersummary;
DROP TABLE IF EXISTS paymentmethod; 
DROP TABLE IF EXISTS customer;


CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    admin               INT,
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(80),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);



INSERT INTO category(categoryName) VALUES ('Horror');
INSERT INTO category(categoryName) VALUES ('Romance');
INSERT INTO category(categoryName) VALUES ('Action');
INSERT INTO category(categoryName) VALUES ('Comedy');
INSERT INTO category(categoryName) VALUES ('Sci-fi');
INSERT INTO category(categoryName) VALUES ('Mystery');


INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Attack on Titan', 3, 'Attack on Titan',12.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Dragon Ball', 3, 'Dragon Ball',18.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Naruto', 3, 'Naruto',17.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Tokyo Ghoul', 1, 'Tokyo Ghoul',14.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Tomie', 1, 'Tomie',12.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Your Lie in April', 2, ' Your Lie in April ',21.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Nisekoi', 2, 'Nisekoi',19.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('My Youth Romantic Comedy Is Wrong As I Expected', 4, 'My Youth Romantic Comedy Is Wrong As I Expected', 16.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('One Punch Man', 4, 'One Punch Man',15.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Steins Gate', 5, 'Steins Gate',23.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Ghost in the Shell', 5, 'Ghost in the Shell',19.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Death Note', 6, 'Death Note',16.00);
INSERT INTO product(productName, categoryId, productDesc, productPrice) VALUES ('Pandora Hearts', 6, ' Pandora Hearts ',16.00);


INSERT INTO warehouse(warehouseName) VALUES ('The main warehouse');
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (1, 1, 5, 12);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (2, 1, 10, 18);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (3, 1, 3, 17);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (4, 1, 2, 14);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (5, 1, 6, 12);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (6, 1, 3, 21);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (7, 1, 1, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (8, 1, 0, 16);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (9, 1, 2, 15);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (10, 1, 13,23);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (11, 1, 6, 19);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (12, 1, 2, 16);
INSERT INTO productInventory(productId, warehouseId, quantity, price) VALUES (13, 1, 77, 16);

INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , 'test', 1);
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , 'bobby', 0);
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , 'password', 0);
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , 'pw', 0);
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password, admin) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , 'test', 0);

-- Order 1 can be shipped as have enough inventory
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (1, '2019-10-15 10:25:55', 91.70)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 1, 1, 18)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 2, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 10, 1, 31);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-16 18:00:00', 106.75)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 5, 21.35);

-- Order 3 cannot be shipped as do not have enough inventory for item 7
DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (3, '2019-10-15 3:30:22', 140)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 6, 2, 25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 7, 3, 30);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (2, '2019-10-17 05:45:11', 327.85)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 3, 4, 10)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 8, 3, 40)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 13, 3, 23.25)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 28, 2, 21.05)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 29, 4, 14);

DECLARE @orderId int
INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (5, '2019-10-15 10:25:55', 277.40)
SELECT @orderId = @@IDENTITY
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 5, 4, 21.35)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 19, 2, 81)
INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (@orderId, 20, 3, 10);

-- New SQL DDL for lab 8
UPDATE Product SET productImageURL = 'img/1.jpg' WHERE ProductId = 1;
UPDATE Product SET productImageURL = 'img/2.jpg' WHERE ProductId = 2;
UPDATE Product SET productImageURL = 'img/3.jpg' WHERE ProductId = 3;
UPDATE Product SET productImageURL = 'img/4.jpg' WHERE ProductId = 4;
UPDATE Product SET productImageURL = 'img/5.jpg' WHERE ProductId = 5;
UPDATE Product SET productImageURL = 'img/6.jpg' WHERE ProductId = 6;
UPDATE Product SET productImageURL = 'img/7.jpg' WHERE ProductId = 7;
UPDATE Product SET productImageURL = 'img/8.jpg' WHERE ProductId = 8;
UPDATE Product SET productImageURL = 'img/9.jpg' WHERE ProductId = 9;
UPDATE Product SET productImageURL = 'img/10.jpg' WHERE ProductId = 10;
UPDATE Product SET productImageURL = 'img/11.jpg' WHERE ProductId = 11;
UPDATE Product SET productImageURL = 'img/12.jpg' WHERE ProductId = 12;
UPDATE Product SET productImageURL = 'img/13.jpg' WHERE ProductId = 13;

