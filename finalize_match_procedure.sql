-- Finalize Match Procedure
-- This procedure makes a match basically completed.
-- When the match_status is updated to the 'COMPLETED', the Finalize Match Trigger is automatically
-- triggered to handle MMR updates for the players in that match.

 DELIMITER $$

CREATE PROCEDURE Finalize_Match (IN player_match_id INT)
BEGIN
    UPDATE Matches
    SET match_status = 'COMPLETED'
    WHERE match_id = player_match_id;
END $$

DELIMITER ;

-- Calling the Procedure Finalize_Match
CALL Finalize_Match(5);

