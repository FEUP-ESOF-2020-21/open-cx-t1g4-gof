PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Talks;
CREATE TABLE Talks(
    id INTEGER PRIMARY KEY,
    id_guild INT NOT NULL,
    id_channel INT NOT NULL,   
    id_talk VARCHAR UNIQUE NOT NULL,
    UNIQUE (id_guild, id_channel)
);
