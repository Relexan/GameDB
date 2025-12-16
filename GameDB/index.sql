-- Creating indexes for faster search

CREATE INDEX index_match_players_match_id ON Match_Players(match_id);
CREATE INDEX index_match_players_player_id ON Match_Players(player_id);
CREATE INDEX index_match_players_match_team ON Match_Players(match_id, team);
CREATE INDEX index_loadouts_player_active ON Loadouts(player_id, is_active);
CREATE INDEX index_loadout_weapons_weapon_id ON Loadout_Weapons(weapon_id);
CREATE INDEX index_player_mmr_rank_id ON Player_MMR(rank_id);
CREATE INDEX index_matches_match_date ON Matches(match_date);
CREATE INDEX index_matches_map_name ON Matches(map_name);
CREATE INDEX index_matches_game_mode ON Matches(game_mode);
CREATE INDEX index_players_region ON Players(region);

