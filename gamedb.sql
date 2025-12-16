-- RANKS TABLE
-- -----------------------------
-- Stores the competitive ranks used in the game.
-- Each rank defines a MMR which also can be called as Matchmaking Rating, 
-- which determines a player's skill and affects their matchmaking placement.

-- Players are assigned to a rank based on their current MMR.
-- Lowest rating of the player is called as min_mmr 
-- Highest rating of the player is called as max_mmr 

-- Rank examples includes:
--   Bronze,Silver,Gold,Platinum,Diamond,Conqueror.There are also rank
--   differentations like Gold I,Gold II and Gold II

-- The Ranks table is referenced by Player_MMR to assign players
-- to the correct competitive tier.

-- Relationships:
--   - Ranks table has 1 to Many relationship with the Player_MMR table
--   - One Rank can be assigned to many Player_MMR records.
--   - So basically One rank can have many players.

CREATE TABLE Ranks (
    rank_id INT AUTO_INCREMENT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL UNIQUE,
    min_mmr INT NOT NULL,
    max_mmr INT NOT NULL
);

-- PLAYERS TABLE
-- -----------------------------
-- Stores the information for all players registered in the game.
-- Each record represents a player profile, including their
-- username,email,region and registration date.

--   - username and email must be unique for the account integrity.
--   - region will be used to group players by their regarding regions.Regions include
--     Europe,Russia,North America and Asia.This also good for player's ping 
--     for fair matchmaking and smoother gameplay experience.
--   - registration_date is used for registration date of the player in the game.

-- Relationships:
--   - Players has One to One relationship with the Player_MMR Table.
--     Each player has exactly one current MMR record,that's why.
--   - Players has 1 to Many relationship with the Loadouts table.
--     Because a player can create multiple loadouts.
--   - Players has Many to Many relationship with the Matches via Match_Players Table
--     A player can join many matches and also a match can have many players.

CREATE TABLE Players (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    region ENUM('EU', 'RU', 'NA', 'ASIA') NOT NULL,
    registration_date DATE
);

-- PLAYER MMR TABLE
-- -----------------------------
-- The Matchmaking Rating(mmr) value represents a player's current skill level
-- and is used to determine balanced matchmaking.Higher MMR indicates a stronger
-- player.Based on this value,each player has his own rank based on their skills.

-- This table has  One to One relationship with the Players table.

-- Relationships:
--   - Player_MMR has One to One relationship with the Players table
--     player_id is the PRIMARY KEY here so each player can have only one MMR row.
--   - Player_MMR has Many to one relanionship with the Ranks table
--     Many players can share the same rank.

CREATE TABLE Player_MMR (
    player_id INT PRIMARY KEY,
    mmr INT NOT NULL,
    rank_id INT NOT NULL,
	FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE CASCADE,
    FOREIGN KEY (rank_id) REFERENCES Ranks(rank_id)
);

-- MATCHES TABLE
-- -----------------------------
-- Stores information about each match played in the game.
-- Includes the match date,selected map,game mode,status and duration.

-- The match_date value indicates when the match started.
-- The map_name identifies which map the match was played on.
-- The game_mode shows the type of the match:
--   Ranked,Tournament
-- match_status shows whether the match is created,in progress,
-- finished or cancelled.

-- This table provides foundation for the tracking history of the matches and
-- generating statistics about match activity.

-- This table is referenced by Match_Players which stores player performance for each match

-- Relationships:
--   - Matches table has many to many relationship with the Players by Match_Players table.
--     A match can include many players and a player can be in many matches.


CREATE TABLE Matches (
    match_id INT AUTO_INCREMENT PRIMARY KEY,
    match_date DATETIME NOT NULL,
    map_name VARCHAR(100),
    game_mode ENUM('RANKED', 'TOURNAMENT'),
    match_status VARCHAR(20),
    duration_seconds INT
);

-- WEAPONS TABLE
-- -----------------------------
-- Stores all weapons that players can use in the game.
-- Each weapon has a name,a weapon type such as sword,axe,shield,spear,lance,mace
-- a damage value that determines how much damage it can deal,
-- and a speed value which represents how fast the weapon can be used.

-- Different weapon types allow players to create different combat styles which leads
-- to different gameplays and loadout combinations.

-- This table is referenced by Loadout_Weapons which assigns specific weapons
-- to a player's selected loadout.
-- So basically,Weapons are assigned to player loadouts by Loadout_Weapons.

-- Relationships:
--   - Weapons table has Many to Many relationship with the Loadouts by Loadout_Weapons. 
--     A weapon can appear in many loadouts and also a loadout can contain many weapons

CREATE TABLE Weapons (
    weapon_id INT AUTO_INCREMENT PRIMARY KEY,
    weapon_name VARCHAR(100) NOT NULL UNIQUE,
    weapon_type VARCHAR(50),
    damage INT,
    speed INT
);

-- LOADOUTS TABLE
-- -----------------------------
-- Stores the equipment setups created by each player.
-- A loadout represents a custom combination of weapons that a player
-- chooses to use in the matchs.

-- The player_id field links each loadout to the player who created it.
-- The loadout_name allows players to organize different builds,
-- such as offensive,defensive or balanced setups.

-- The is_active value indicates whether the loadout is currently
-- selected or in use by the player.
-- The created_at field stores the date and time when the loadout was created.

-- This table is referenced by the Loadout_Weapons which assigns specific weapons to this loadout.

-- Relationships:
--   - Loadouts has Many to one relationship with the Players table 
--     Each loadout belongs to exactly one player.
--   - Loadouts has Many to Many relationship with the Weapons table by Loadout_Weapons 
--     Because of a loadout can include multiple weapons and a weapon can appear in many loadouts.



CREATE TABLE Loadouts (
    loadout_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    loadout_name VARCHAR(100) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME,
    FOREIGN KEY (player_id) REFERENCES Players(player_id) ON DELETE CASCADE
);

-- LOADOUT_WEAPONS TABLE
-- -----------------------------
-- Connects weapons to a specific player loadout.
-- Each record represents a single weapon assigned to one loadout.

-- The slot column indicates the role or position of the weapon
-- inside the loadout for example primary,secondary,tertiary and quaternary.A player
-- can only take 4 weapons maximum in one loadout.
-- These loadouts allows different combinations and loadout types.

-- The UNIQUE(loadout_id, slot) constraint ensures that the same slot cannot
-- be assigned more than once with the same loadout.This enforces the
-- four weapon limit and prevents duplicate slot usage.

-- This table depends on thee Loadouts table and to the Weapons table.

-- Relationships:
--   - Loadout Weapons table has Many to One relationship with the Loadouts table.
--   - Loadout_Weapons has Many to one relationship with the Weapons table also. 
--   - Together this creates Loadouts table Many to Many relationship with the Weapons table.

CREATE TABLE Loadout_Weapons (
    loadout_weapon_id INT AUTO_INCREMENT PRIMARY KEY,
    loadout_id INT NOT NULL,
    weapon_id INT NOT NULL,
    slot ENUM('PRIMARY', 'SECONDARY', 'TERTIARY', 'QUATERNARY') NOT NULL,
    UNIQUE (loadout_id, slot),
    FOREIGN KEY (loadout_id) REFERENCES Loadouts(loadout_id) ON DELETE CASCADE,
    FOREIGN KEY (weapon_id) REFERENCES Weapons(weapon_id) ON DELETE CASCADE
);

-- MATCH_PLAYERS TABLE
-- -----------------------------
-- Stores the performance statistics of each player for every match played.
-- Each record links one player to one match and includes their individual
-- performance details such as player's kills,deaths,assists,score and whether
-- the player won the match.

-- The team column indicates which team the player belonged to during the match
-- for example Team ALPHA and Team BRAVO.

-- The match_id field references the Matches table, while player_id references the Players table. 
-- This creates many to many relationship between players and matches,allowing each match 
-- to have multiple players and each player to appear in multiple matches.

-- This table is great for generating match summaries,building player's statistics and leaderboards
-- It is good for analyzing player performance across different matches.

-- This table depends on the Matches table  and to the Players table
-- because each record must belong to an existing match and an existing player.

-- Relationships:
--   - Match Players has Many to One relationship with the Matches table 
--   - Match Players has Many to One relationship Players table 
--   - So together this creates Matches table Many to many with the Players table

CREATE TABLE Match_Players (
    match_player_id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT NOT NULL,
    player_id INT NOT NULL,
    team ENUM('ALPHA','BRAVO') NOT NULL,
    kills INT,
    deaths INT,
    assists INT,
    score INT,
    is_winner BOOLEAN NOT NULL DEFAULT 0,
    FOREIGN KEY (match_id) REFERENCES Matches(match_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);
