-- スキーマ作成
CREATE SCHEMA dbt_dev;

-- Users テーブルの作成
CREATE TABLE "postgres"."dbt_dev"."users" (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(50),
    phone_number VARCHAR(20)
);

-- Todos テーブルの作成
CREATE TABLE "postgres"."dbt_dev"."todos" (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority INT,
    complete BOOLEAN DEFAULT FALSE
);

-- Users テーブルにテストデータを挿入
INSERT INTO "postgres"."dbt_dev"."users" (email, username, first_name, last_name, password, is_active, role, phone_number)
VALUES
    ('user1@example.com', 'user1', 'John', 'Doe', 'hashedpassword1', TRUE, 'admin', '123-456-7890'),
    ('user2@example.com', 'user2', 'Jane', 'Smith', 'hashedpassword2', TRUE, 'user', '234-567-8901'),
    ('user3@example.com', 'user3', 'Alice', 'Johnson', 'hashedpassword3', FALSE, 'user', '345-678-9012');

-- Todos テーブルにテストデータを挿入
INSERT INTO "postgres"."dbt_dev"."todos" (title, description, priority, complete)
VALUES
    ('Buy groceries', 'Buy milk, eggs, and bread', 2, FALSE),
    ('Finish project', 'Complete the database migration', 1, FALSE),
    ('Call mom', 'Check in with mom and chat', 3, TRUE);
