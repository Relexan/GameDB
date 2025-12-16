-- ADDING RANK PROCEDURE.
-- rank_id is being set in the Ranks table by the auto increment feature.

DELIMITER $$

CREATE PROCEDURE Add_Rank (
    IN rank_rank_name VARCHAR(50),
    IN rank_min_mmr INT,
    IN rank_max_mmr INT
)
BEGIN
    DECLARE name_count INT;

    -- MMR should be positive
    IF rank_min_mmr < 0 OR rank_max_mmr < 0 THEN
        SELECT 'MMR values must be positive.' AS result_message;

    -- Maximum mmr should be bigger than the minimum mmr
    ELSEIF rank_max_mmr <= rank_min_mmr THEN
        SELECT 'Maximum MMR must be greater than the Minimum MMR.' AS result_message;

    ELSE
        
        SELECT COUNT(*) INTO name_count
        FROM Ranks
        WHERE rank_name = rank_rank_name;

        IF name_count > 0 THEN
            SELECT 'Rank name already exists.' AS result_message;
        ELSE
            INSERT INTO Ranks (rank_name, min_mmr, max_mmr)
            VALUES (rank_rank_name, rank_min_mmr, rank_max_mmr);

            SELECT CONCAT('Rank inserted successfully with ID = ', LAST_INSERT_ID()) AS result_message;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Calls Add Rank Procedure to add rank
CALL Add_Rank('Gold I',1200,1299);

-- DELETE RANK PROCEDURE
DELIMITER $$

CREATE PROCEDURE Delete_Rank (
    IN rank_rank_id INT
)
BEGIN
    DECLARE is_rank_existing INT;
    DECLARE in_use_count INT;

    -- Check if rank exists
    SELECT COUNT(*) INTO is_rank_existing
    FROM Ranks
    WHERE rank_id = rank_rank_id;

    IF is_rank_existing = 0 THEN
        SELECT 'Rank not found.' AS result_message;

    ELSE
        -- Check if this rank is still used by any player
        SELECT COUNT(*) INTO in_use_count
        FROM Player_MMR
        WHERE rank_id = rank_rank_id;

        IF in_use_count > 0 THEN
            SELECT 'This rank cannt be deleted because it is still assigned to players.' AS result_message;
        ELSE
            DELETE FROM Ranks
            WHERE rank_id = rank_rank_id;

            SELECT CONCAT('Rank ', rank_rank_id,' has been deleted successfully.') AS result_message;
        END IF;
    END IF;

END $$
DELIMITER ;

-- Calls Delete_Rank Procedure to delete rank
CALL Delete_Rank(3);

-- UPDATING RANK PROCEDURE

DELIMITER $$

CREATE PROCEDURE Update_Rank (
    IN rank_rank_id INT,
    IN rank_rank_name VARCHAR(50),
    IN rank_min_mmr INT,
    IN rank_max_mmr INT
)
BEGIN
    DECLARE is_rank_existing INT;
    DECLARE name_count INT;

    
    SELECT COUNT(*) INTO is_rank_existing
    FROM Ranks
    WHERE rank_id = rank_rank_id;

    IF is_rank_existing = 0 THEN
        SELECT 'Rank not found.' AS result_message;

    ELSEIF rank_min_mmr < 0 OR rank_max_mmr < 0 THEN
        SELECT 'MMR values must be positive.' AS result_message;

    ELSEIF rank_max_mmr <= rank_min_mmr THEN
        SELECT 'Maximum MMR must be greater than the Minimum MMR.' AS result_message;

    ELSE
	
        SELECT COUNT(*) INTO name_count
        FROM Ranks
        WHERE rank_name = rank_rank_name
		AND rank_id <> rank_rank_id;

        IF name_count > 0 THEN
            SELECT 'Another rank with the same name already exists.' AS result_message;
        ELSE
            UPDATE Ranks
            SET rank_name = rank_rank_name,
                min_mmr   = rank_min_mmr,
                max_mmr   = rank_max_mmr
            WHERE rank_id = rank_rank_id;

            SELECT CONCAT('Rank ',rank_rank_id,' has been updated successfully.') AS result_message;
        END IF;
    END IF;
END $$

DELIMITER ;

-- Calls Update_Rank Procedure to Update Rank
CALL Update_Rank(2, 'Gold II', 1500, 1999);