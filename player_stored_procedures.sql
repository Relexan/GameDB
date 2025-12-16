-- Add_Player PROCEDURE
-- -------------------------
-- Basically this procedure just adds a player to the Players table,and checks if the player mmr is positive,
-- checks if region is invalid and also checks the player registration date if it is not in the future.If there is mistakes in the addition,
-- it shows the errors.player_id is being set in the Players table by the auto increment feature.

DELIMITER $$

CREATE PROCEDURE Add_Player (
    IN player_username VARCHAR(50),
    IN player_email VARCHAR(100),
    IN player_region ENUM('EU','RU','NA','ASIA'),
    IN player_mmr INT,
    IN player_registration_date DATE,
    IN player_rank_id INT
)
BEGIN
    DECLARE rank_valid INT;
    DECLARE username_count INT;
    DECLARE email_count INT;
    DECLARE new_player_id INT;

    IF player_mmr < 0 THEN
        SELECT 'MMR must be positive.' AS result_message;

    ELSEIF player_region NOT IN ('EU','RU','NA','ASIA') THEN
        SELECT 'Region is invalid. Allowed regions are: EU, RU, NA and ASIA.' AS result_message;

    ELSEIF player_registration_date > CURDATE() THEN
        SELECT 'Registration date cannot be in the future.' AS result_message;

    ELSE
    
        SELECT COUNT(*) INTO username_count
        FROM Players
        WHERE username = player_username;

        SELECT COUNT(*) INTO email_count
        FROM Players
        WHERE email = player_email;

        IF username_count > 0 THEN
            SELECT 'Username already exists.' AS result_message;

        ELSEIF email_count > 0 THEN
            SELECT 'Email already exists.' AS result_message;

        ELSE

            SELECT COUNT(*) INTO rank_valid
            FROM Ranks
            WHERE rank_id = player_rank_id;

            IF rank_valid = 0 THEN
                SELECT 'Invalid rank_id. Rank does not exist.' AS result_message;

            ELSE
			
                INSERT INTO Players (username, email, region, registration_date)
                VALUES (player_username, player_email, player_region, player_registration_date);

                SET new_player_id = LAST_INSERT_ID();

                INSERT INTO Player_MMR (player_id, mmr, rank_id)
                VALUES (new_player_id, player_mmr, player_rank_id);

                SELECT CONCAT('Player added successfully. player_id = ', new_player_id) AS result_message;
            END IF;
        END IF;
    END IF;
END $$

DELIMITER ;


-- Calls to Add Player Procedure to add player to the table
CALL Add_Player('AstraNova','astranova@mail.com','EU',1450,'2024-01-02',2);


-- Update Player Procedure for the Player's information update
DELIMITER $$

CREATE PROCEDURE Update_Player(
    IN input_player_id INT,
    IN new_email VARCHAR(100),
    IN new_region ENUM('EU','RU','NA','ASIA')
)
BEGIN
    UPDATE Players
    SET email = new_email,region = new_region
    WHERE player_id = input_player_id;
END $$

DELIMITER ;

-- Calls to Update Player's information
CALL Update_Player(1, 'newmail@mail.com', 'EU');