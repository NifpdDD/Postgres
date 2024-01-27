-- Удаляем триггеры
DROP TRIGGER IF EXISTS insert_books_and_authors ON books_and_authors;
DROP TRIGGER IF EXISTS update_books_and_authors ON books_and_authors;
DROP TRIGGER IF EXISTS delete_books_and_authors ON books_and_authors;

-- Удаляем функции
DROP FUNCTION IF EXISTS insert_books_and_authors();
DROP FUNCTION IF EXISTS update_books_and_authors();
DROP FUNCTION IF EXISTS delete_books_and_authors();

-- Удаляем таблицы
DROP TABLE IF EXISTS author_book CASCADE ;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE author_book (
    author_book_id SERIAL PRIMARY KEY,
    author_id INT NOT NULL,
    book_id INT NOT NULL,
    year_written INT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    UNIQUE (author_id, book_id)
);
CREATE VIEW books_and_authors AS
SELECT authors.name AS author_name, books.title AS book_title, author_book.year_written
FROM author_book
JOIN authors ON author_book.author_id = authors.author_id
JOIN books ON author_book.book_id = books.book_id;

CREATE OR REPLACE FUNCTION insert_books_and_authors()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO authors (name) VALUES (NEW.author_name)
    ON CONFLICT (name) DO NOTHING;

    INSERT INTO books (title) VALUES (NEW.book_title)
    ON CONFLICT (title) DO NOTHING;

    INSERT INTO author_book (author_id, book_id, year_written)
    VALUES ((SELECT author_id FROM authors WHERE name = NEW.author_name),
            (SELECT book_id FROM books WHERE title = NEW.book_title),
            NEW.year_written);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_books_and_authors
INSTEAD OF INSERT ON books_and_authors
FOR EACH ROW EXECUTE FUNCTION insert_books_and_authors();

CREATE OR REPLACE FUNCTION update_books_and_authors()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE author_book
    SET year_written = NEW.year_written
    WHERE author_id = (SELECT author_id FROM authors WHERE name = NEW.author_name)
    AND book_id = (SELECT book_id FROM books WHERE title = NEW.book_title);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_books_and_authors
INSTEAD OF UPDATE ON books_and_authors
FOR EACH ROW EXECUTE FUNCTION update_books_and_authors();


CREATE OR REPLACE FUNCTION delete_books_and_authors()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM author_book
    WHERE author_id = (SELECT author_id FROM authors WHERE name = OLD.author_name)
    AND book_id = (SELECT book_id FROM books WHERE title = OLD.book_title);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_books_and_authors
INSTEAD OF DELETE ON books_and_authors
FOR EACH ROW EXECUTE FUNCTION delete_books_and_authors();

-- Вставляем данные
INSERT INTO books_and_authors (author_name, book_title, year_written) VALUES ('Author 1', 'Book 1', 2000);
INSERT INTO books_and_authors (author_name, book_title, year_written) VALUES ('Author 2', 'Book 2', 2005);
INSERT INTO books_and_authors (author_name, book_title, year_written) VALUES ('Author 1', 'Book 3', 2010);

-- Обновляем данные
UPDATE books_and_authors SET year_written = 2020 WHERE author_name = 'Author 1' AND book_title = 'Book 1';

-- Удаляем данные
DELETE FROM books_and_authors WHERE author_name = 'Author 2' AND book_title = 'Book 2';

-- Проверяем результат
SELECT * FROM books_and_authors;
select  * FROM authors;
SELECT * FROM books;
SELECT * FROM author_book;

-- Удаляем триггеры
DROP TRIGGER IF EXISTS insert_books_and_authors ON books_and_authors;
DROP TRIGGER IF EXISTS update_books_and_authors ON books_and_authors;
DROP TRIGGER IF EXISTS delete_books_and_authors ON books_and_authors;

-- Удаляем функции
DROP FUNCTION IF EXISTS insert_books_and_authors();
DROP FUNCTION IF EXISTS update_books_and_authors();
DROP FUNCTION IF EXISTS delete_books_and_authors();

-- Удаляем таблицы
DROP TABLE IF EXISTS author_book CASCADE ;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;