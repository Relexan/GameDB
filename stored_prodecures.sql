-- Adding Match Procedure

DELIMITER $$

CREATE PROCEDURE Add_Match_Player (
    IN player_match_id INT,
    IN player_player_id INT,
    IN player_team ENUM('ALPHA','BRAVO'),
    IN player_kills INT,
    IN player_deaths INT,
    IN player_assists INT,
    IN player_score INT,
    IN player_is_winner INT
)
BEGIN
    DECLARE team_player_count INT;
    DECLARE new_mmr INT;
    DECLARE average_mmr INT;
    DECLARE mmr_limit INT DEFAULT 200;

    -- New player's MMR
    SELECT mmr INTO new_mmr
    FROM Player_MMR
    WHERE player_id = player_player_id;

    -- Average MMR of players already in this match
    SELECT AVG(rating.mmr) INTO average_mmr
    FROM Match_Players AS match_player
    JOIN Player_MMR AS rating ON rating.player_id = match_player.player_id
	WHERE match_player.match_id = player_match_id;

    -- Team size
    SELECT COUNT(*) INTO team_player_count
    FROM Match_Players
    WHERE match_id = player_match_id
	AND team = player_team;

    CASE
        -- Checking the mmr if there are players in the match, compare to average
        WHEN average_mmr IS NOT NULL
		AND ABS(new_mmr - average_mmr) > mmr_limit THEN
		SELECT CONCAT('Player MMR ',new_mmr,' is too far from lobby average ',average_mmr,' limit is ',mmr_limit) AS message;

        -- Team size limit
        WHEN team_player_count >= 6 THEN
		SELECT CONCAT('Team ',player_team, ' already has 6 players.') AS message;

        ELSE
            INSERT INTO Match_Players (match_id, player_id, team, kills, deaths, assists, score, is_winner) 
            VALUES (player_match_id, player_player_id, player_team,player_kills, player_deaths, player_assists, player_score, player_is_winner);

            SELECT 'Player has been added to the match.' AS message;
    END CASE;

END $$
DELIMITER ;
