CREATE DATABASE internet_tv;
USE internet_tv;

CREATE TABLE channels (
    id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE programs (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    program_detail VARCHAR(500) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE episodes (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    season_num INT ,
    episode_num INT ,
    episode_detail VARCHAR(500) NOT NULL,
    movie_time INT NOT NULL,
    release_date DATE NOT NULL,
    program_id INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE (program_id, season_num, episode_num),
    FOREIGN KEY (program_id) REFERENCES programs(id)
);

CREATE TABLE program_slots (
    id INT AUTO_INCREMENT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    channel_id INT NOT NULL,
    episode_id INT NOT NULL,
    views INT NOT NULL,
    UNIQUE (channel_id,start_time),
    PRIMARY KEY (id),
    FOREIGN KEY (channel_id) REFERENCES channels(id),
    FOREIGN KEY (episode_id) REFERENCES episodes(id)
);

CREATE TABLE genres (
    id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE programs_genres (
    program_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (program_id, genre_id),
    FOREIGN KEY (program_id) REFERENCES programs(id),
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);