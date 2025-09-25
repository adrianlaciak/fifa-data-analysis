USE Fifa;

-- Create a table to store unique players
CREATE TABLE players(
	player_id INT PRIMARY KEY,
	name NVARCHAR(50)
);

-- Create a table to store player data per FIFA edition
CREATE TABLE fifa_players(
	fifa_player_id INT IDENTITY(1,1) PRIMARY KEY,
	fifa INT,
	player_id INT FOREIGN KEY REFERENCES players(player_id),
	age INT,
	nationality NVARCHAR(50),
	club NVARCHAR(50)
);

-- Create a table to store player value and wage
CREATE TABLE value(
	value_id INT IDENTITY(1,1) PRIMARY KEY,
	fifa_player_id INT FOREIGN KEY REFERENCES fifa_players(fifa_player_id),
	value FLOAT,
	wage FLOAT
);

-- Create a table to store player statistics
CREATE TABLE stat(
	statistics_id INT IDENTITY(1,1) PRIMARY KEY,
	fifa_player_id INT FOREIGN KEY REFERENCES fifa_players(fifa_player_id),
	overall FLOAT,
	pace FLOAT,
	shooting FLOAT,
	passing FLOAT,
	dribbling FLOAT,
	defending FLOAT,
	physical FLOAT,
	potential FLOAT,
	best_position NVARCHAR(25),
	preferred_foot NVARCHAR(25),
	weak_foot FLOAT,
	skill_moves FLOAT
);

-- Create a table to store photo, flag, and club logo URLs
CREATE TABLE photo(
	photo_id INT IDENTITY(1,1) PRIMARY KEY,
	fifa_player_id INT FOREIGN KEY REFERENCES fifa_players(fifa_player_id),
	photo NVARCHAR(MAX),
	flag NVARCHAR(MAX),
	club_logo NVARCHAR(MAX)
);

-- Insert distinct players (combine IDs and names across all FIFA datasets)
WITH all_fifa AS (
    SELECT 
        LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))) AS name,
        ID AS player_id
    FROM FIFA17_official_data
    UNION ALL
    SELECT LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))), ID
    FROM FIFA18_official_data
    UNION ALL
    SELECT LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))), ID
    FROM FIFA19_official_data
    UNION ALL
    SELECT LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))), ID
    FROM FIFA20_official_data
    UNION ALL
    SELECT LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))), ID
    FROM FIFA21_official_data
    UNION ALL
    SELECT LTRIM(SUBSTRING(Name, PATINDEX('%[A-Za-z]%', Name), LEN(Name))), ID
    FROM FIFA22_official_data
)
INSERT INTO players(name, player_id)
SELECT name, player_id
FROM (
    SELECT 
        name,
        player_id,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY name) AS rn
    FROM all_fifa
) t
WHERE rn = 1;

-- Insert player data (age, nationality, club) for each FIFA edition
INSERT INTO fifa_players(fifa, player_id, age, nationality, club)
SELECT
	17, ID, Age, Nationality, Club
FROM FIFA17_official_data
UNION
SELECT
	18, ID, Age, Nationality, Club
FROM FIFA18_official_data
UNION
SELECT
	19, ID, Age, Nationality, Club
FROM FIFA19_official_data
UNION
SELECT
	20, ID, Age, Nationality, Club
FROM FIFA20_official_data
UNION
SELECT
	21, ID, Age, Nationality, Club
FROM FIFA21_official_data
UNION
SELECT
	22, ID, Age, Nationality, Club
FROM FIFA22_official_data;

-- Insert photo/flag/club_logo for each FIFA edition
INSERT INTO photo(fifa_player_id, photo, flag, club_logo)
SELECT 
	f.fifa_player_id, f17.Photo, f17.Flag, f17.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA17_official_data  f17
	ON f.player_id = f17.ID
WHERE f.fifa = 17
UNION
SELECT 
	f.fifa_player_id, f18.Photo, f18.Flag, f18.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA18_official_data  f18
	ON f.player_id = f18.ID
WHERE f.fifa = 18
UNION
SELECT 
	f.fifa_player_id, f19.Photo, f19.Flag, f19.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA19_official_data  f19
	ON f.player_id = f19.ID
WHERE f.fifa = 19
UNION
SELECT 
	f.fifa_player_id, f20.Photo, f20.Flag, f20.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA20_official_data  f20
	ON f.player_id = f20.ID
WHERE f.fifa = 20
UNION
SELECT 
	f.fifa_player_id, f21.Photo, f21.Flag, f21.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA21_official_data  f21
	ON f.player_id = f21.ID
WHERE f.fifa = 21
UNION
SELECT 
	f.fifa_player_id, f22.Photo, f22.Flag, f22.Club_Logo
FROM fifa_players  f
LEFT JOIN FIFA22_official_data  f22
	ON f.player_id = f22.ID
WHERE f.fifa = 22;

UPDATE FIFA20_official_data
SET
	Positioning = CASE WHEN Positioning = 'nan' THEN '0' ELSE Positioning END,
	Volleys = CASE WHEN Volleys = 'nan' THEN '0' ELSE Volleys END,
	Vision = CASE WHEN Vision = 'nan' THEN '0' ELSE Vision END,
	Curve = CASE WHEN Curve = 'nan' THEN '0' ELSE Curve END,
	Agility = CASE WHEN Agility = 'nan' THEN '0' ELSE Agility END,
	Balance = CASE WHEN Balance = 'nan' THEN '0' ELSE Balance END,
	Composure = CASE WHEN Composure = 'nan' THEN '0' ELSE Composure END,
	Interceptions = CASE WHEN Interceptions = 'nan' THEN '0' ELSE Interceptions END,
	SlidingTackle = CASE WHEN SlidingTackle = 'nan' THEN '0' ELSE SlidingTackle END,
	Jumping = CASE WHEN Jumping = 'nan' THEN '0' ELSE Jumping END;

UPDATE FIFA21_official_data
SET
	Positioning = CASE WHEN Positioning = 'nan' THEN '0' ELSE Positioning END,
	Volleys = CASE WHEN Volleys = 'nan' THEN '0' ELSE Volleys END,
	Vision = CASE WHEN Vision = 'nan' THEN '0' ELSE Vision END,
	Curve = CASE WHEN Curve = 'nan' THEN '0' ELSE Curve END,
	Agility = CASE WHEN Agility = 'nan' THEN '0' ELSE Agility END,
	Balance = CASE WHEN Balance = 'nan' THEN '0' ELSE Balance END,
	Composure = CASE WHEN Composure = 'nan' THEN '0' ELSE Composure END,
	Interceptions = CASE WHEN Interceptions = 'nan' THEN '0' ELSE Interceptions END,
	SlidingTackle = CASE WHEN SlidingTackle = 'nan' THEN '0' ELSE SlidingTackle END,
	Jumping = CASE WHEN Jumping = 'nan' THEN '0' ELSE Jumping END;

UPDATE FIFA22_official_data
SET
	Positioning = CASE WHEN Positioning = 'nan' THEN '0' ELSE Positioning END,
	Volleys = CASE WHEN Volleys = 'nan' THEN '0' ELSE Volleys END,
	Vision = CASE WHEN Vision = 'nan' THEN '0' ELSE Vision END,
	Curve = CASE WHEN Curve = 'nan' THEN '0' ELSE Curve END,
	Agility = CASE WHEN Agility = 'nan' THEN '0' ELSE Agility END,
	Balance = CASE WHEN Balance = 'nan' THEN '0' ELSE Balance END,
	Composure = CASE WHEN Composure = 'nan' THEN '0' ELSE Composure END,
	Interceptions = CASE WHEN Interceptions = 'nan' THEN '0' ELSE Interceptions END,
	SlidingTackle = CASE WHEN SlidingTackle = 'nan' THEN '0' ELSE SlidingTackle END,
	Jumping = CASE WHEN Jumping = 'nan' THEN '0' ELSE Jumping END;

-- Insert calculated statistics into the stat table
INSERT INTO stat(fifa_player_id, overall, pace, shooting, passing, dribbling, defending, physical, potential, best_position, preferred_foot, weak_foot, skill_moves)
SELECT
	f.fifa_player_id,
	f17.overall,
	CAST(f17.Acceleration AS FLOAT) * 0.45 + CAST(f17.SprintSpeed AS FLOAT) * 0.55,
	CAST(f17.Finishing AS FLOAT) * 0.45 + CAST(f17.ShotPower AS FLOAT) * 0.20 + CAST(f17.Positioning AS FLOAT) * 0.20 + CAST(f17.LongShots AS FLOAT) * 0.05 + CAST(f17.Volleys AS FLOAT)* 0.05 + CAST(f17.Penalties AS FLOAT) * 0.05,
	CAST(f17.ShortPassing AS FLOAT) * 0.35 + CAST(f17.Vision AS FLOAT) * 0.20 + CAST(f17.LongPassing AS FLOAT)* 0.20 + CAST(f17.Crossing AS FLOAT) * 0.10 + CAST(f17.Curve AS FLOAT)* 0.10 + CAST(f17.FKAccuracy AS FLOAT)* 0.05,
	CAST(f17.Dribbling AS FLOAT)* 0.35 + CAST(f17.BallControl AS FLOAT)* 0.25 + CAST(f17.Agility AS FLOAT)* 0.15 + CAST(f17.Balance AS FLOAT)* 0.10 + CAST(f17.Reactions AS FLOAT) * 0.10 + CAST(f17.Composure AS FLOAT)* 0.05,
	CAST(f17.StandingTackle AS FLOAT)* 0.30 + CAST(f17.Interceptions AS FLOAT)* 0.30 + CAST(f17.SlidingTackle AS FLOAT)* 0.20 + CAST(f17.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f17.Strength AS FLOAT) * 0.50 + CAST(f17.Stamina AS FLOAT)* 0.25 + CAST(f17.Aggression AS FLOAT)* 0.15 + CAST(f17.Jumping AS FLOAT)* 0.10,
	f17.potential,
	f17.best_position,
	f17.preferred_foot,
	f17.weak_foot,
	f17.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA17_official_data  f17
	ON f.player_id = f17.ID
WHERE f.fifa = 17
UNION
SELECT
	f.fifa_player_id,
	f18.overall,
	CAST(f18.Acceleration AS FLOAT) * 0.45 + CAST(f18.SprintSpeed AS FLOAT) * 0.55,
	CAST(f18.Finishing AS FLOAT) * 0.45 + CAST(f18.ShotPower AS FLOAT) * 0.20 + CAST(f18.Positioning AS FLOAT) * 0.20 + CAST(f18.LongShots AS FLOAT) * 0.05 + CAST(f18.Volleys AS FLOAT)* 0.05 + CAST(f18.Penalties AS FLOAT) * 0.05,
	CAST(f18.ShortPassing AS FLOAT) * 0.35 + CAST(f18.Vision AS FLOAT) * 0.20 + CAST(f18.LongPassing AS FLOAT) * 0.20 + CAST(f18.Crossing AS FLOAT) * 0.10 + CAST(f18.Curve AS FLOAT)* 0.10 + CAST(f18.FKAccuracy AS FLOAT)* 0.05,
	CAST(f18.Dribbling AS FLOAT)* 0.35 + CAST(f18.BallControl AS FLOAT)* 0.25 + CAST(f18.Agility AS FLOAT) * 0.15 + CAST(f18.Balance AS FLOAT)* 0.10 + CAST(f18.Reactions AS FLOAT) * 0.10 + CAST(f18.Composure AS FLOAT)* 0.05,
	CAST(f18.StandingTackle AS FLOAT) * 0.30 + CAST(f18.Interceptions AS FLOAT)* 0.30 + CAST(f18.SlidingTackle AS FLOAT)* 0.20 + CAST(f18.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f18.Strength AS FLOAT) * 0.50 + CAST(f18.Stamina AS FLOAT)* 0.25 + CAST(f18.Aggression AS FLOAT) * 0.15 + CAST(f18.Jumping AS FLOAT)* 0.10,
	f18.potential,
	f18.best_position,
	f18.preferred_foot,
	f18.weak_foot,
	f18.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA18_official_data  f18
	ON f.player_id = f18.ID
WHERE f.fifa = 18
UNION
SELECT
	f.fifa_player_id,
	f19.overall,
	CAST(f19.Acceleration AS FLOAT) * 0.45 + CAST(f19.SprintSpeed AS FLOAT) * 0.55,
	CAST(f19.Finishing AS FLOAT) * 0.45 + CAST(f19.ShotPower AS FLOAT) * 0.20 + CAST(f19.Positioning AS FLOAT) * 0.20 + CAST(f19.LongShots AS FLOAT) * 0.05 + CAST(f19.Volleys AS FLOAT)* 0.05 + CAST(f19.Penalties AS FLOAT) * 0.05,
	CAST(f19.ShortPassing AS FLOAT) * 0.35 + CAST(f19.Vision AS FLOAT) * 0.20 + CAST(f19.LongPassing AS FLOAT) * 0.20 + CAST(f19.Crossing AS FLOAT) * 0.10 + CAST(f19.Curve AS FLOAT)* 0.10 + CAST(f19.FKAccuracy AS FLOAT)* 0.05,
	CAST(f19.Dribbling AS FLOAT)* 0.35 + CAST(f19.BallControl AS FLOAT)* 0.25 + CAST(f19.Agility AS FLOAT) * 0.15 + CAST(f19.Balance AS FLOAT)* 0.10 + CAST(f19.Reactions AS FLOAT) * 0.10 + CAST(f19.Composure AS FLOAT)* 0.05,
	CAST(f19.StandingTackle AS FLOAT) * 0.30 + CAST(f19.Interceptions AS FLOAT)* 0.30 + CAST(f19.SlidingTackle AS FLOAT)* 0.20 + CAST(f19.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f19.Strength AS FLOAT) * 0.50 + CAST(f19.Stamina AS FLOAT)* 0.25 + CAST(f19.Aggression AS FLOAT) * 0.15 + CAST(f19.Jumping AS FLOAT)* 0.10,
	f19.potential,
	f19.best_position,
	f19.preferred_foot,
	f19.weak_foot,
	f19.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA19_official_data  f19
	ON f.player_id = f19.ID
WHERE f.fifa = 19
UNION
SELECT
	f.fifa_player_id,
	f20.overall,
	CAST(f20.Acceleration AS FLOAT) * 0.45 + CAST(f20.SprintSpeed AS FLOAT) * 0.55,
	CAST(f20.Finishing AS FLOAT) * 0.45 + CAST(f20.ShotPower AS FLOAT) * 0.20 + CAST(f20.Positioning AS FLOAT) * 0.20 + CAST(f20.LongShots AS FLOAT) * 0.05 + CAST(f20.Volleys AS FLOAT)* 0.05 + CAST(f20.Penalties AS FLOAT) * 0.05,
	CAST(f20.ShortPassing AS FLOAT) * 0.35 + CAST(f20.Vision AS FLOAT) * 0.20 + CAST(f20.LongPassing AS FLOAT) * 0.20 + CAST(f20.Crossing AS FLOAT) * 0.10 + CAST(f20.Curve AS FLOAT)* 0.10 + CAST(f20.FKAccuracy AS FLOAT)* 0.05,
	CAST(f20.Dribbling AS FLOAT)* 0.35 + CAST(f20.BallControl AS FLOAT)* 0.25 + CAST(f20.Agility AS FLOAT) * 0.15 + CAST(f20.Balance AS FLOAT)* 0.10 + CAST(f20.Reactions AS FLOAT) * 0.10 + CAST(f20.Composure AS FLOAT)* 0.05,
	CAST(f20.StandingTackle AS FLOAT) * 0.30 + CAST(f20.Interceptions AS FLOAT)* 0.30 + CAST(f20.SlidingTackle AS FLOAT)* 0.20 + CAST(f20.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f20.Strength AS FLOAT) * 0.50 + CAST(f20.Stamina AS FLOAT)* 0.25 + CAST(f20.Aggression AS FLOAT) * 0.15 + CAST(f20.Jumping AS FLOAT)* 0.10,
	f20.potential,
	f20.best_position,
	f20.preferred_foot,
	f20.weak_foot,
	f20.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA20_official_data  f20
	ON f.player_id = f20.ID
WHERE f.fifa = 20
UNION
SELECT
	f.fifa_player_id,
	f21.overall,
	CAST(f21.Acceleration AS FLOAT) * 0.45 + CAST(f21.SprintSpeed AS FLOAT) * 0.55,
	CAST(f21.Finishing AS FLOAT) * 0.45 + CAST(f21.ShotPower AS FLOAT) * 0.20 + CAST(f21.Positioning AS FLOAT) * 0.20 + CAST(f21.LongShots AS FLOAT) * 0.05 + CAST(f21.Volleys AS FLOAT)* 0.05 + CAST(f21.Penalties AS FLOAT) * 0.05,
	CAST(f21.ShortPassing AS FLOAT) * 0.35 + CAST(f21.Vision AS FLOAT) * 0.20 + CAST(f21.LongPassing AS FLOAT) * 0.20 + CAST(f21.Crossing AS FLOAT) * 0.10 + CAST(f21.Curve AS FLOAT)* 0.10 + CAST(f21.FKAccuracy AS FLOAT)* 0.05,
	CAST(f21.Dribbling AS FLOAT)* 0.35 + CAST(f21.BallControl AS FLOAT)* 0.25 + CAST(f21.Agility AS FLOAT) * 0.15 + CAST(f21.Balance AS FLOAT)* 0.10 + CAST(f21.Reactions AS FLOAT) * 0.10 + CAST(f21.Composure AS FLOAT)* 0.05,
	CAST(f21.StandingTackle AS FLOAT) * 0.30 + CAST(f21.Interceptions AS FLOAT)* 0.30 + CAST(f21.SlidingTackle AS FLOAT)* 0.20 + CAST(f21.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f21.Strength AS FLOAT) * 0.50 + CAST(f21.Stamina AS FLOAT)* 0.25 + CAST(f21.Aggression AS FLOAT) * 0.15 + CAST(f21.Jumping AS FLOAT)* 0.10,
	f21.potential,
	f21.best_position,
	f21.preferred_foot,
	f21.weak_foot,
	f21.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA21_official_data  f21
	ON f.player_id = f21.ID
WHERE f.fifa = 21
UNION
SELECT
	f.fifa_player_id,
	f22.overall,
	CAST(f22.Acceleration AS FLOAT) * 0.45 + CAST(f22.SprintSpeed AS FLOAT) * 0.55,
	CAST(f22.Finishing AS FLOAT) * 0.45 + CAST(f22.ShotPower AS FLOAT) * 0.20 + CAST(f22.Positioning AS FLOAT) * 0.20 + CAST(f22.LongShots AS FLOAT) * 0.05 + CAST(f22.Volleys AS FLOAT)* 0.05 + CAST(f22.Penalties AS FLOAT) * 0.05,
	CAST(f22.ShortPassing AS FLOAT) * 0.35 + CAST(f22.Vision AS FLOAT) * 0.20 + CAST(f22.LongPassing AS FLOAT) * 0.20 + CAST(f22.Crossing AS FLOAT) * 0.10 + CAST(f22.Curve AS FLOAT)* 0.10 + CAST(f22.FKAccuracy AS FLOAT)* 0.05,
	CAST(f22.Dribbling AS FLOAT)* 0.35 + CAST(f22.BallControl AS FLOAT)* 0.25 + CAST(f22.Agility AS FLOAT) * 0.15 + CAST(f22.Balance AS FLOAT)* 0.10 + CAST(f22.Reactions AS FLOAT) * 0.10 + CAST(f22.Composure AS FLOAT)* 0.05,
	CAST(f22.StandingTackle AS FLOAT) * 0.30 + CAST(f22.Interceptions AS FLOAT)* 0.30 + CAST(f22.SlidingTackle AS FLOAT)* 0.20 + CAST(f22.HeadingAccuracy AS FLOAT) * 0.20,
	CAST(f22.Strength AS FLOAT) * 0.50 + CAST(f22.Stamina AS FLOAT)* 0.25 + CAST(f22.Aggression AS FLOAT) * 0.15 + CAST(f22.Jumping AS FLOAT)* 0.10,
	f22.potential,
	f22.best_position,
	f22.preferred_foot,
	f22.weak_foot,
	f22.skill_moves
FROM fifa_players  f
LEFT JOIN FIFA22_official_data  f22
	ON f.player_id = f22.ID
WHERE f.fifa = 22;
SELECT * FROM stat

-- Normalize value and wage fields
UPDATE FIFA17_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;
UPDATE FIFA18_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;
UPDATE FIFA19_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;
UPDATE FIFA20_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;
UPDATE FIFA21_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;
UPDATE FIFA22_official_data
SET 
	value =
		CASE
			WHEN value LIKE '%K' THEN CAST(REPLACE(REPLACE(value, '€',''),'K','') AS FLOAT) * 1000 
			WHEN value LIKE '%M' THEN CAST(REPLACE(REPLACE(value, '€',''),'M','') AS FLOAT) * 1000000
			ELSE CAST(REPLACE(value,'€','') AS FLOAT)
		END,
	wage =
		CASE
			WHEN wage LIKE '%K' THEN CAST(REPLACE(REPLACE(wage, '€',''),'K','') AS FLOAT) * 1000 
			WHEN wage LIKE '%M' THEN CAST(REPLACE(REPLACE(wage, '€',''),'M','') AS FLOAT) * 1000000 
			ELSE CAST(REPLACE(wage, '€','') AS FLOAT)
		END;

-- Insert normalized values and wages into the value table
INSERT INTO value(fifa_player_id, value, wage)
SELECT 
	f.fifa_player_id, f17.value, f17.wage
FROM fifa_players  f
LEFT JOIN FIFA17_official_data  f17
	ON f.player_id = f17.ID
WHERE f.fifa = 17
UNION
SELECT 
	f.fifa_player_id, f18.value, f18.wage
FROM fifa_players  f
LEFT JOIN FIFA18_official_data  f18
	ON f.player_id = f18.ID
WHERE f.fifa = 18
UNION
SELECT 
	f.fifa_player_id, f19.value, f19.wage
FROM fifa_players  f
LEFT JOIN FIFA19_official_data  f19
	ON f.player_id = f19.ID
WHERE f.fifa = 19
UNION
SELECT 
	f.fifa_player_id, f20.value, f20.wage
FROM fifa_players  f
LEFT JOIN FIFA20_official_data  f20
	ON f.player_id = f20.ID
WHERE f.fifa = 20
UNION
SELECT 
	f.fifa_player_id, f21.value, f21.wage
FROM fifa_players  f
LEFT JOIN FIFA21_official_data  f21
	ON f.player_id = f21.ID
WHERE f.fifa = 21
UNION
SELECT 
	f.fifa_player_id, f22.value, f22.wage
FROM fifa_players  f
LEFT JOIN FIFA22_official_data  f22
	ON f.player_id = f22.ID
WHERE f.fifa = 22; 

-- Add a column to group positions into role categories
ALTER TABLE stat
ADD positions NVARCHAR(25);

-- Update position categories based on best_position
UPDATE stat
SET positions =
	CASE
		WHEN best_position IN ('LW', 'CF', 'ST', 'LF', 'RW') THEN 'Attackers'
		WHEN best_position = 'GK' THEN 'Goalkeepers'
		WHEN best_position IN ('LB', 'CB', 'RB', 'SW', 'LWB', 'RWB') THEN 'Defenders'
		WHEN best_position IN ('CAM', 'CM', 'CDM', 'LM', 'RM') THEN 'Midfielders'
	END;