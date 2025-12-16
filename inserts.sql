-- Rank Inserts
DELETE FROM Ranks;
SET sql_safe_updates = 0;

CALL Add_Rank('Bronze I',0,199);
CALL Add_Rank('Bronze II',200,399);
CALL Add_Rank('Bronze III',400,599);

CALL Add_Rank('Silver I',600,799);
CALL Add_Rank('Silver II',800,999);
CALL Add_Rank('Silver III',1000,1199);

CALL Add_Rank('Gold I',1200,1299);
CALL Add_Rank('Gold II',1300,1399);
CALL Add_Rank('Gold III',1400,1499);

CALL Add_Rank('Platinum I',1500,1599);
CALL Add_Rank('Platinum II',1600,1699);
CALL Add_Rank('Platinum III',1700,1799);

CALL Add_Rank('Diamond I',1800,1899);
CALL Add_Rank('Diamond II',1900,1999);
CALL Add_Rank('Diamond III',2000,2199);

CALL Add_Rank('Conqueror I',2200,2399);
CALL Add_Rank('Conqueror II',2400,2599);
CALL Add_Rank('Conqueror III',2600,2799);

