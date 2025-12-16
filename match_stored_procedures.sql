-- Add Match Procedure

DELIMITER $$

CREATE PROCEDURE Add_Match (
    IN match_match_date DATETIME,
    IN match_map_name VARCHAR(100),
    IN match_game_mode ENUM('RANKED','TOURNAMENT'),
    IN match_match_status VARCHAR(20),
    IN match_duration_seconds INT
)
BEGIN
    -- Duration seconds cant be negative
    IF match_duration_seconds < 0 THEN
        SELECT 'Duration cannot be negative.' AS result_message;

    -- Match date cant be in the future
    ELSEIF match_match_date > NOW() THEN
        SELECT 'Match date cannot be in the future.' AS result_message;

    -- Game mode must be either Ranked or Tournament because our matchmaking system has only Ranked and Tournament game modes
    ELSEIF match_game_mode NOT IN ('RANKED', 'TOURNAMENT') THEN
        SELECT 'Game mode must be RANKED or TOURNAMENT.' AS result_message;

    ELSE
        INSERT INTO Matches (match_date, map_name, game_mode, match_status, duration_seconds)
        VALUES (match_match_date, match_map_name, match_game_mode, match_match_status, match_duration_seconds);

        SELECT CONCAT('Match inserted successfully with ID = ', LAST_INSERT_ID()) AS result_message;
    END IF;
END $$

DELIMITER ;

-- Cancelling the Match Procedure

DELIMITER $$

CREATE PROCEDURE Cancel_Match (
    IN player_match_id INT
)
BEGIN
    DECLARE match_exists INT;

    -- Check if match really exists
    SELECT COUNT(*) INTO match_exists
    FROM Matches
    WHERE match_id = player_match_id;

    IF match_exists = 0 THEN
        SELECT 'Match not found.' AS result_message;
    ELSE
        UPDATE Matches
        SET match_status = 'CANCELLED'
        WHERE match_id = player_match_id;

        SELECT CONCAT('Match ', player_match_id, ' has been cancelled successfully.') AS result_message;
    END IF;

END $$

DELIMITER ;



