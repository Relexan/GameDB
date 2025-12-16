-- CHECKINGS OF THE EDGE CASES
-- ----------------------------
-- Checks for duplicate weapon slots with the same loadout.If any result is being returned, then it means that the same slot
-- has been assigned more than once in a single loadout,which violates my intended loadout design.
SELECT loadout_id, slot, COUNT(*) AS count
FROM Loadout_Weapons
GROUP BY loadout_id, slot
HAVING count > 1;

-- Checks for matches that have no players assigned to the match.If any result is being returned, it indicates matches that
-- don't contain any player participation records.
SELECT Matches.match_id, COUNT(Match_Players.player_id) AS player_count
FROM Matches
LEFT JOIN Match_Players ON Matches.match_id = Match_Players.match_id
GROUP BY Matches.match_id
HAVING player_count = 0;

-- Queries

SELECT * From Matches;
SELECT * FROM Ranks;
SELECT COUNT(*) FROM Players;
SELECT * FROM Players;
SELECT * FROM Match_Players;
SELECT * FROM Loadouts;
SELECT * FROM Loadout_Weapons;
SELECT * FROM Weapons;



SELECT player_id, mmr FROM Player_MMR ORDER BY player_id;
SELECT * FROM Player_MMR;

UPDATE Players
SET region = 'EU'
WHERE player_id = 5;

SHOW TRIGGERS;

DROP TABLE Ranks;

TRUNCATE TABLE Ranks;

ALTER TABLE Loadouts AUTO_INCREMENT = 1;
ALTER TABLE Ranks ADD UNIQUE (rank_name);
ALTER TABLE Ranks AUTO_INCREMENT = 1;
ALTER TABLE Weapons;

SHOW CREATE TABLE Loadouts;
SHOW CREATE TABLE Match_Players;
SHOW CREATE TABLE Queue_Entries;

TRUNCATE Loadout_Weapons;
TRUNCATE Loadouts;

SHOW CREATE TABLE Player_MMR;
SHOW CREATE TABLE Loadouts;
SHOW CREATE TABLE Loadout_Weapons;

SHOW CREATE TABLE Match_Players;

DROP TRIGGER IF EXISTS Finalize_Match;
