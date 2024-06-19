#RELATIONAL SCHEMA BEGINS HERE
DROP DATABASE IF EXISTS bookist;
CREATE DATABASE bookist;
use bookist;

CREATE TABLE Book (
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    book_id VARCHAR(20),
    Genre VARCHAR(50),
    Description TEXT,
    Images JSON,
    Page_count INT,
    Language VARCHAR(50),
    PRIMARY KEY (book_id)
);


CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    Username VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    First_name VARCHAR(255) NOT NULL,
    Middle_name VARCHAR(255) DEFAULT NULL,
    Last_name VARCHAR(255) NOT NULL,
    Email_id VARCHAR(255) NOT NULL,
    Phone_no VARCHAR(20) DEFAULT NULL,
    Address_Line_1 VARCHAR(255) NOT NULL,
    Address_Line_2 VARCHAR(255) DEFAULT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    Landmark VARCHAR(255) DEFAULT NULL,
    Date_of_birth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    Profile_picture JSON DEFAULT NULL,
    Card_number VARCHAR(20) NOT NULL,
    Card_expiration DATE NOT NULL,
    Card_cvc VARCHAR(4) NOT NULL,
    Cardholder_name VARCHAR(255) NOT NULL,
    blocked BOOLEAN DEFAULT FALSE,
    CONSTRAINT chk_address CHECK (Address_Line_1 <> '' AND City <> '' AND State <> '' AND Pincode <> ''),
    CONSTRAINT chk_email CHECK (Email_id <> ''),
    CONSTRAINT chk_card_number CHECK (Card_number <> ''),
    CONSTRAINT chk_card_cvc CHECK (Card_cvc <> ''),
    CONSTRAINT chk_cardholder_name CHECK (Cardholder_name <> '')
);

CREATE TABLE Customer_phno (
  Phone_id INT PRIMARY KEY AUTO_INCREMENT,
  Customer_id INT NOT NULL,
  Phone_number VARCHAR(20) NOT NULL,
  FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id) ON DELETE CASCADE,
  CONSTRAINT phone_length CHECK (LENGTH(Phone_number) = 10)
);

CREATE TABLE Store (
    Store_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Address_Line_1 VARCHAR(255) NOT NULL,
    Address_Line_2 VARCHAR(255) DEFAULT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Pincode VARCHAR(10) NOT NULL CHECK (LENGTH(Pincode) = 6),
    CONSTRAINT address_not_null CHECK (Address_Line_1 <> '' OR Address_Line_2 <> '')
);

CREATE TABLE Delivery_agent (
  Agent_id INT AUTO_INCREMENT PRIMARY KEY,
  Name VARCHAR(255) NOT NULL,
  First_name VARCHAR(255) NOT NULL,
  Middle_name VARCHAR(255),
  Last_name VARCHAR(255) NOT NULL,
  Password VARCHAR(255) NOT NULL,
  Availability BOOLEAN NOT NULL DEFAULT true,
  Phone_no VARCHAR(20),
  CONSTRAINT chk_agent_name CHECK (Name <> ''),
  CONSTRAINT chk_password_length CHECK (LENGTH(Password) >= 6),
  Store_id INT NOT NULL,
  FOREIGN KEY (Store_id) REFERENCES Store(Store_id) ON DELETE CASCADE
);

CREATE TABLE Delivery_agent_phno (
  Phone_id INT PRIMARY KEY AUTO_INCREMENT,
  Agent_id INT NOT NULL,
  Phone_number VARCHAR(20) NOT NULL,
  FOREIGN KEY (Agent_id) REFERENCES Delivery_agent(Agent_id) ON DELETE CASCADE,
  CONSTRAINT delivery_agent_phone_length CHECK (LENGTH(Phone_number) = 10)
);


CREATE TABLE Manager (
    Manager_id INT PRIMARY KEY AUTO_INCREMENT,
    Password VARCHAR(255) NOT NULL,
    First_name VARCHAR(255) NOT NULL,
    Middle_name VARCHAR(255),
    Last_name VARCHAR(255) NOT NULL,
    Email_id VARCHAR(255) NOT NULL,
    Phone_no VARCHAR(20),
    Address_Line_1 VARCHAR(255) NOT NULL,
    Address_Line_2 VARCHAR(255) DEFAULT NULL,
    City VARCHAR(255) NOT NULL,
    State VARCHAR(255) NOT NULL,
    Pincode VARCHAR(10) NOT NULL,
    Landmark VARCHAR(255),
    Card_number VARCHAR(20),
    Card_expiration DATE,
    Card_cvc VARCHAR(4),
    Cardholder_name VARCHAR(255),
    Profile_picture JSON,
    Store_id INT UNIQUE NOT NULL,
    CONSTRAINT chk_addres CHECK (Address_Line_1 <> '' AND City <> '' AND State <> '' AND Pincode <> ''),
    CONSTRAINT chk_emai CHECK (Email_id <> ''),
    CONSTRAINT chk_card_numbe CHECK (Card_number <> ''),
    CONSTRAINT chk_card_cv CHECK (Card_cvc <> ''),
    CONSTRAINT chk_cardholder_nam CHECK (Cardholder_name <> ''),
    FOREIGN KEY (Store_id) REFERENCES Store(Store_id) ON DELETE CASCADE
);

CREATE TABLE Manager_phno (
  Phone_id INT PRIMARY KEY AUTO_INCREMENT,
  Manager_id INT NOT NULL,
  Phone_number VARCHAR(20) NOT NULL,
  FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id) ON DELETE CASCADE,
  CONSTRAINT manager_phone_length CHECK (LENGTH(Phone_number) = 10)
);



CREATE TABLE store_inventory (
  Store_id INT NOT NULL,
  book_id varchar(20) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  Quantity INT NOT NULL CHECK (Quantity >= 0),
  Date_added DATE NOT NULL,
  PRIMARY KEY (Store_id, Book_id),
  FOREIGN KEY (Store_id) REFERENCES Store(Store_id) ON DELETE CASCADE,
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id) ON DELETE CASCADE
);

CREATE TABLE Readlist (
  Readlist_id INT PRIMARY KEY AUTO_INCREMENT,
  Title VARCHAR(255) NOT NULL,
  Description TEXT,
  Likes INT DEFAULT 0 NOT NULL,
  Dislikes INT DEFAULT 0 NOT NULL,
  customerID INT NOT NULL,
  FOREIGN KEY (customerID) REFERENCES Customer(Customer_id) ON DELETE CASCADE
);


CREATE TABLE Readlistbooks (
  Readlist_id INT NOT NULL,
  book_id varchar(20) NOT NULL,
  Date_added DATE NOT NULL,
  PRIMARY KEY (Readlist_id, Book_id),
  FOREIGN KEY (Readlist_id) REFERENCES Readlist(Readlist_id) ON DELETE CASCADE,
  FOREIGN KEY (Book_id) REFERENCES Book(Book_id) ON DELETE CASCADE
);


CREATE TABLE Order_tracking (
  Order_id INT AUTO_INCREMENT PRIMARY KEY,
  status VARCHAR(255) NOT NULL,
  location VARCHAR(255) NOT NULL,
  eta DATETIME,
  date_placed DATETIME NOT NULL,
  date_shipped DATETIME,
  date_delivered DATETIME,
  placed_by INT NOT NULL,
  delivered_by INT NOT NULL,
  FOREIGN KEY (delivered_by) REFERENCES Delivery_agent(Agent_id),
  FOREIGN KEY (placed_by) REFERENCES Customer(Customer_id)
);

CREATE TABLE Ordered_items (
  book_id varchar(20) NOT NULL,
  quantity INT NOT NULL,
  store_id INT NOT NULL,
  order_id INT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES Order_Tracking(order_id) ON DELETE CASCADE,
  FOREIGN KEY (store_id) REFERENCES Store(Store_id),
  FOREIGN KEY (book_id) REFERENCES Book(book_id)
);

CREATE TABLE Cart (
  Cart_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  book_id varchar(20) NOT NULL,
  quantity INT NOT NULL,
  added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES Customer(Customer_id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES Book(Book_id) ON DELETE CASCADE
);


CREATE TABLE Delivery_review (
  Review_id INT AUTO_INCREMENT PRIMARY KEY,
  text TEXT NOT NULL,
  stars DOUBLE NOT NULL,
  reviewed_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deli_id INT NOT NULL,
  given_by INT NOT NULL,
  FOREIGN KEY (deli_id)  REFERENCES Delivery_agent(Agent_id) ON DELETE CASCADE,
  FOREIGN KEY (given_by) REFERENCES Customer(Customer_id) ON DELETE CASCADE
);

CREATE TABLE Book_review (
  Review_id INT AUTO_INCREMENT PRIMARY KEY,
  text TEXT NOT NULL,
  stars DOUBLE NOT NULL,
  reviewed_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  book_id Varchar(20) NOT NULL,
  customer_id INT NOT NULL,
  FOREIGN KEY (book_id) REFERENCES Book(Book_id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES Customer(Customer_id) ON DELETE CASCADE
);


CREATE TABLE Store_review (
  Review_id INT AUTO_INCREMENT PRIMARY KEY,
  text TEXT NOT NULL,
  stars DOUBLE NOT NULL,
  reviewed_on DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  store_id INT NOT NULL,
  customer_id INT NOT NULL,
  FOREIGN KEY (store_id) REFERENCES Store(Store_id) ON DELETE CASCADE,
  FOREIGN KEY (customer_id) REFERENCES Customer(Customer_id) ON DELETE CASCADE
);

CREATE TABLE Login_attempts(
    id INT AUTO_INCREMENT PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	currtim datetime DEFAULT CURRENT_TIMESTAMP,
	successful BOOLEAN DEFAULT FALSE
);

DELIMITER //

CREATE TRIGGER afterloginattempt
AFTER INSERT ON Login_attempts
FOR EACH ROW
BEGIN
    DECLARE attempts INT;
    SELECT COUNT(*) INTO attempts FROM login_attempts WHERE username = NEW.username AND successful = FALSE;
    IF attempts >= 3 THEN
        UPDATE customer SET blocked = TRUE WHERE customer.username = NEW.username;
    END IF;
END;
//

DELIMITER ;
select * from login_attempts;
CREATE TABLE Admins (
    Email_id VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL
);
delete from login_attempts;

CREATE TABLE purchases(
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id VARCHAR(255) NOT NULL,
    store_id INT NOT NULL, 
	currtim datetime DEFAULT CURRENT_TIMESTAMP,
	quantity int NOT null,
	FOREIGN KEY (book_id) REFERENCES Book(Book_id),
	FOREIGN KEY (store_id) REFERENCES store(store_id)
);

DELIMITER //

CREATE TRIGGER check_stock_before_purchase
BEFORE INSERT ON purchases
FOR EACH ROW
BEGIN
    DECLARE available_stock INT;
    SELECT quantity INTO available_stock FROM store_inventory WHERE store_id = NEW.store_id AND book_id = NEW.book_id;
    IF available_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient stock for purchase';
    END IF;
END //

DELIMITER ;


INSERT INTO Book (Title, Author, book_id, Genre, Description, Images, Page_count, Language)
VALUES
('The Guide', 'R.K. Narayan', '9780143416937','Fiction', 'A novel set in the fictional town of Malgudi', '{"cover": "guide_cover.jpg", "back": "guide_back.jpg"}', 272, 'English'),
('The Namesake', 'Jhumpa Lahiri', '9780618485222', 'Fiction', 'A story of a boy born to Indian immigrants in the USA', '{"cover": "namesake_cover.jpg", "back": "namesake_back.jpg"}', 291, 'English'),
('The God of Small Things', 'Arundhati Roy', '9780679457312', 'Fiction', 'A novel set in Kerala, India', '{"cover": "god_of_small_things_cover.jpg", "back": "god_of_small_things_back.jpg"}', 333, 'English'),
('A Suitable Boy', 'Vikram Seth', '9780060786526', 'Fiction', 'An epic tale of post-independence India', '{"cover": "suitable_boy_cover.jpg", "back": "suitable_boy_back.jpg"}', 1474, 'English'),
('The White Tiger', 'Aravind Adiga', '9781416562603', 'Non-Fiction', 'A novel that takes you through the underbelly of India', '{"cover": "white_tiger_cover.jpg", "back": "white_tiger_back.jpg"}', 321, 'English'),
('Interpreter of Maladies', 'Jhumpa Lahiri', '9780395927205', 'Fiction', 'A collection of short stories', '{"cover": "interpreter_of_maladies_cover.jpg", "back": "interpreter_of_maladies_back.jpg"}', 198, 'English'),
('Midnight''s Children', 'Salman Rushdie', '9780812976533', 'Fiction', 'A tale following the life of Saleem Sinai, born at the stroke of midnight on August 15, 1947', '{"cover": "midnights_children_cover.jpg", "back": "midnights_children_back.jpg"}', 533, 'English'),
('The Palace of Illusions', 'Chitra Banerjee Divakaruni', '9781400096201', 'Fiction', 'Retelling of the Indian epic Mahabharata from Draupadi''s perspective', '{"cover": "palace_of_illusions_cover.jpg", "back": "palace_of_illusions_back.jpg"}', 360, 'English'),
('Five Point Someone', 'Chetan Bhagat', '9788129135508', 'Fantasy', 'A story about the trials and tribulations of three friends at IIT', '{"cover": "five_point_someone_cover.jpg", "back": "five_point_someone_back.jpg"}', 270, 'English'),
('The Immortals of Meluha', 'Amish Tripathi', '9789380658742', 'Fiction', 'First book of the Shiva trilogy', '{"cover": "immortals_of_meluha_cover.jpg", "back": "immortals_of_meluha_back.jpg"}', 436, 'English');

INSERT INTO Customer (Username, Password, First_name, Middle_name, Last_name, Email_id, Phone_no, Address_Line_1, Address_Line_2, City, State, Pincode, Landmark, Date_of_birth, Gender, Card_number, Card_expiration, Card_cvc, Cardholder_name)
VALUES
('john_doe', 'password123', 'John', NULL, 'Doe', 'john@example.com', '9876543210', '123, Main Street', NULL, 'Mumbai', 'Maharashtra', '400001', 'Near Central Park', '1990-01-01', 'M', '1234567890123456', '2025-12-31', '123', 'John Doe'),
('jane_smith', 'securepwd', 'Jane', NULL, 'Smith', 'jane@example.com', '9876543211', '456, Elm Street', NULL, 'Bangalore', 'Karnataka', '560001', 'Near Metro Station', '1992-05-15', 'F', '2345678901234567', '2026-11-30', '456', 'Jane Smith'),
('ramesh_kumar', 'mypass', 'Ramesh', NULL, 'Kumar', 'ramesh@example.com', '9876543212', '789, Oak Avenue', NULL, 'Chennai', 'Tamil Nadu', '600001', 'Near Marina Beach', '1985-11-22', 'M', '3456789012345678', '2027-09-30', '789', 'Ramesh Kumar'),
('sita_devi', 'sitaspass', 'Sita', NULL, 'Devi', 'sita@example.com', '9876543213', '101, Rose Garden', NULL, 'Hyderabad', 'Telangana', '500001', 'Near Charminar', '1988-08-10', 'F', '4567890123456789', '2025-08-31', '456', 'Sita Devi'),
('mohammad_ali', 'muhammadpass', 'Mohammad', NULL, 'Ali', 'mohammad@example.com', '9876543214', '321, Palm Street', NULL, 'Kolkata', 'West Bengal', '700001', 'Near Victoria Memorial', '1987-03-05', 'M', '5678901234567890', '2024-10-31', '567', 'Mohammad Ali'),
('radha_sharma', 'radhapass', 'Radha', NULL, 'Sharma', 'radha@example.com', '9876543215', '456, Lotus Lane', NULL, 'Pune', 'Maharashtra', '411001', 'Near Shaniwar Wada', '1991-09-18', 'F', '6789012345678901', '2023-05-31', '678', 'Radha Sharma'),
('kiran_patel', 'kiranspass', 'Kiran', NULL, 'Patel', 'kiran@example.com', '9876543216', '987, Maple Drive', NULL, 'Ahmedabad', 'Gujarat', '380001', 'Near Sabarmati Ashram', '1994-12-30', 'M', '7890123456789012', '2026-12-31', '789', 'Kiran Patel'),
('deepika_menon', 'deepikapass', 'Deepika', NULL, 'Menon', 'deepika@example.com', '9876543217', '567, Pine Street', NULL, 'Jaipur', 'Rajasthan', '302001', 'Near Hawa Mahal', '1989-07-25', 'F', '8901234567890123', '2025-02-28', '890', 'Deepika Menon'),
('vivek_gupta', 'vivekspass', 'Vivek', NULL, 'Gupta', 'vivek@example.com', '9876543218', '234, Cedar Avenue', NULL, 'Lucknow', 'Uttar Pradesh', '226001', 'Near Bara Imambara', '1993-04-14', 'M', '9012345678901234', '2027-07-31', '901', 'Vivek Gupta'),
('ananya_shah', 'ananyapass', 'Ananya', NULL, 'Shah', 'ananya@example.com', '9876543219', '678, Redwood Street', NULL, 'Chandigarh', 'Punjab', '160001', 'Near Rock Garden', '1996-02-08', 'F', '0123456789012345', '2024-03-31', '012', 'Ananya Shah');

INSERT INTO Customer_phno (Customer_id, Phone_number)
VALUES
(1, '9876543210'),
(2, '9876543211'),
(3, '9876543212'),
(4, '9876543213'),
(5, '9876543214'),
(6, '9876543215'),
(7, '9876543216'),
(8, '9876543217'),
(9, '9876543218'),
(10, '9876543219');

INSERT INTO Store (Name, Address_Line_1, Address_Line_2, City, State, Pincode)
VALUES
('Books & Beyond', '789, MG Road', NULL, 'Delhi', 'Delhi', '110001'),
('Pages Bookstore', '456, Brigade Road', NULL, 'Bangalore', 'Karnataka', '560001'),
('Novel Nook', '101, Park Street', NULL, 'Kolkata', 'West Bengal', '700001'),
('Mumbai Book House', '456, Marine Drive', NULL, 'Mumbai', 'Maharashtra', '400001'),
('Chennai Reads', '678, Mount Road', NULL, 'Chennai', 'Tamil Nadu', '600001'),
('Hyderabad Book Haven', '789, Hitech City Road', NULL, 'Hyderabad', 'Telangana', '500001'),
('Ahmedabad Book Corner', '234, Gandhi Road', NULL, 'Ahmedabad', 'Gujarat', '380001'),
('Jaipur Book Palace', '567, Hawa Mahal Road', NULL, 'Jaipur', 'Rajasthan', '302001'),
('Lucknow Book Stop', '678, Hazratganj', NULL, 'Lucknow', 'Uttar Pradesh', '226001'),
('Chandigarh Book Hub', '456, Sector 17', NULL, 'Chandigarh', 'Punjab', '160001');

INSERT INTO Delivery_agent (Name, First_name, Last_name, Password, Availability, Phone_no, Store_id)
VALUES
('David', 'David', 'Johnson', 'davidpass', true, '9876543212', 1),
('Sarah', 'Sarah', 'Khan', 'sarahpass', true, '9876543213', 2),
('Michael', 'Michael', 'Brown', 'michaelpass', true, '9876543214', 3),
('Sophia', 'Sophia', 'Patel', 'sophiapass', true, '9876543215', 4),
('Ethan', 'Ethan', 'Gupta', 'ethanpass', true, '9876543216', 5),
('Emma', 'Emma', 'Sharma', 'emmapass', true, '9876543217', 6),
('Olivia', 'Olivia', 'Singh', 'oliviapass', true, '9876543218', 7),
('Noah', 'Noah', 'Shah', 'noahpass', true, '9876543219', 8),
('Ava', 'Ava', 'Kumar', 'avapass', true, '9876543220', 9),
('Liam', 'Liam', 'Dutta', 'liampass', true, '9876543221', 10);

INSERT INTO Delivery_agent_phno (Agent_id, Phone_number)
VALUES
(1, '9876543212'),
(2, '9876543213'),
(3, '9876543214'),
(4, '9876543215'),
(5, '9876543216'),
(6, '9876543217'),
(7, '9876543218'),
(8, '9876543219'),
(9, '9876543220'),
(10, '9876543221');

INSERT INTO Manager (Password, First_name, Middle_name, Last_name, Email_id, Phone_no, Address_Line_1, Address_Line_2, City, State, Pincode, Landmark, Card_number, Card_expiration, Card_cvc, Cardholder_name, Store_id)
VALUES
('managerpass', 'Michael', NULL, 'Smith', 'manager@example.com', '9876543214', '789, Main Street', NULL, 'Mumbai', 'Maharashtra', '400001', 'Near Central Park', '3456789012345678', '2027-05-31', '789', 'Michael Smith', 1),
('sarahmanagerpass', 'Sarah', NULL, 'Jones', 'sarah@example.com', '9876543222', '456, Brigade Road', NULL, 'Bangalore', 'Karnataka', '560001', 'Near Metro Station', '4567890123456789', '2026-06-30', '987', 'Sarah Jones', 2),
('davidmanagerpass', 'David', NULL, 'Brown', 'david@example.com', '9876543223', '101, Park Street', NULL, 'Kolkata', 'West Bengal', '700001', 'Near Victoria Memorial', '5678901234567890', '2025-07-31', '654', 'David Brown', 3),
('jessicamanagerpass', 'Jessica', NULL, 'Patel', 'jessica@example.com', '9876543224', '456, Marine Drive', NULL, 'Mumbai', 'Maharashtra', '400001', 'Near Gateway of India', '6789012345678901', '2024-08-31', '543', 'Jessica Patel', 4),
('ryanmanagerpass', 'Ryan', NULL, 'Singh', 'ryan@example.com', '9876543225', '678, Mount Road', NULL, 'Chennai', 'Tamil Nadu', '600001', 'Near Marina Beach', '7890123456789012', '2023-09-30', '432', 'Ryan Singh', 5),
('emilymanagerpass', 'Emily', NULL, 'Sharma', 'emily@example.com', '9876543226', '789, Hitech City Road', NULL, 'Hyderabad', 'Telangana', '500001', 'Near Charminar', '8901234567890123', '2022-10-31', '321', 'Emily Sharma', 6),
('ethanmanagerpass', 'Ethan', NULL, 'Gupta', 'ethan@example.com', '9876543227', '234, Gandhi Road', NULL, 'Ahmedabad', 'Gujarat', '380001', 'Near Sabarmati Ashram', '9012345678901234', '2021-11-30', '210', 'Ethan Gupta', 7),
('madisonmanagerpass', 'Madison', NULL, 'Shah', 'madison@example.com', '9876543228', '567, Hawa Mahal Road', NULL, 'Jaipur', 'Rajasthan', '302001', 'Near Hawa Mahal', '0123456789012345', '2020-12-31', '109', 'Madison Shah', 8),
('dylanmanagerpass', 'Dylan', NULL, 'Kumar', 'dylan@example.com', '9876543229', '678, Hazratganj', NULL, 'Lucknow', 'Uttar Pradesh', '226001', 'Near Bara Imambara', '1234567890123456', '2019-01-31', '456', 'Dylan Kumar', 9),
('mia', 'Mia', NULL, 'Dutta', 'mia@example.com', '9876543230', '456, Sector 17', NULL, 'Chandigarh', 'Punjab', '160001', 'Near Rock Garden', '2345678901234567', '2018-02-28', '789', 'Mia Dutta', 10);

INSERT INTO Manager_phno (Manager_id, Phone_number)
VALUES
(1, '9876543214'),
(2, '9876543222'),
(3, '9876543223'),
(4, '9876543224'),
(5, '9876543225'),
(6, '9876543226'),
(7, '9876543227'),
(8, '9876543228'),
(9, '9876543229'),
(10, '9876543230');

INSERT INTO store_inventory (Store_id, book_id, Quantity, Date_added, price)
VALUES
(1, '9780143416937', 50, '2024-03-04', 200),
(1, '9780679457312', 30, '2024-03-04', 350),
(2, '9780618485222', 40, '2024-03-04', 400),
(2, '9781416562603', 15, '2024-03-04', 500),
(3, '9780395927205', 60, '2024-03-04', 900),
(3, '9780060786526', 20, '2024-03-04', 850),
(4, '9781400096201', 35, '2024-03-04', 260),
(4, '9780812976533', 55, '2024-03-04', 200),
(5, '9780143416937', 45, '2024-03-04', 700),
(5, '9780679457312', 28, '2024-03-04', 2000),
(6, '9780143416937', 50, '2024-03-04', 200),
(6, '9780679457312', 30, '2024-03-04', 350),
(7, '9780618485222', 40, '2024-03-04', 400),
(7, '9781416562603', 15, '2024-03-04', 500),
(8, '9780395927205', 60, '2024-03-04', 900),
(8, '9780060786526', 20, '2024-03-04', 850),
(9, '9781400096201', 35, '2024-03-04', 260),
(9, '9780812976533', 55, '2024-03-04', 200),
(10, '9780143416937', 45, '2024-03-04', 700),
(10, '9780679457312', 28, '2024-03-04', 2000);


INSERT INTO Readlist (Title, Description, Likes, Dislikes, customerID)
VALUES
('Favorites', 'My favorite books collection', 10, 2, 1),
('To Read', 'Books I plan to read soon', 5, 0, 2),
('Classics', 'Classic literature from around the world', 7, 1, 3),
('Sci-Fi', 'Mind-bending science fiction novels', 15, 3, 4),
('Bestsellers', 'Latest bestsellers in fiction and non-fiction', 20, 5, 5),
('Mystery', 'Thrilling mystery and detective novels', 12, 1, 6),
('Romance', 'Heartwarming romance novels', 8, 2, 7),
('Biographies', 'Inspiring biographies of famous personalities', 6, 0, 8),
('Fantasy', 'Epic fantasy adventures', 10, 3, 9),
('Self-Help', 'Books for personal growth and development', 9, 1, 10);

INSERT INTO Readlistbooks (Readlist_id, book_id, Date_added)
VALUES
(1, '9780143416937', '2024-03-04'),
(1, '9780679457312', '2024-03-04'),
(2, '9780618485222', '2024-03-04'),
(3, '9780395927205', '2024-03-04'),
(4, '9781416562603', '2024-03-04'),
(5, '9780060786526', '2024-03-04'),
(6, '9781400096201', '2024-03-04'),
(7, '9780812976533', '2024-03-04'),
(8, '9780143416937', '2024-03-04'),
(9, '9780679457312', '2024-03-04');

INSERT INTO Order_tracking (status, location, eta, date_placed, placed_by, delivered_by)
VALUES
('Processing', 'Warehouse A', NULL, '2024-03-04 10:00:00', 1, 1),
('Shipped', 'Transit', '2024-03-05 12:00:00', '2024-03-04 10:30:00', 2, 2),
('Out for Delivery', 'Nearby Area', NULL, '2024-03-05 08:00:00', 3, 3),
('Delivered', 'Customer Address', NULL, '2024-03-05 11:00:00', 4, 4),
('Processing', 'Warehouse B', NULL, '2024-03-06 09:00:00', 5, 5),
('Shipped', 'Transit', '2024-03-07 10:00:00', '2024-03-06 09:30:00', 6, 6),
('Out for Delivery', 'Nearby Area', NULL, '2024-03-07 07:00:00', 7, 7),
('Delivered', 'Customer Address', NULL, '2024-03-07 12:00:00', 8, 8),
('Processing', 'Warehouse C', NULL, '2024-03-08 08:00:00', 9, 9),
('Shipped', 'Transit', '2024-03-09 11:00:00', '2024-03-08 08:30:00', 10, 10);

INSERT INTO Ordered_items (book_id, quantity, store_id, order_id)
VALUES
('9780143416937', 2, 1, 1),
('9781416562603', 1, 2, 1),
('9780395927205', 3, 3, 3),
('9781400096201', 2, 4, 4),
('9780143416937', 1, 5, 5),
('9780143416937', 2, 6, 6),
('9780618485222', 1, 7, 7),
('9780060786526', 3, 8, 8),
('9780812976533', 2, 9, 9),
('9780679457312', 1, 10, 10);

INSERT INTO Cart (customer_id, book_id, quantity)
VALUES
(1, '9780679457312', 2),
(1, '9780143416937', 1),
(2, '9780618485222', 1),
(3, '9780395927205', 3),
(4, '9781416562603', 2),
(5, '9780060786526', 1),
(6, '9781400096201', 2),
(7, '9780812976533', 1),
(8, '9780143416937', 2),
(9, '9781416562603', 1);

INSERT INTO Delivery_review (text, stars, deli_id, given_by)
VALUES
('Great service, delivered on time!', 5.0, 1, 1),
('Very professional, loved the service', 4.5, 2, 2),
('Delivery was late, but understandable', 3.5, 3, 3),
('Excellent communication, highly recommended', 5.0, 4, 4),
('Good job!', 4.0, 5, 5),
('Delivery person was rude', 2.0, 6, 6),
('Package arrived damaged', 2.5, 7, 7),
('Lost my package', 1.0, 8, 8),
('Quick and efficient delivery', 4.5, 9, 9),
('Will use this service again', 4.0, 10, 9);

INSERT INTO Book_review (text, stars, book_id, customer_id)
VALUES
('Loved it, must read!', 5.0, '9780143416937', 1),
('Interesting plot', 4.0, '9780679457312', 2),
('Didn''t meet my expectations', 2.5, '9780618485222', 3),
('Captivating story', 4.5, '9780395927205', 4),
('A page-turner', 4.5, '9781416562603', 5),
('Disappointing', 2.0, '9780060786526', 6),
('Highly recommended', 5.0, '9781400096201', 7),
('Couldn''t put it down', 4.5, '9780812976533', 8),
('Average', 3.0, '9780143416937', 9),
('Worth a read', 4.0, '9781416562603', 10);

INSERT INTO Store_review (text, stars, store_id, customer_id)
VALUES
('Great collection of books', 5.0, 1, 1),
('Nice ambiance', 4.0, 2, 2),
('Good service', 3.5, 3, 3),
('Needs improvement', 2.5, 4, 4),
('Friendly staff', 4.0, 5, 5),
('Clean and organized', 4.5, 6, 6),
('Disappointing experience', 2.0, 7, 7),
('Could be better', 3.0, 8, 8),
('Convenient location', 4.5, 9, 9),
('Will visit again', 4.0, 10, 10);

INSERT INTO Admins (Email_id, Password)
VALUES
('admin1@example.com', 'adminpass1'),
('admin2@example.com', 'adminpass2');




#SQL QUERIES BEGIN HERE

#Query to retrieve the names of customers who have placed orders, along with the total number of orders placed by each customer.
SELECT first_name, last_name, count(*) 
from customer, order_tracking 
where customer.Customer_id = order_tracking.placed_by 
group by customer.customer_id; 

#Query to update the quantity of a specific book in the store inventory after a purchase has been made, ensuring that the quantity doesn't go below zero demonstrating constraints.
UPDATE store_inventory 
SET quantity = quantity - 20;

#Query to retrieve the titles and authors of books that have received high ratings (average of ratings is greater than 4 stars) in customer reviews.
SELECT b.Title, b.Author
FROM book b
JOIN book_review br ON b.Book_id = br.Book_id
GROUP BY b.Book_id
HAVING AVG(br.stars)>4;

#Query to retrieve the top three bestselling books (based on total quantity sold).
SELECT b.title, sum(ordered_items.quantity) AS Quantity_sold
from book as b, ordered_items
where ordered_items.book_id = b.book_id  
group by b.book_id
order by sum(ordered_items.quantity) DESC
LIMIT 3
;

#Query to Get Customers and Their Most Recent Orders:
SELECT c.username, o.*
FROM Customer c
JOIN (
    SELECT MAX(ot.date_placed) AS latest_order_date, ot.placed_by
    FROM Order_tracking ot
    GROUP BY ot.placed_by
) AS latest_orders ON c.Customer_id = latest_orders.placed_by
JOIN Order_tracking o ON latest_orders.latest_order_date = o.date_placed AND latest_orders.placed_by = o.placed_by;

#Query to list books added to a readlist by a customer (say 1) before a specified date eg 2024-03-05
SELECT Title from book
WHERE book.book_id IN
(SELECT rb.book_id
FROM Readlist r
JOIN Readlistbooks rb ON r.Readlist_id = rb.Readlist_id
WHERE rb.Date_added < '2024-03-05' AND r.customerID =1);


#Categorizing customer expenditure on the app(via orders) using tags such as high value, medium value and low value. This might be used in order to segregate the customerbase
#Store managers may use techniques like these to gather data about their customers
SELECT order_tracking.order_id, sum(ordered_items.quantity*store_inventory.price) as total_amount,
 CASE
	WHEN sum(ordered_items.quantity*store_inventory.price) > 1000 THEN 'High Value'
	WHEN sum(ordered_items.quantity*store_inventory.price) > 500 THEN 'Medium Value'
	ELSE 'Low Value'
END AS order_value_category 
FROM order_tracking, ordered_items, store_inventory
WHERE order_tracking.order_id = ordered_items.order_id and store_inventory.store_id = ordered_items.store_id and ordered_items.book_id = store_inventory.book_id
group by order_id;


#Query to select the customers that ordered something but did not leave a delivery review
SELECT DISTINCT c.first_name, c.last_name
FROM Customer c
JOIN Order_tracking ot ON c.Customer_id = ot.placed_by
WHERE EXISTS (
    SELECT *
    FROM Ordered_items oi
    WHERE ot.Order_id = oi.order_id
) AND NOT EXISTS (
    SELECT *
    FROM Delivery_review dr
    WHERE ot.delivered_by = dr.deli_id
    AND c.Customer_id = dr.given_by
);

#check phone length constraint
UPDATE Customer_phno
SET Phone_number = '123467890'
WHERE Phone_id = 1;

#Query to select books that are common between to given stores(id's 1 and 5 for example)
SELECT Title as books_common_between_store1_and_store5 FROM book WHERE 
book_id IN ((SELECT book_id
FROM store_inventory
WHERE Store_id = 1) 
INTERSECT 
(SELECT book_id
FROM store_inventory
WHERE Store_id = 5));


#query to find most commonly purchased genre of books
SELECT b.Genre, sum(oi.quantity) AS Purchase_Count
FROM Book b
JOIN Ordered_items oi ON b.book_id = oi.book_id
JOIN Order_tracking ot ON oi.order_id = ot.Order_id
GROUP BY b.Genre
ORDER BY Purchase_Count DESC
LIMIT 1;


#We're selecting the usernames of customers and the status of their orders. Even when there is no order we select customer names(left join)
SELECT Customer.Username, Order_tracking.status
FROM Customer
LEFT JOIN Order_tracking ON Customer.Customer_id = Order_tracking.placed_by
WHERE Order_tracking.status IS NOT NULL;

#Demonstration of the SOME OR ANY keyword basically select all books from books where the bookId is strictly greater than any of the books in store inventory(so the one lesser
#than all books in store inventory will not be chosen
SELECT * 
FROM Book
WHERE book_id > SOME (SELECT book_id FROM store_inventory);

SELECT * 
FROM book, store_inventory, Store 
WHERE book.book_id = store_inventory.book_id
AND store_inventory.store_id = store.Store_id 
    AND (book.title LIKE '%melhuha%' 
        OR book.Author LIKE '%a%' 
        OR book.Genre LIKE '%a%' 
        OR book.Description LIKE '%a%' 
        OR (SELECT Name FROM store WHERE store.store_id = store_inventory.store_id) LIKE '%a%')

SELECT DISTINCT * 
    FROM customer 
    JOIN order_tracking ON order_tracking.placed_by = customer.Customer_id 
    JOIN ordered_items ON order_tracking.order_id = ordered_items.order_id 
    WHERE username = 'john_doe' AND password = 'password123' 
    ORDER BY ordered_items.order_id ASC
    
    select * from order_tracking
    select * from ordered_items
    
SELECT * 
FROM store_inventory JOIN store ON store_inventory.store_id = store.store_id JOIN book ON book.book_id =  store_inventory.book_id
WHERE store_inventory.store_id = (SELECT store_id from manager WHERE manager_id =1)



