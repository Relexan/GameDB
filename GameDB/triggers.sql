-- Finalize Match Trigger
DELIMITER $$

CREATE TRIGGER Finalize_Match
AFTER UPDATE ON Matches
FOR EACH ROW
BEGIN

    IF NEW.match_status = 'COMPLETED'
       AND OLD.match_status <> 'COMPLETED' THEN

        UPDATE Player_MMR AS player_stats
        JOIN Match_Players AS match_row
		ON player_stats.player_id = match_row.player_id
        SET player_stats.mmr = player_stats.mmr + IF(match_row.is_winner = 1, 25, -15)
        WHERE match_row.match_id = NEW.match_id;

    END IF;
END $$

DELIMITER ;

-- Trigger for assigning correct rank when mmr is being added
DELIMITER $$
CREATE TRIGGER Assign_Correct_Rank_When_Mmr_Is_Being_Added
BEFORE INSERT ON Player_MMR
FOR EACH ROW
BEGIN
    SET NEW.rank_id = (
		SELECT rank_id
        FROM Ranks
        WHERE NEW.mmr BETWEEN min_mmr AND max_mmr
        LIMIT 1
    );
END $$

DELIMITER ;

-- Trigger for Updating the Rank when a player's MMR changes.
DELIMITER $$

CREATE TRIGGER Update_Rank_When_Mmr_Changes
BEFORE UPDATE ON Player_MMR
FOR EACH ROW
BEGIN
    IF NEW.mmr <> OLD.mmr THEN
        SET NEW.rank_id = (
            SELECT rank_id
            FROM Ranks
            WHERE NEW.mmr BETWEEN min_mmr AND max_mmr
            LIMIT 1
        );
    END IF;
END $$

DELIMITER ;

