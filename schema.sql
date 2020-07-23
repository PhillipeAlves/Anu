CREATE DATABASE anu;

CREATE TABLE gigs (
    id SERIAL PRIMARY KEY,
    title VARCHAR(50),
    description TEXT,
    user_id INTEGER,
    date DATE,
    is_front_of_house BOOLEAN,
    is_back_of_house BOOLEAN
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    user_name TEXT,
    password_digest TEXT,
    email TEXT,
    bio TEXT,
    skills TEXT,
    image_data TEXT,
    is_front_of_house BOOLEAN,
    is_back_of_house BOOLEAN
);
