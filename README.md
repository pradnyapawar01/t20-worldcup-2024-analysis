# 🏏 ICC T20 Men's World Cup 2024 - SQL Data Analysis

[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue?logo=mysql)](https://www.mysql.com/)
[![SQL](https://img.shields.io/badge/SQL-Advanced-green)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Complete-success)]()

> A comprehensive SQL-based analysis of the ICC T20 Men's World Cup 2024, featuring 31 analytical queries across tournament statistics, team performance, player metrics, and strategic insights.

---

## 🎯 Project Overview

This project demonstrates advanced SQL analytical capabilities through a comprehensive examination of the ICC T20 Men's World Cup 2024. Using MySQL 8.0+, the analysis covers 52 matches and 11,472 ball-by-ball deliveries to extract meaningful insights about team performance, player statistics, and tournament dynamics.

### Objectives
- Analyze team and player performance across the tournament
- Identify strategic patterns in toss decisions and match outcomes
- Evaluate venue characteristics and their impact on gameplay
- Provide data-driven insights for cricket analytics

### Dataset
- **Matches Data**: 52 matches across 9 venues
- **Deliveries Data**: 11,472 ball-by-ball records
- **Time Period**: June 2024
- **Teams**: 20 international teams

---

## 🔑 Key Insights

### Tournament Champions
- **Winner**: India (Undefeated - 8 wins, 0 losses, 100% win rate)
- **Runners-up**: South Africa (8 wins, 1 loss, 88.89% win rate)
- **Total Runs Scored**: 13,064 runs across all matches
- **Total Wickets**: 684 dismissals
- **Total Boundaries**: 1,487 (519 sixes, 968 fours)

### Top Performers

#### 🏏 Batting Excellence
| Player | Runs | Matches | Avg per Match | Strike Rate |
|--------|------|---------|---------------|-------------|
| Rahmanullah Gurbaz | 281 | 8 | 35.13 | 124.34 |
| Rohit Sharma | 257 | 8 | 32.13 | 156.71 |
| Travis Head | 255 | 7 | 36.43 | 158.39 |
| Quinton de Kock | 243 | 8 | 30.38 | 140.46 |

**Insight**: Travis Head and Rohit Sharma both maintained exceptional strike rates above 155 while accumulating significant runs, showcasing aggressive T20 batting.

#### ⚡ Bowling Dominance
| Bowler | Wickets | Matches | Wickets per Match | Economy Rate |
|--------|---------|---------|-------------------|--------------|
| Fazalhaq Farooqi | 17 | 6 | 2.83 | 6.32 |
| Arshdeep Singh | 17 | 7 | 2.43 | 7.17 |
| Jasprit Bumrah | 15 | 7 | 2.14 | 4.18 |
| Anrich Nortje | 15 | 8 | 1.88 | 5.74 |

**Insight**: Jasprit Bumrah combined wicket-taking prowess (15) with exceptional economy (4.18), making him invaluable across all match phases.

#### 🎯 Boundary Kings
| Player | Fours | Sixes | Total Boundaries |
|--------|-------|-------|------------------|
| Travis Head | 26 | 15 | 41 |
| Rohit Sharma | 24 | 15 | 39 |
| Rahmanullah Gurbaz | 18 | 16 | 34 |
| Quinton de Kock | 21 | 13 | 34 |

### Strategic Analysis

#### 🎲 Toss Impact
- **Field First Preference**: 80.77% of teams chose to field after winning toss
- **Toss-to-Win Conversion**: 52.50% for field-first, 50.00% for bat-first
- **Perfect Conversion**: India (100%), West Indies (100%), South Africa (100%)
- **Key Finding**: Minimal overall toss advantage, indicating balanced conditions

#### 🏟️ Venue Characteristics
| Venue | City | Matches | Avg 1st Innings Score |
|-------|------|---------|----------------------|
| Daren Sammy National Cricket Stadium | Gros Islet | 6 | 182.00 |
| Sir Vivian Richards Stadium | North Sound | 8 | 157.00 |
| Providence Stadium | Providence | 6 | 139.67 |
| Kensington Oval | Bridgetown | 9 | 134.75 |

**Insight**: 47-run difference between highest and lowest scoring venues shows significant venue impact on batting conditions.

### Match Dynamics

#### ⚡ Powerplay Analysis (Overs 1-6)
- **Best Performing Teams**: 
  - West Indies: 54.29 runs average, 9.05 run rate
  - Australia: 54.00 runs average, 9.10 run rate
  - England: 50.57 runs average, 9.49 run rate
- **Aggressive Approach**: Top teams consistently scored at 9+ runs per over

#### 💀 Death Overs Mastery (Overs 16-20)
- **Best Death Bowling**: Bangladesh (5.79 economy rate)
- **Most Wickets in Death**: India (21 wickets)
- **Best Control**: India combined economy (6.11) with wickets (21)
- **Critical Phase**: Death bowling economy directly correlated with match wins

#### 🤝 Top Partnerships
| Match | Team | Batsmen | Runs | Balls |
|-------|------|---------|------|-------|
| Afghanistan vs Uganda | Afghanistan | Ibrahim Zadran & Rahmanullah Gurbaz | 154 | 87 |
| USA vs Canada | USA | Aaron Jones & AGS Gous | 131 | 55 |
| Afghanistan vs PNG | Afghanistan | Ibrahim Zadran & Rahmanullah Gurbaz | 118 | 95 |

### Dominant Victories
- **Largest Win by Runs**: West Indies beat Uganda by 134 runs
- **Largest Win by Wickets**: England beat USA with 10 wickets remaining
- **Most High-Scoring Venue**: Sir Vivian Richards Stadium (4 matches over 300 total runs)

### Dismissal Patterns
- **Caught**: 401 (58.63%) - Most common dismissal
- **Bowled**: 131 (19.15%)
- **LBW**: 72 (10.53%)
- **Run Out**: 39 (5.70%)
- **Others**: 41 (6.00%)

---

## 🗄️ Database Schema

### Entity Relationship Diagram

```
┌─────────────────────┐              ┌──────────────────────┐
│      MATCHES        │              │     DELIVERIES       │
├─────────────────────┤              ├──────────────────────┤
│ match_number (PK)   │◄─────────────│ match_id (FK)        │
│ season              │              │ season               │
│ team1               │              │ start_date           │
│ team2               │              │ venue                │
│ match_date          │              │ innings              │
│ venue               │              │ ball                 │
│ city                │              │ batting_team         │
│ toss_winner         │              │ bowling_team         │
│ toss_decision       │              │ striker              │
│ player_of_match     │              │ non_striker          │
│ winner              │              │ bowler               │
│ winner_runs         │              │ runs_off_bat         │
│ winner_wickets      │              │ extras               │
│ match_type          │              │ wides                │
└─────────────────────┘              │ noballs              │
                                     │ byes                 │
                                     │ legbyes              │
                                     │ wicket_type          │
                                     │ player_dismissed     │
                                     └──────────────────────┘
```

### Table Descriptions

**matches** (52 records)
- Match metadata including teams, dates, venues
- Tournament structure and match types
- Toss information and decisions
- Match outcomes and victory margins
- Player of the Match awards

**deliveries** (11,472 records)
- Ball-by-ball data for every delivery
- Batting and bowling details
- Runs scored (off bat and extras)
- Wicket information and dismissals
- Partnership tracking data

---

## 📊 Analysis Categories

### 1️⃣ Tournament Overview & Statistics (Q1-Q5)
Foundational metrics about tournament structure
- Total matches: 52
- Total teams: 20
- Venue distribution: 9 venues across Caribbean and USA
- Match type breakdown: 94.23% Group, 3.85% Semi-Final, 1.92% Final

### 2️⃣ Team Performance Analysis (Q6-Q10)
Comprehensive team-level statistics
- Win-loss records and percentages
- Victory margin analysis (runs & wickets)
- Most dominant victories
- Teams with no result matches

**Key Finding**: India's perfect 8-0 record, followed by South Africa's 8-1

### 3️⃣ Toss Analysis & Strategic Decisions (Q11-Q14)
Understanding the impact of toss on match outcomes
- Toss decision preferences
- Win correlation with toss results
- Team-wise conversion rates
- Success rate by decision (bat/field)

**Key Finding**: 80.77% chose to field first, but only 52.5% conversion rate

### 4️⃣ Batting Performance Analysis (Q15-Q19)
Individual and team batting metrics
- Top run scorers across tournament
- Boundary kings (4s and 6s)
- Strike rate champions
- Team batting strength
- Extras conceded analysis

**Key Finding**: Rohit Sharma's 156.71 strike rate with 257 runs

### 5️⃣ Bowling Performance Analysis (Q20-Q24)
Bowling excellence and control
- Top wicket takers
- Economy rate leaders
- Dismissal type distribution
- Dot ball specialists
- Team bowling strength

**Key Finding**: Tim Southee's 3.00 economy rate (lowest qualified)

### 6️⃣ Player of the Match & Awards (Q25-Q26)
Recognition of outstanding performances
- Individual award distribution
- Team-wise award analysis
- Consistent performers

**Key Finding**: India had 8 POTM awards with 7 unique winners

### 7️⃣ Venue & Match Dynamics (Q27-Q28)
Environmental factors and their impact
- Venue batting difficulty index
- High-scoring ground identification
- First innings score analysis
- Venue-specific strategies

**Key Finding**: Daren Sammy Stadium averaged 182 runs per innings

### 8️⃣ Advanced Insights & Phase Analysis (Q29-Q31)
Deep-dive into match phases
- Top batting partnerships
- Powerplay performance (Overs 1-6)
- Death overs mastery (Overs 16-20)
- Phase-wise team comparisons

**Key Finding**: Bangladesh's exceptional 5.79 death overs economy

---

## 💻 Technical Implementation

### SQL Techniques Demonstrated

#### Core Concepts
```sql
-- Aggregation Functions
SUM(), COUNT(), AVG(), MIN(), MAX(), ROUND()

-- Grouping & Filtering
GROUP BY, HAVING, WHERE

-- Joins
INNER JOIN, LEFT JOIN, Self Joins

-- Subqueries
Nested SELECT, Derived Tables, Inline Views

-- Conditional Logic
CASE WHEN, COALESCE, NULLIF

-- Set Operations
UNION, UNION ALL

-- Window Functions
OVER (PARTITION BY), ROW_NUMBER()
```

#### Advanced Features
- **Complex Aggregations**: Multi-level grouping and calculations
- **Percentage Calculations**: Business metrics and conversion rates
- **NULL Handling**: NULLIF for division by zero prevention
- **Data Type Conversions**: Proper casting for accurate calculations
- **String Operations**: CONCAT for readable outputs
- **Performance Optimization**: Strategic filtering and indexing


---

## 🛠️ Tools & Technologies

| Category | Tool | Purpose | Version |
|----------|------|---------|---------|
| **Database** | MySQL | RDBMS | 8.0+ |
| **IDE** | MySQL Workbench | Query Development | Latest |
| **Language** | SQL | Data Analysis | Standard |

---

## 📁 Project Structure

```
t20-worldcup-2024-analysis/
│
├── data/
│   ├── matches.csv
│   └── deliveries.csv
│
├── sql/
│   ├── data_import.sql
│   └── t20_worldcup_queries.sql
│
├── README.md
└── LICENSE
```

---

## 📊 Project Statistics

| Metric | Value |
|--------|-------|
| **Total SQL Queries** | 31 analytical queries |
| **Lines of SQL Code** | 1,200+ |
| **Data Points Analyzed** | 11,472 deliveries |
| **Matches Covered** | 52 |
| **Teams Analyzed** | 20 |
| **Players Tracked** | 200+ |
| **Venues Studied** | 9 |
| **Time Period** | June 2024 |
| **Database Size** | ~2 MB |
| **Query Categories** | 8 sections |

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the Repository**
2. **Create Feature Branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit Changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to Branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open Pull Request**

### Contribution Ideas
- Add new analytical queries
- Optimize existing queries
- Create visualizations
- Improve documentation
- Add test cases
- Fix bugs

---

## 📧 Contact & Connect

**Pradnya Pawar**

- 📧 Email: pradnyapawar.work@gmail.com
- 💼 LinkedIn: [linkedin.com/in/pradnyapawar01](https://www.linkedin.com/in/pradnyapawar01/)
- 🐙 GitHub: [@pradnyapawar01](https://github.com/pradnyapawar01)

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Data Source**: ICC T20 World Cup 2024 official statistics
- **Inspiration**: Cricket analytics and data science community
- **Tools**: MySQL, MySQL Workbench

---

## 🌟 Show Your Support

If you found this project helpful or interesting:

- ⭐ **Star this repository**
- 🍴 **Fork it for your own analysis**
- 📢 **Share it with others**
- 💬 **Provide feedback**
- 🐛 **Report issues**
- 🎯 **Suggest improvements**

---

<div align="center">

**Made with ❤️ by Pradnya**

</div>