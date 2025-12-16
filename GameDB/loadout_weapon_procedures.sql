-- Adding of the Loadout Weapon Procedure

DELIMITER $$

CREATE PROCEDURE Add_Loadout_Weapon (
    IN player_loadout_id INT,
    IN player_weapon_id INT,
    IN player_slot ENUM('PRIMARY', 'SECONDARY', 'TERTIARY', 'QUATERNARY')
)
BEGIN
    DECLARE is_loadout_existing INT DEFAULT 0;
    DECLARE is_weapon_existing INT DEFAULT 0;
    DECLARE is_slot_existing INT DEFAULT 0;

	SELECT COUNT(*) INTO is_loadout_existing 
    FROM Loadouts 
    WHERE loadout_id = player_loadout_id;

    SELECT COUNT(*) INTO is_weapon_existing 
    FROM Weapons 
    WHERE weapon_id = player_weapon_id;

    SELECT COUNT(*) INTO is_slot_existing 
    FROM Loadout_Weapons
    WHERE loadout_id = player_loadout_id 
	AND slot = player_slot;

    CASE
        WHEN is_loadout_existing = 0 THEN
            SELECT 'This loadout doesnt exist.' AS message;

        WHEN is_weapon_existing = 0 THEN
            SELECT 'This weapon dont exist.' AS message;

        WHEN is_slot_existing > 0 THEN
            SELECT CONCAT('The slot ', player_slot, ' is already used in this loadout.') AS message;

        ELSE
            INSERT INTO Loadout_Weapons (loadout_id, weapon_id, slot)
            VALUES (player_loadout_id, player_weapon_id, player_slot);

            SELECT 'Weapon has been successfully added to the loadout.' AS message;
    END CASE;

END $$

DELIMITER ;

-- Deletion of thhe Weapon in the Loadout Procedure

DELIMITER $$

CREATE PROCEDURE Delete_Loadout_Weapon (
    IN player_loadout_weapon_id INT
)
BEGIN
    DECLARE is_entry_existing INT DEFAULT 0;

    SELECT COUNT(*) INTO is_entry_existing
    FROM Loadout_Weapons
    WHERE loadout_weapon_id = player_loadout_weapon_id;

    CASE
        WHEN is_entry_existing = 0 THEN
            SELECT 'This weapon entry doesnt exist.' AS message;

        ELSE
            DELETE FROM Loadout_Weapons
            WHERE loadout_weapon_id = player_loadout_weapon_id;

            SELECT 'Weapon successfully removed from the loadout.' AS message;
    END CASE;

END $$

DELIMITER ;