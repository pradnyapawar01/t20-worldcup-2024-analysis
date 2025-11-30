-- ============================================================================
-- T20 WORLD CUP 2024 - COMPLETE DATA IMPORT SCRIPT
-- ============================================================================
-- Author: Pradnya Pawar
-- Database: MySQL 8.0+
-- Purpose: Import and clean T20 World Cup 2024 match and delivery data
-- Description: Handles CSV import, data cleaning, type conversion, and indexing
-- 
-- FEATURES:
-- - Proper NULL handling for empty strings
-- - Date format conversion
-- - Integer conversion for numeric fields
-- - Performance indexes for analytical queries
-- - Data validation checks
-- 
-- PREREQUISITES:
-- - MySQL 8.0 or higher
-- - CSV files: matches.csv and deliveries.csv
-- - MySQL Workbench or similar client for CSV import
-- ============================================================================

-- ============================================================================
-- SECTION 1: DATABASE SETUP
-- ============================================================================

DROP DATABASE IF EXISTS t20_worldcup_2024;
CREATE DATABASE t20_worldcup_2024;
USE t20_worldcup_2024;

-- ============================================================================
-- SECTION 2: CREATE TEMPORARY STAGING TABLES
-- ============================================================================
-- Note: Using VARCHAR for all numeric/date fields to handle CSV import gracefully
-- Will convert to proper types after import
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Staging table for matches data
-- ----------------------------------------------------------------------------
CREATE TABLE matches (
    season INT NOT NULL,
    team1 VARCHAR(50) NOT NULL,
    team2 VARCHAR(50) NOT NULL,
    match_date VARCHAR(20),  -- Temporarily VARCHAR for import, will convert later
    match_number INT PRIMARY KEY,
    venue VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    toss_winner VARCHAR(50),
    toss_decision VARCHAR(10),
    player_of_match VARCHAR(100),
    umpire1 VARCHAR(50),
    umpire2 VARCHAR(50),
    reserve_umpire VARCHAR(50),
    match_referee VARCHAR(50),
    winner VARCHAR(50),
    winner_runs VARCHAR(10),  -- Temporarily VARCHAR to accept empty strings
    winner_wickets VARCHAR(10),  -- Temporarily VARCHAR to accept empty strings
    match_type VARCHAR(20) NOT NULL
);

-- ----------------------------------------------------------------------------
-- Staging table for deliveries data
-- ----------------------------------------------------------------------------
CREATE TABLE deliveries (
    match_id INT NOT NULL,
    season INT NOT NULL,
    start_date VARCHAR(20),  -- Temporarily VARCHAR for import
    venue VARCHAR(100) NOT NULL,
    innings INT NOT NULL,
    ball DECIMAL(3,1) NOT NULL,
    batting_team VARCHAR(50) NOT NULL,
    bowling_team VARCHAR(50) NOT NULL,
    striker VARCHAR(100) NOT NULL,
    non_striker VARCHAR(100) NOT NULL,
    bowler VARCHAR(100) NOT NULL,
    runs_off_bat VARCHAR(10),  -- Temporarily VARCHAR
    extras VARCHAR(10),  -- Temporarily VARCHAR
    wides VARCHAR(10),  -- Temporarily VARCHAR
    noballs VARCHAR(10),  -- Temporarily VARCHAR
    byes VARCHAR(10),  -- Temporarily VARCHAR
    legbyes VARCHAR(10),  -- Temporarily VARCHAR
    penalty VARCHAR(10),  -- Temporarily VARCHAR
    wicket_type VARCHAR(50),
    player_dismissed VARCHAR(100),
    other_wicket_type VARCHAR(50),
    other_player_dismissed VARCHAR(100)
);

-- ============================================================================
-- SECTION 3: DATA IMPORT INSTRUCTIONS
-- ============================================================================
/*
STEP-BY-STEP IMPORT PROCESS:

METHOD 1: Using MySQL Workbench (RECOMMENDED)
----------------------------------------------
1. Right-click on 'matches' table → Select "Table Data Import Wizard"
2. Browse and select 'matches.csv' file
3. Verify column mapping (ensure all columns align correctly)
4. Click "Next" and then "Finish" to import
5. Repeat the same process for 'deliveries' table with 'deliveries.csv'

After importing data, continue with the script below...
*/

-- ============================================================================
-- SECTION 4: VERIFY INITIAL IMPORT
-- ============================================================================

-- Check if data loaded successfully
SELECT COUNT(*) AS matches_loaded FROM matches;
SELECT COUNT(*) AS deliveries_loaded FROM deliveries;

-- View sample data to verify structure
SELECT * FROM matches LIMIT 5;
SELECT * FROM deliveries LIMIT 5;

-- Expected Results:
-- matches_loaded: 52
-- deliveries_loaded: 11472

-- ============================================================================
-- SECTION 5: DATA CLEANING AND TYPE CONVERSION
-- ============================================================================
-- Creates final tables with proper data types and handles NULL values
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Create cleaned matches table
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS matches_clean;

CREATE TABLE matches_clean (
    season INT NOT NULL,
    team1 VARCHAR(50) NOT NULL,
    team2 VARCHAR(50) NOT NULL,
    match_date DATE NOT NULL,
    match_number INT PRIMARY KEY,
    venue VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    toss_winner VARCHAR(50),
    toss_decision VARCHAR(10),
    player_of_match VARCHAR(100),
    umpire1 VARCHAR(50),
    umpire2 VARCHAR(50),
    reserve_umpire VARCHAR(50),
    match_referee VARCHAR(50),
    winner VARCHAR(50),
    winner_runs INT,
    winner_wickets INT,
    match_type VARCHAR(20) NOT NULL
);

-- ----------------------------------------------------------------------------
-- Insert cleaned matches data with proper type conversion
-- ----------------------------------------------------------------------------
INSERT INTO matches_clean
SELECT 
    season,
    team1,
    team2,
    STR_TO_DATE(match_date, '%Y/%m/%d') AS match_date,
    match_number,
    venue,
    city,
    NULLIF(TRIM(toss_winner), '') AS toss_winner,
    NULLIF(TRIM(toss_decision), '') AS toss_decision,
    NULLIF(TRIM(player_of_match), '') AS player_of_match,
    NULLIF(TRIM(umpire1), '') AS umpire1,
    NULLIF(TRIM(umpire2), '') AS umpire2,
    NULLIF(TRIM(reserve_umpire), '') AS reserve_umpire,
    NULLIF(TRIM(match_referee), '') AS match_referee,
    NULLIF(TRIM(winner), '') AS winner,
    CASE WHEN TRIM(winner_runs) = '' THEN NULL ELSE FLOOR(CAST(winner_runs AS DECIMAL(10,2))) END AS winner_runs,
    CASE WHEN TRIM(winner_wickets) = '' THEN NULL ELSE FLOOR(CAST(winner_wickets AS DECIMAL(10,2))) END AS winner_wickets,
    match_type
FROM matches;

-- Verify matches_clean has data
SELECT COUNT(*) AS matches_loaded FROM matches_clean;
SELECT * FROM matches_clean LIMIT 5;

-- ----------------------------------------------------------------------------
-- Create cleaned deliveries table
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS deliveries_clean;

CREATE TABLE deliveries_clean (
    match_id INT NOT NULL,
    season INT NOT NULL,
    start_date DATE NOT NULL,
    venue VARCHAR(100) NOT NULL,
    innings INT NOT NULL,
    ball DECIMAL(3,1) NOT NULL,
    batting_team VARCHAR(50) NOT NULL,
    bowling_team VARCHAR(50) NOT NULL,
    striker VARCHAR(100) NOT NULL,
    non_striker VARCHAR(100) NOT NULL,
    bowler VARCHAR(100) NOT NULL,
    runs_off_bat INT DEFAULT 0,
    extras INT DEFAULT 0,
    wides INT DEFAULT 0,
    noballs INT DEFAULT 0,
    byes INT DEFAULT 0,
    legbyes INT DEFAULT 0,
    penalty INT DEFAULT 0,
    wicket_type VARCHAR(50),
    player_dismissed VARCHAR(100),
    other_wicket_type VARCHAR(50),
    other_player_dismissed VARCHAR(100)
);

-- ----------------------------------------------------------------------------
-- Insert cleaned deliveries data with proper type conversion
-- ----------------------------------------------------------------------------
INSERT INTO deliveries_clean
SELECT 
    match_id,
    season,
    STR_TO_DATE(start_date, '%Y-%m-%d') AS start_date,
    venue,
    innings,
    ball,
    batting_team,
    bowling_team,
    striker,
    non_striker,
    bowler,
    COALESCE(CASE WHEN TRIM(runs_off_bat) = '' THEN NULL ELSE FLOOR(CAST(runs_off_bat AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(extras) = '' THEN NULL ELSE FLOOR(CAST(extras AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(wides) = '' THEN NULL ELSE FLOOR(CAST(wides AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(noballs) = '' THEN NULL ELSE FLOOR(CAST(noballs AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(byes) = '' THEN NULL ELSE FLOOR(CAST(byes AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(legbyes) = '' THEN NULL ELSE FLOOR(CAST(legbyes AS DECIMAL(10,2))) END, 0),
    COALESCE(CASE WHEN TRIM(penalty) = '' THEN NULL ELSE FLOOR(CAST(penalty AS DECIMAL(10,2))) END, 0),
    NULLIF(TRIM(wicket_type), ''),
    NULLIF(TRIM(player_dismissed), ''),
    NULLIF(TRIM(other_wicket_type), ''),
    NULLIF(TRIM(other_player_dismissed), '')
FROM deliveries;

-- Verify deliveries_clean has data
SELECT COUNT(*) AS deliveries_loaded FROM deliveries_clean;
SELECT * FROM deliveries_clean LIMIT 10;

-- ============================================================================
-- SECTION 6: REPLACE STAGING TABLES WITH CLEANED TABLES
-- ============================================================================

DROP TABLE deliveries;
DROP TABLE matches;

RENAME TABLE matches_clean TO matches;
RENAME TABLE deliveries_clean TO deliveries;

-- ============================================================================
-- SECTION 7: CREATE PERFORMANCE INDEXES
-- ============================================================================
-- Strategic indexes for optimizing analytical queries
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Matches table indexes
-- ----------------------------------------------------------------------------
CREATE INDEX idx_matches_team1 ON matches(team1);
CREATE INDEX idx_matches_team2 ON matches(team2);
CREATE INDEX idx_matches_winner ON matches(winner);
CREATE INDEX idx_matches_venue ON matches(venue);
CREATE INDEX idx_matches_date ON matches(match_date);
CREATE INDEX idx_matches_type ON matches(match_type);

-- ----------------------------------------------------------------------------
-- Deliveries table indexes
-- ----------------------------------------------------------------------------
CREATE INDEX idx_deliveries_match ON deliveries(match_id);
CREATE INDEX idx_deliveries_batting ON deliveries(batting_team);
CREATE INDEX idx_deliveries_bowling ON deliveries(bowling_team);
CREATE INDEX idx_deliveries_striker ON deliveries(striker);
CREATE INDEX idx_deliveries_bowler ON deliveries(bowler);
CREATE INDEX idx_deliveries_innings ON deliveries(innings);

-- ----------------------------------------------------------------------------
-- Composite indexes for complex queries
-- ----------------------------------------------------------------------------
CREATE INDEX idx_deliveries_match_innings ON deliveries(match_id, innings);
CREATE INDEX idx_deliveries_striker_runs ON deliveries(striker, runs_off_bat);
CREATE INDEX idx_deliveries_bowler_wicket ON deliveries(bowler, wicket_type);

-- ============================================================================
-- SECTION 8: DATA VALIDATION AND VERIFICATION
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Record count verification
-- ----------------------------------------------------------------------------
SELECT 'Matches' AS table_name, COUNT(*) AS records FROM matches
UNION ALL
SELECT 'Deliveries' AS table_name, COUNT(*) AS records FROM deliveries;

-- Expected output:
-- Matches: 52
-- Deliveries: 11472

-- ----------------------------------------------------------------------------
-- Verify NULL handling and data types
-- ----------------------------------------------------------------------------
SELECT 
    COUNT(*) AS total_matches,
    COUNT(winner) AS matches_with_winner,
    COUNT(winner_runs) AS wins_by_runs,
    COUNT(winner_wickets) AS wins_by_wickets,
    COUNT(*) - COUNT(winner) AS no_result_matches
FROM matches;

-- Expected: 52 total, 50 with winner, 2 no result

-- ----------------------------------------------------------------------------
-- Check date conversion
-- ----------------------------------------------------------------------------
SELECT match_number, team1, team2, match_date, winner 
FROM matches 
ORDER BY match_date
LIMIT 10;

-- Dates should be in YYYY-MM-DD format

-- ----------------------------------------------------------------------------
-- Verify foreign key relationships
-- ----------------------------------------------------------------------------
SELECT 
    COUNT(DISTINCT d.match_id) AS unique_matches_in_deliveries,
    COUNT(DISTINCT m.match_number) AS total_matches
FROM deliveries d
LEFT JOIN matches m ON d.match_id = m.match_number;

-- Both should be 52

-- ----------------------------------------------------------------------------
-- Sample data quality check
-- ----------------------------------------------------------------------------
SELECT 
    m.match_number,
    m.team1,
    m.team2,
    m.winner,
    m.winner_runs,
    m.winner_wickets,
    m.venue
FROM matches m
ORDER BY m.match_number
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Check for data integrity
-- ----------------------------------------------------------------------------
SELECT 
    'Total Runs' AS metric,
    SUM(runs_off_bat + extras) AS value
FROM deliveries

UNION ALL

SELECT 
    'Total Wickets',
    COUNT(*)
FROM deliveries
WHERE wicket_type IS NOT NULL

UNION ALL

SELECT 
    'Total Sixes',
    COUNT(*)
FROM deliveries
WHERE runs_off_bat = 6

UNION ALL

SELECT 
    'Total Fours',
    COUNT(*)
FROM deliveries
WHERE runs_off_bat = 4;