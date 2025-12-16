-- Add Loadout Procedure

DELIMITER $$

CREATE PROCEDURE Add_Loadout (
    IN player_player_id INT,
    IN player_loadout_name VARCHAR(100),
    IN loadout_is_active INT,
    IN loadout_created_at DATETIME
)
BEGIN
    INSERT INTO Loadouts (player_id, loadout_name, is_active, created_at)
    VALUES (player_player_id, player_loadout_name, loadout_is_active, loadout_created_at);

    SELECT 'Loadout has been successfully added.' AS result_message;
END $$

DELIMITER ;

-- Calling the Add Loadout Procedure
CALL Add_Loadout(1,'Defensive Loadout',0,'2025-01-16 10:15:00');

-- Delete Loadout Procedure
DELIMITER $$

CREATE PROCEDURE Delete_Loadout (
    IN player_loadout_id INT
)
BEGIN
    -- First delete every weapon that belongs to the loadout
    DELETE FROM Loadout_Weapons
    WHERE loadout_id = player_loadout_id;

    -- Then delete the loadout
    DELETE FROM Loadouts
    WHERE loadout_id = player_loadout_id;

    SELECT CONCAT('Loadout ',player_loadout_id,' and its weapons have been deleted.') AS message;
END $$

DELIMITER ;

-- Calling Delete Loadout Procedure
CALL Delete_Loadout(3);

