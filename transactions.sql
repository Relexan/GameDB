-- Deletion of the Player by the stored procedure with transaction

DELIMITER $$

CREATE PROCEDURE Delete_Player (
    IN player_player_id INT
)
BEGIN
    DECLARE is_player_existing INT;
    DECLARE rows_affected INT DEFAULT 0;

    SELECT COUNT(*) INTO is_player_existing
    FROM Players
    WHERE player_id = player_player_id;

    IF is_player_existing = 0 THEN
        SELECT 'Player isnt found.' AS result_message;
	ELSE
        START TRANSACTION;
		
        -- Delete player's match entries (no ON DELETE CASCADE on Match_Players.player_id,so its needed here)
        DELETE FROM Match_Players
        WHERE player_id = player_player_id;
		
        -- Delete the player (this operation automatically deletes related records in the Loadouts,
        -- Loadout_Weapons and Player_MMR tables by ON DELETE CASCADE)
        DELETE FROM Players
        WHERE player_id = player_player_id;
		
        SET rows_affected = ROW_COUNT();

        IF rows_affected = 0 THEN
            ROLLBACK;
            SELECT 'An error occurred while deleting the player.Therefore Transaction rolled back.' AS result_message;
        ELSE
            COMMIT;
            SELECT CONCAT('Player deleted successfully with the id = ',player_player_id) AS result_message;
        END IF;
    END IF;
END $$

DELIMITER ;


-- SETTING ACTIVE LOADOUT TRANSACTION

DELIMITER $$

CREATE PROCEDURE Set_Active_Loadout (
    IN player_player_id INT,
    IN player_loadout_id INT
)
BEGIN
    DECLARE rows_affected INT DEFAULT 0;

    START TRANSACTION;

    -- Deactivate all loadouts of the player
    UPDATE Loadouts
    SET is_active = 0
    WHERE player_id = player_player_id;

    -- Activates the selected loadout
    UPDATE Loadouts
    SET is_active = 1
    WHERE loadout_id = player_loadout_id
	AND player_id = player_player_id;

    SET rows_affected = ROW_COUNT();

    -- If no loadout was activated just rollback
    IF rows_affected = 0 THEN
        ROLLBACK;
        SELECT 'An error occurred while setting the active loadout.The Selected loadout couldnt be activated.Transaction rolled back safely.' AS result_message;
    ELSE
        COMMIT;
        SELECT CONCAT('Loadout ',player_loadout_id,' has been successfully set as active for player ',player_player_id) AS result_message;
    END IF;

END $$

DELIMITER ;




