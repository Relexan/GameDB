-- Match Inserts

-- Calling Procedure Inserts Example
CALL Add_Match('2025-08-01 14:20:00', 'Nebula Outpost', 'RANKED', 'COMPLETED', 1420);
CALL Add_Match('2025-08-02 16:45:00', 'Crystal Ruins', 'RANKED', 'COMPLETED', 1650);
CALL Add_Match('2025-08-03 19:10:00', 'Solaris Dunes', 'TOURNAMENT', 'COMPLETED', 1980);
CALL Add_Match('2025-08-04 13:40:00', 'Frostbite Tundra', 'RANKED', 'COMPLETED', 1220);
CALL Add_Match('2025-08-05 18:05:00', 'Shadow Forest', 'TOURNAMENT', 'COMPLETED', 2100);

-- Same dataset,being inserted as a bulk inserts by using INSERT INTO
INSERT INTO Matches (match_date, map_name, match_type, match_status, lobby_mmr) VALUES
('2025-08-01 14:20:00', 'Nebula Outpost', 'RANKED', 'COMPLETED', 1420),
('2025-08-02 16:45:00', 'Crystal Ruins', 'RANKED', 'COMPLETED', 1650),
('2025-08-03 19:10:00', 'Solaris Dunes', 'TOURNAMENT', 'COMPLETED', 1980),
('2025-08-04 13:40:00', 'Frostbite Tundra', 'RANKED', 'COMPLETED', 1220),
('2025-08-05 18:05:00', 'Shadow Forest', 'TOURNAMENT', 'COMPLETED', 2100);

CALL Add_Match('2025-08-06 17:10:00', 'Lunar Citadel', 'RANKED', 'COMPLETED', 1750);
CALL Add_Match('2025-08-07 15:35:00', 'Ashen Valley', 'RANKED', 'COMPLETED', 1600);
CALL Add_Match('2025-08-08 21:00:00', 'Obsidian Stronghold', 'TOURNAMENT', 'COMPLETED', 2150);
CALL Add_Match('2025-08-09 18:20:00', 'Verdant Wilds', 'RANKED', 'COMPLETED', 1550);
CALL Add_Match('2025-08-10 20:40:00', 'Ironclad Arena', 'RANKED', 'COMPLETED', 1890);

CALL Add_Match('2025-08-11 12:50:00', 'Stormcall Ridge', 'TOURNAMENT', 'COMPLETED', 2180);
CALL Add_Match('2025-08-12 19:30:00', 'Nebula Outpost', 'RANKED', 'COMPLETED', 1710);
CALL Add_Match('2025-08-13 18:45:00', 'Crystal Ruins', 'RANKED', 'COMPLETED', 1630);
CALL Add_Match('2025-08-14 14:10:00', 'Solaris Dunes', 'TOURNAMENT', 'COMPLETED', 2010);
CALL Add_Match('2025-08-15 16:55:00', 'Frostbite Tundra', 'RANKED', 'COMPLETED', 1470);

CALL Add_Match('2025-08-16 17:25:00', 'Shadow Forest', 'TOURNAMENT', 'COMPLETED', 1880);
CALL Add_Match('2025-08-17 20:40:00', 'Lunar Citadel', 'RANKED', 'COMPLETED', 1780);
CALL Add_Match('2025-08-18 18:30:00', 'Ashen Valley', 'RANKED', 'COMPLETED', 1660);
CALL Add_Match('2025-08-19 22:00:00', 'Obsidian Stronghold', 'TOURNAMENT', 'COMPLETED', 2150);
CALL Add_Match('2025-08-20 15:10:00', 'Verdant Wilds', 'RANKED', 'COMPLETED', 1500);


