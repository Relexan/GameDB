-- Procedures to get data

-- This Procedure Gets Players with their MMR and Ranks
DELIMITER $$

CREATE PROCEDURE Get_Players_With_MMR_And_Rank()
BEGIN
    SELECT 
        player.player_id,
        player.username,
        player.region,
        player.registration_date,
        player_rating.mmr,
        rank_information.rank_name
    FROM Players AS player
    JOIN Player_MMR AS player_rating
	ON player.player_id = player_rating.player_id
    JOIN Ranks AS rank_information 
	ON player_rating.rank_id = rank_information.rank_id
    ORDER BY player.player_id ASC;
END $$

DELIMITER ;

-- Calls the Get_Players_With_MMR_And_Rank Procedure
CALL Get_Players_With_MMR_And_Rank();


DELIMITER $$

CREATE PROCEDURE Get_Players_By_Rank(IN input_rank_id INT)
BEGIN
    SELECT
        player.player_id,
        player.username,
        player.region,
        player.registration_date,
        player_rating.mmr,
        rank_information.rank_name
    FROM Players AS player
    JOIN Player_MMR AS player_rating
	ON player.player_id = player_rating.player_id
    JOIN Ranks AS rank_information
	ON player_rating.rank_id = rank_information.rank_id
    WHERE player_rating.rank_id = input_rank_id
    ORDER BY player_rating.mmr DESC;
END $$

DELIMITER ;

-- Calls for getting players with distinct rank 
-- For example here only players with Conqueror III rank has been shown
CALL Get_Players_By_Rank(18); 

-- Procedure for Getting Matches
DELIMITER $$

CREATE PROCEDURE Get_Matches()
BEGIN
    SELECT
        match_id,
        match_date,
        map_name,
        game_mode,
        match_status
    FROM Matches;
END $$

DELIMITER ;

-- Calls the Get_Matches Procedure
Call Get_Matches();

-- Gets the players with no wins
DELIMITER $$

CREATE PROCEDURE Get_Players_With_No_Wins()
BEGIN
    SELECT
        Players.player_id,
        Players.username,
        SUM(Match_Players.is_winner = 1) AS total_wins
    FROM Players
    LEFT JOIN Match_Players ON Players.player_id = Match_Players.player_id
    GROUP BY Players.player_id, Players.username
    HAVING total_wins = 0;
END $$

DELIMITER ;

-- Calls Get Players With No Wins to show players without any win
CALL Get_Players_With_No_Wins();

-- Procedure for Player's Getting Current Stats

DELIMITER $$

CREATE PROCEDURE Get_Player_Current_Stats(IN input_player_id INT)
BEGIN
    SELECT
        player.username,
        player.region,
        player_mmr.mmr,
        player_rank.rank_name,
        COUNT(match_player.match_id) AS total_matches,
        SUM(match_player.is_winner = 1) AS total_wins,
        SUM(match_player.is_winner = 0) AS total_losses
    FROM Players AS player
    JOIN Player_MMR AS player_mmr
	ON player.player_id = player_mmr.player_id
    JOIN Ranks AS player_rank
	ON player_mmr.rank_id = player_rank.rank_id
    LEFT JOIN Match_Players AS match_player
	ON player.player_id = match_player.player_id
    WHERE player.player_id = input_player_id
    GROUP BY player.player_id;
END $$

DELIMITER ;

-- Calling Get_Player_Current_Stats Procedure
CALL Get_Player_Current_Stats(2);

-- Getting Player's Match History Procedure
DELIMITER $$

CREATE PROCEDURE Get_Player_Match_History(IN input_player_id INT)
BEGIN
    SELECT 
        match_player.match_id,
        match_information.match_date,
        match_information.map_name,
        match_player.kills,
        match_player.deaths,
        match_player.assists,
        match_player.is_winner
    FROM Match_Players AS match_player
    JOIN Matches AS match_information
	ON match_player.match_id = match_information.match_id
    WHERE match_player.player_id = input_player_id;
END $$

DELIMITER ;

-- Calls for Getting Player's Match History
CALL Get_Player_Match_History(1);

-- Getting Player's Winrate Procedure

DELIMITER $$

CREATE PROCEDURE Get_Player_WinRate(IN input_player_id INT)
BEGIN
    SELECT player.username,
        SUM(match_player.is_winner = 1) AS total_wins,
        SUM(match_player.is_winner = 0) AS total_losses,
        ROUND((SUM(match_player.is_winner = 1) / COUNT(match_player.match_id)) * 100,1) AS winrate
    FROM Players AS player
    LEFT JOIN Match_Players AS match_player
	ON player.player_id = match_player.player_id
    WHERE player.player_id = input_player_id
    GROUP BY player.player_id;
END $$

DELIMITER ;

-- Calls Get_Player_Winrate with Player's ID
CALL Get_Player_WinRate(2);

-- Gets Top Weapons being used in the loadouts
DELIMITER $$

CREATE PROCEDURE Get_Top_Weapons()
BEGIN
    SELECT Weapons.weapon_name, COUNT(*) AS used_count
    FROM Loadout_Weapons
    JOIN Weapons ON Loadout_Weapons.weapon_id = Weapons.weapon_id
    GROUP BY Weapons.weapon_name
    ORDER BY used_count DESC;
END $$

DELIMITER ;

-- Calls Get_Top_Weapons to show most used weapons by their count 
CALL Get_Top_Weapons();

-- Gets Top Players with the total kills
DELIMITER $$

CREATE PROCEDURE Get_Top_Players_By_Total_Kills()
BEGIN
    SELECT 
        Players.username,
        SUM(Match_Players.kills) AS total_kills
    FROM Match_Players
    JOIN Players ON Match_Players.player_id = Players.player_id
    GROUP BY Players.username
    ORDER BY total_kills DESC;
END $$

DELIMITER ;

-- Calls Get Top Players by total kills procedure to show total kills by players
CALL Get_Top_Players_By_Total_Kills();