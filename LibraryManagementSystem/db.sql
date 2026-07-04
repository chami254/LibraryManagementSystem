CREATE DATABASE IF NOT EXISTS LibraryManagementDB;

USE LibraryManagementDB;

CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('Student','Admin') NOT NULL DEFAULT 'Student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    category VARCHAR(100),
    quantity INT NOT NULL DEFAULT 0,
    available_quantity INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS BorrowRecords (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    book_id INT NOT NULL,

    borrow_date DATE NOT NULL,

    due_date DATE NOT NULL,

    return_date DATE,

    status ENUM('Borrowed','Returned','Overdue')
        DEFAULT 'Borrowed',

    FOREIGN KEY (user_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE,

    FOREIGN KEY (book_id)
        REFERENCES Books(book_id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS AdminLogs (

    log_id INT AUTO_INCREMENT PRIMARY KEY,

    admin_id INT NOT NULL,

    action VARCHAR(255) NOT NULL,

    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (admin_id)
        REFERENCES Users(user_id)
        ON DELETE CASCADE
);

INSERT INTO Users
(full_name, username, email, password, role)

VALUES

(
'System Administrator',
'admin',
'admin@library.com',
'admin123',
'Admin'
);


INSERT INTO Books
(title, author, isbn, category, quantity, available_quantity)

VALUES

('Introduction to Java','Herbert Schildt','9781260440232','Programming',10,10),

('Database System Concepts','Abraham Silberschatz','9780073523323','Database',8,8),

('Computer Networks','Andrew Tanenbaum','9780132126953','Networking',5,5),

('Operating System Concepts','Abraham Silberschatz','9781119456339','Operating Systems',6,6),

('Clean Code','Robert C. Martin','9780132350884','Software Engineering',7,7);
