-- ============================================================================
-- T20 MEN'S WORLD CUP 2024 - COMPLETE SQL CASE STUDY
-- Author: Pradnya Pawar 
-- Database: MySQL 8.0+
-- Description: Analysis of ICC T20 World Cup 2024
-- ============================================================================

USE t20_worldcup_2024;

-- ============================================================================
-- SECTION 1: TOURNAMENT OVERVIEW & STATISTICS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q1: Total number of matches played in the tournament
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS total_matches
FROM matches;

-- ----------------------------------------------------------------------------
-- Q2: Number of matches played at each venue
-- ----------------------------------------------------------------------------
SELECT 
    venue, 
    city, 
    COUNT(*) AS matches_played
FROM matches
GROUP BY venue, city
ORDER BY matches_played DESC;



-- ----------------------------------------------------------------------------
-- Q3: Match distribution by tournament stage
-- ----------------------------------------------------------------------------
SELECT 
    match_type, 
    COUNT(*) AS match_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches), 2) AS percentage
FROM matches
GROUP BY match_type
ORDER BY match_count DESC;


-- ----------------------------------------------------------------------------
-- Q4: Total number of participating teams
-- ----------------------------------------------------------------------------
SELECT COUNT(DISTINCT team) AS total_teams
FROM (
    SELECT team1 AS team FROM matches
    UNION
    SELECT team2 AS team FROM matches
) AS all_teams;


-- ----------------------------------------------------------------------------
-- Q5: Complete venue and city mapping
-- ----------------------------------------------------------------------------
SELECT DISTINCT 
    venue, 
    city,
    COUNT(*) OVER (PARTITION BY city) AS matches_in_city
FROM matches
ORDER BY matches_in_city DESC, city, venue;


-- ============================================================================
-- SECTION 2: TEAM PERFORMANCE ANALYSIS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q6: Team-wise total wins
-- ----------------------------------------------------------------------------
SELECT 
    winner AS team, 
    COUNT(*) AS total_wins,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE winner IS NOT NULL), 2) AS win_percentage_of_total
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC;


-- ----------------------------------------------------------------------------
-- Q7: Team win percentage
-- ----------------------------------------------------------------------------
SELECT 
    team,
    total_matches,
    wins,
    total_matches - wins AS losses,
    ROUND((wins * 100.0 / total_matches), 2) AS win_percentage
FROM (
    SELECT 
        team,
        COUNT(*) AS total_matches,
        SUM(CASE WHEN winner = team THEN 1 ELSE 0 END) AS wins
    FROM (
        SELECT team1 AS team, winner FROM matches
        UNION ALL
        SELECT team2 AS team, winner FROM matches
    ) AS team_matches
    GROUP BY team
) AS team_stats
ORDER BY win_percentage DESC, total_matches DESC;


-- ----------------------------------------------------------------------------
-- Q8: Most dominant victories by runs
-- ----------------------------------------------------------------------------
SELECT 
    winner, 
    team1, 
    team2, 
    winner_runs AS victory_margin, 
    match_type, 
    venue,
    CONCAT(team1, ' vs ', team2) AS matchup
FROM matches
WHERE winner_runs IS NOT NULL
ORDER BY winner_runs DESC
LIMIT 10;


-- ----------------------------------------------------------------------------
-- Q9: Most dominant victories by wickets
-- ----------------------------------------------------------------------------
SELECT 
    winner, 
    team1, 
    team2, 
    winner_wickets AS wickets_remaining, 
    match_type, 
    venue,
    CONCAT(team1, ' vs ', team2) AS matchup
FROM matches
WHERE winner_wickets IS NOT NULL
ORDER BY winner_wickets DESC
LIMIT 10;

                        
-- ============================================================================
-- SECTION 3: TOSS ANALYSIS & STRATEGIC DECISIONS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q11: Toss decision preferences
-- ----------------------------------------------------------------------------
SELECT 
    toss_decision AS decision, 
    COUNT(*) AS times_chosen,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE toss_decision IS NOT NULL), 2) AS percentage
FROM matches
WHERE toss_decision IS NOT NULL
GROUP BY toss_decision;

-- ----------------------------------------------------------------------------
-- Q12: Correlation between toss and match outcome
-- ----------------------------------------------------------------------------
SELECT 
    'Toss Winner Won Match' AS scenario,
    COUNT(*) AS occurrences,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE winner IS NOT NULL), 2) AS percentage
FROM matches
WHERE toss_winner = winner AND winner IS NOT NULL

UNION ALL

SELECT 
    'Toss Winner Lost Match' AS scenario,
    COUNT(*) AS occurrences,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE winner IS NOT NULL), 2) AS percentage
FROM matches
WHERE toss_winner != winner AND winner IS NOT NULL;


-- ----------------------------------------------------------------------------
-- Q13: Teams with best toss-to-win conversion rate
-- ----------------------------------------------------------------------------
SELECT 
    toss_winner AS team,
    COUNT(*) AS tosses_won,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS matches_won_after_toss,
    ROUND(SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS conversion_rate
FROM matches
WHERE toss_winner IS NOT NULL AND winner IS NOT NULL
GROUP BY toss_winner
HAVING COUNT(*) >= 3
ORDER BY conversion_rate DESC, tosses_won DESC;


-- ----------------------------------------------------------------------------
-- Q14: Success rate of each toss decision
-- ----------------------------------------------------------------------------
SELECT 
    toss_decision AS decision_made,
    COUNT(*) AS times_chosen,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS resulted_in_win,
    ROUND(SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS success_rate
FROM matches
WHERE toss_decision IS NOT NULL AND winner IS NOT NULL
GROUP BY toss_decision
ORDER BY success_rate DESC;


-- ============================================================================
-- SECTION 4: BATTING PERFORMANCE ANALYSIS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q15: Top 10 run scorers
-- ----------------------------------------------------------------------------
SELECT 
    striker AS batsman,
    SUM(runs_off_bat) AS total_runs,
    COUNT(DISTINCT match_id) AS matches_played,
    ROUND(SUM(runs_off_bat) * 1.0 / COUNT(DISTINCT match_id), 2) AS avg_runs_per_match
FROM deliveries
GROUP BY striker
ORDER BY total_runs DESC
LIMIT 10;


-- ----------------------------------------------------------------------------
-- Q16: Boundary kings (4s and 6s leaders)
-- ----------------------------------------------------------------------------
SELECT 
    striker AS batsman,
    SUM(CASE WHEN runs_off_bat = 4 THEN 1 ELSE 0 END) AS fours,
    SUM(CASE WHEN runs_off_bat = 6 THEN 1 ELSE 0 END) AS sixes,
    SUM(CASE WHEN runs_off_bat IN (4, 6) THEN 1 ELSE 0 END) AS total_boundaries,
    ROUND(SUM(CASE WHEN runs_off_bat IN (4, 6) THEN runs_off_bat ELSE 0 END) * 100.0 / 
          NULLIF(SUM(runs_off_bat), 0), 2) AS boundary_percentage
FROM deliveries
GROUP BY striker
HAVING SUM(runs_off_bat) >= 50
ORDER BY total_boundaries DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Q17: Strike rate champions (minimum 100 runs)
-- ----------------------------------------------------------------------------
SELECT 
    striker AS batsman,
    SUM(runs_off_bat) AS total_runs,
    COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END) AS balls_faced,
    ROUND((SUM(runs_off_bat) * 100.0 / 
           NULLIF(COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END), 0)), 2) AS strike_rate,
    ROUND(SUM(runs_off_bat) * 1.0 / COUNT(DISTINCT match_id), 2) AS avg_per_match
FROM deliveries
GROUP BY striker
HAVING SUM(runs_off_bat) >= 100
ORDER BY strike_rate DESC
LIMIT 10;



-- ----------------------------------------------------------------------------
-- Q18: Team batting strength analysis
-- ----------------------------------------------------------------------------
SELECT 
    batting_team AS team,
    SUM(runs_off_bat + extras) AS total_runs_scored,
    COUNT(DISTINCT match_id) AS matches_played,
    ROUND(SUM(runs_off_bat + extras) * 1.0 / COUNT(DISTINCT match_id), 2) AS avg_runs_per_match
FROM deliveries
GROUP BY batting_team
ORDER BY avg_runs_per_match DESC;

-- ----------------------------------------------------------------------------
-- Q19: Bowling discipline - Extras conceded analysis
-- ----------------------------------------------------------------------------
SELECT 
    bowling_team AS team,
    SUM(wides) AS total_wides,
    SUM(noballs) AS total_noballs,
    SUM(byes + legbyes) AS total_byes_legbyes,
    SUM(extras) AS total_extras,
    ROUND(SUM(extras) * 1.0 / COUNT(DISTINCT match_id), 2) AS avg_extras_per_match
FROM deliveries
GROUP BY bowling_team
ORDER BY total_extras DESC;


-- ============================================================================
-- SECTION 5: BOWLING PERFORMANCE ANALYSIS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q20: Top wicket takers
-- ----------------------------------------------------------------------------
SELECT 
    bowler,
    COUNT(*) AS total_wickets,
    COUNT(DISTINCT match_id) AS matches_played,
    ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT match_id), 2) AS wickets_per_match
FROM deliveries
WHERE wicket_type IS NOT NULL 
    AND wicket_type NOT IN ('run out', 'retired hurt', 'obstructing the field')
GROUP BY bowler
ORDER BY total_wickets DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Q21: Economy rate champions
-- ----------------------------------------------------------------------------
SELECT
    bowler,
    legal_balls_bowled,
    CONCAT(FLOOR(legal_balls_bowled / 6), '.', legal_balls_bowled % 6) AS overs_bowled,
    runs_conceded,
    ROUND(runs_conceded * 6.0 / legal_balls_bowled, 2) AS economy_rate
FROM (
    SELECT 
        bowler,
        SUM(CASE WHEN wides = 0 AND noballs = 0 THEN 1 ELSE 0 END) AS legal_balls_bowled,
        
        SUM(runs_off_bat + wides + noballs) AS runs_conceded
    FROM deliveries
    GROUP BY bowler
) AS b
WHERE legal_balls_bowled >= 50
ORDER BY economy_rate ASC
LIMIT 100;



-- ----------------------------------------------------------------------------
-- Q22: Dismissal types distribution
-- ----------------------------------------------------------------------------
SELECT 
    wicket_type AS dismissal_mode,
    COUNT(*) AS occurrences,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM deliveries WHERE wicket_type IS NOT NULL), 2) AS percentage
FROM deliveries
WHERE wicket_type IS NOT NULL
GROUP BY wicket_type
ORDER BY occurrences DESC;


-- ----------------------------------------------------------------------------
-- Q23: Dot ball specialists
-- ----------------------------------------------------------------------------
SELECT 
    bowler,
    SUM(CASE WHEN runs_off_bat = 0 AND extras = 0 THEN 1 ELSE 0 END) AS dot_balls,
    COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END) AS legal_balls,
    ROUND(SUM(CASE WHEN runs_off_bat = 0 AND extras = 0 THEN 1 ELSE 0 END) * 100.0 / 
          NULLIF(COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END), 0), 2) AS dot_ball_percentage
FROM deliveries
GROUP BY bowler
HAVING COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END) >= 50
ORDER BY dot_ball_percentage DESC, dot_balls DESC
LIMIT 10;



-- ----------------------------------------------------------------------------
-- Q24: Team bowling strength
-- ----------------------------------------------------------------------------
SELECT 
    bowling_team AS team,
    
    SUM(
        CASE 
            WHEN wicket_type IN ('bowled', 'caught', 'lbw', 'caught and bowled', 'stumped')
            THEN 1 ELSE 0
        END
    ) AS total_wickets,
    
    SUM(
        CASE 
            WHEN wides = 0 AND noballs = 0 THEN 1 ELSE 0
        END
    ) AS legal_balls_bowled,
    
    SUM(runs_off_bat + extras) AS runs_conceded,
    
    ROUND(
        SUM(runs_off_bat + extras) * 6.0 
        / NULLIF(
            SUM(CASE WHEN wides = 0 AND noballs = 0 THEN 1 ELSE 0 END),
            0
        ), 
        2
    ) AS team_economy_rate,
    
    ROUND(
        SUM(CASE WHEN wides = 0 AND noballs = 0 THEN 1 ELSE 0 END) * 1.0 
        / NULLIF(
            SUM(
                CASE 
                    WHEN wicket_type IN ('bowled', 'caught', 'lbw', 'caught and bowled', 'stumped')
                    THEN 1 ELSE 0
                END
            ),
            0
        ), 
        2
    ) AS balls_per_wicket
FROM deliveries
GROUP BY bowling_team
ORDER BY total_wickets DESC, team_economy_rate ASC;

-- ============================================================================
-- SECTION 6: PLAYER OF THE MATCH & AWARDS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q25: Player of the Match awards leaderboard
-- ----------------------------------------------------------------------------
SELECT 
    player_of_match AS player,
    COUNT(*) AS awards_won,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE player_of_match IS NOT NULL), 2) AS percentage_of_awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards_won DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- Q26: Team-wise Player of the Match distribution
-- ----------------------------------------------------------------------------
SELECT 
    team,
    COUNT(*) AS total_potm_awards,
    COUNT(DISTINCT player_of_match) AS unique_winners
FROM (
    SELECT 
        m.player_of_match, 
        CASE 
            WHEN m.team1 = m.winner THEN m.team1
            WHEN m.team2 = m.winner THEN m.team2
        END AS team
    FROM matches m
    WHERE m.player_of_match IS NOT NULL AND m.winner IS NOT NULL
) AS player_teams
WHERE team IS NOT NULL
GROUP BY team
ORDER BY total_potm_awards DESC;


-- ============================================================================
-- SECTION 7: VENUE & MATCH DYNAMICS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q27: Venue batting difficulty index
-- ----------------------------------------------------------------------------
SELECT 
    venue,
    city,
    COUNT(DISTINCT match_id) AS matches_hosted,
    ROUND(AVG(innings_total), 2) AS avg_first_innings_score,
    MIN(innings_total) AS lowest_score,
    MAX(innings_total) AS highest_score
FROM (
    SELECT 
        match_id, 
        d.venue, 
        m.city, 
        SUM(runs_off_bat + extras) AS innings_total
    FROM deliveries d
    JOIN matches m ON d.match_id = m.match_number
    WHERE innings = 1
    GROUP BY match_id, venue, city
) AS first_innings_scores
GROUP BY venue, city
HAVING COUNT(DISTINCT match_id) >= 3
ORDER BY avg_first_innings_score DESC;

-- ----------------------------------------------------------------------------
-- Q28: High-scoring venue identification
-- ----------------------------------------------------------------------------
SELECT 
    m.venue,
    m.city,
    COUNT(*) AS high_scoring_matches,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM matches WHERE venue = m.venue), 2) AS percentage_high_scoring
FROM matches m
JOIN (
    SELECT 
        match_id, 
        SUM(runs_off_bat + extras) AS match_total
    FROM deliveries
    GROUP BY match_id
    HAVING SUM(runs_off_bat + extras) > 300
) AS high_scores ON m.match_number = high_scores.match_id
GROUP BY m.venue, m.city
ORDER BY high_scoring_matches DESC;



-- ============================================================================
-- SECTION 8: ADVANCED INSIGHTS & PHASE ANALYSIS
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Q29: Top batting partnerships
-- ----------------------------------------------------------------------------
SELECT 
    match_id,
    batting_team,
    CASE 
        WHEN striker < non_striker THEN striker 
        ELSE non_striker 
    END AS batter1,
    CASE 
        WHEN striker < non_striker THEN non_striker 
        ELSE striker 
    END AS batter2,
    SUM(runs_off_bat + extras) AS partnership_runs,
    SUM(CASE WHEN wides = 0 AND noballs = 0 THEN 1 ELSE 0 END) AS balls_faced
FROM deliveries
GROUP BY
    match_id,
    batting_team,
    CASE 
        WHEN striker < non_striker THEN striker 
        ELSE non_striker 
    END,
    CASE 
        WHEN striker < non_striker THEN non_striker 
        ELSE striker 
    END
HAVING SUM(runs_off_bat + extras) >= 50
ORDER BY partnership_runs DESC
LIMIT 15;



-- ----------------------------------------------------------------------------
-- Q30: Powerplay performance (Overs 1-6)
-- ----------------------------------------------------------------------------
SELECT 
    batting_team AS team,
    COUNT(DISTINCT match_id) AS matches,
    ROUND(AVG(powerplay_runs), 2) AS avg_powerplay_runs,
    ROUND(AVG(powerplay_wickets), 2) AS avg_powerplay_wickets,
    ROUND(AVG(powerplay_runs * 6.0 / powerplay_balls), 2) AS powerplay_run_rate
FROM (
    SELECT 
        match_id,
        batting_team,
        SUM(runs_off_bat + extras) AS powerplay_runs,
        COUNT(CASE WHEN wicket_type IS NOT NULL THEN 1 END) AS powerplay_wickets,
        COUNT(CASE WHEN wides = 0 AND noballs = 0 THEN 1 END) AS powerplay_balls
    FROM deliveries
    WHERE ball <= 6.0
    GROUP BY match_id, batting_team
) AS powerplay_stats
GROUP BY batting_team
ORDER BY avg_powerplay_runs DESC;


-- ----------------------------------------------------------------------------
-- Q31: Death overs mastery (Overs 16-20)
-- ----------------------------------------------------------------------------
SELECT 
    bowling_team AS team,
    COUNT(DISTINCT match_id) AS matches,
    COUNT(CASE WHEN wicket_type IS NOT NULL THEN 1 END) AS death_wickets,
    SUM(runs_off_bat + extras) AS death_runs_conceded,
    ROUND((SUM(runs_off_bat + extras) * 6.0 / COUNT(*)), 2) AS death_economy_rate,
    ROUND(SUM(runs_off_bat + extras) * 1.0 / COUNT(DISTINCT match_id), 2) AS avg_death_runs_per_match
FROM deliveries
WHERE ball >= 16.0
GROUP BY bowling_team
ORDER BY death_economy_rate ASC, death_wickets DESC;


-- ============================================================================
-- TOURNAMENT SUMMARY STATISTICS
-- ============================================================================

SELECT 
    'Total Matches' AS metric,
    COUNT(*) AS value
FROM matches
UNION ALL
SELECT 
    'Total Deliveries',
    COUNT(*)
FROM deliveries
UNION ALL
SELECT 
    'Total Runs Scored',
    SUM(runs_off_bat + extras)
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


-- ============================================================================
-- END OF CASE STUDY
-- ============================================================================