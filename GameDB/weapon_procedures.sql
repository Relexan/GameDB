-- Add Weapon Procedure

DELIMITER $$

CREATE PROCEDURE Add_Weapon(
    IN the_weapon_name VARCHAR(100),
    IN the_weapon_type VARCHAR(50),
    IN the_damage INT,
    IN the_speed INT
)
BEGIN
    DECLARE name_count INT DEFAULT 0;

    -- Name cannt be empty
    IF the_weapon_name IS NULL  THEN
        SELECT 'Weapon name cant be empty' AS result_message;

    -- Damage cant be negative
    ELSEIF the_damage < 0 THEN
        SELECT 'Damage must be positive.' AS result_message;

    -- Speed cant be negative
    ELSEIF the_speed < 0 THEN
        SELECT 'Speed must be positive.' AS result_message;

    ELSE
        -- Checks the duplicate weapon name
        SELECT COUNT(*) INTO name_count
        FROM Weapons
        WHERE weapon_name = the_weapon_name;

        IF name_count > 0 THEN
            SELECT CONCAT('Weapon ',the_weapon_name, ' already exists.') AS result_message;
        ELSE
            
            INSERT INTO Weapons (weapon_name, weapon_type, damage, speed)
            VALUES (the_weapon_name, the_weapon_type, the_damage, the_speed);

            SELECT CONCAT('Weapon successfully inserted with ID = ', LAST_INSERT_ID()) 
                AS result_message;
        END IF;
    END IF;

END $$

DELIMITER ;

-- Delete Weapon Procedure

DELIMITER $$

CREATE PROCEDURE Delete_Weapon (
    IN weapon_weapon_id INT
)
BEGIN
    DECLARE is_weapon_existing INT DEFAULT 0;

    -- Checks if the weapon existing or not
    SELECT COUNT(*) INTO is_weapon_existing
    FROM Weapons
    WHERE weapon_id = weapon_weapon_id;

    IF is_weapon_existing = 0 THEN
        SELECT 'Weapon isnt found.' AS result_message;

    ELSE
        
        DELETE FROM Weapons
        WHERE weapon_id = weapon_weapon_id;

        SELECT CONCAT('Weapon ',weapon_weapon_id,' has been deleted successfully.') AS result_message;

    END IF;

END $$

DELIMITER ;