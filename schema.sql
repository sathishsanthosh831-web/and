-- Pitch Deck Generator: MySQL schema
CREATE DATABASE IF NOT EXISTS pitchdeck_db;
USE pitchdeck_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS decks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    startup_name VARCHAR(200) NOT NULL,
    idea_description TEXT NOT NULL,
    industry VARCHAR(100),
    status ENUM('draft', 'generated', 'edited', 'exported') DEFAULT 'draft',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Each row is one slide belonging to a deck, stored as editable JSON content
CREATE TABLE IF NOT EXISTS slides (
    id INT AUTO_INCREMENT PRIMARY KEY,
    deck_id INT NOT NULL,
    slide_order INT NOT NULL,
    slide_type VARCHAR(60) NOT NULL,   -- e.g. problem, solution, market, business_model
    title VARCHAR(255),
    content_json JSON,                 -- flexible: bullet points, stats, text blocks
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (deck_id) REFERENCES decks(id) ON DELETE CASCADE
);

CREATE INDEX idx_slides_deck ON slides(deck_id);
CREATE INDEX idx_decks_user ON decks(user_id);
