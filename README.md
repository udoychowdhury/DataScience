# DataScience
My repository for all things related to Data Science, Machine Learning, AI, and other small Python programs.
**Q: Where is the data from and how was it collected/extracted?**
**A**: The data is from Kaggle which was uploaded by Stefano Leone. Essentially it is a database of male soccer players and is from all Fifa video games from Fifa 15 to EA Sports FC 24. It contains every player, coach, and team from the last 10 versions of the game. It was last updated on 22nd September 2023. It was collected through a systematic compilation of player statistics, attributes, and performance metrics from the past 10 years of video games on the website [sofifa.com](https://sofifa.com/). Stefano extracted the data by scraping the publicly available website that I just mentioned and published it on Kaggle for public use.

**Q: What program was used to clean the data and How was it cleaned or transformed? Be specific.**
**A**: The data was clean beforehand but I used Python in a jupyter notebook to clean it even further. Out of the 109 columns, 20+ columns have missing data for at least 20,000 rows. I removed the rows that have empty player pace, shooting, passing, dribbling, defending, and physicals since those are pretty much the main data points in FIFA player cards. Without it, there is not much to get from the row. Afterwards, I tried to get rid of duplicates but there were none. For data type changes, I did the following:

- 'update_as_of', 'dob', 'club_joined_date’ into datetime
- ‘club_contract_valid_until_year’ into a string
- 'fifa_version', 'release_clause_eur', 'club_contract_valid_until_year', 'value_eur', 'wage_eur', 'club_jersey_number', 'league_id', 'club_team_id', 'league_level', 'nation_team_id', 'nation_jersey_number', 'pace', 'shooting', 'passing', 'dribbling', 'defending', 'physic', 'mentality_composure' into int

After that, I made sure all column names were lowercase so it was more pleasing to the eye. Then I made three new columns to change all euro/kg/cm columns into dollar/lbs/in columns such as value_dol, wage_dol, release_clause_dol, weight_lbs, and height_in. Afterward, I dropped unneeded columns such as 'player_url', 'update_as_of', 'fifa_update', 'international_reputation', and 'real_face'. Lastly, I defined the order in which I want the columns.

**Q: What are the units of the numeric data?**
**A**: The dataset includes various units: Euros (**`value_eur`**, **`wage_eur`**, **`release_clause_eur`**), US Dollars (**`value_dol`**, **`wage_dol`**, **`release_clause_dol`**), centimeters (**`height_cm`**), inches (**`height_in`**), kilograms (**`weight_kg`**), pounds (**`weight_lbs`**), and plain numerical values for attributes like **`overall`**, **`potential`**, **`age`**, and player skills (e.g., **`pace`**, **`shooting`**).

**Q: What were the formulas used in column creation?**
**A**: Specific formulas that were used to create the player overalls/statistics were not listed but it is generally found through researching player performance throughout the year. However, columns like `value_dol`, `wage_dol`, and `release_clause_dol' was created by converting the euro to dollar currency exchange rate. The weight_lbs was created using the kg to lbs conversion rate and height_in` was created by using the cm to in conversion rate.

**Q: How is the data validated to ensure consistency?**
**A**: Data validation was done by checking for duplicates using the player and year as primary keys and there were no duplicates to be found. Furthermore, the transformations that I mentioned earlier are further steps to be taken to ensure the validity of the data. 

**Q: What are the definitions for the column names? Include all columns in your dataset.**
**A**: 
1. **player_id**: Unique identifier for the player.
2. **fifa_version**: The version of the FIFA video game the data is associated with.
3. **short_name**: Player's commonly used name.
4. **long_name**: Player's full legal name.
5. **player_positions**: Positions the player is proficient in.
6. **overall**: Overall rating of the player.
7. **potential**: Potential rating indicating the player's possible future rating.
8. **value_eur**: Market value of the player in euros.
9. **value_dol**: Market value of the player in US dollars.
10. **wage_eur**: Weekly wage of the player in euros.
11. **wage_dol**: Weekly wage of the player in US dollars.
12. **age**: Age of the player.
13. **dob**: Date of birth.
14. **height_cm**: Height in centimeters.
15. **height_in**: Height in inches.
16. **weight_kg**: Weight in kilograms.
17. **weight_lbs**: Weight in pounds.
18. **club_team_id**: Unique identifier for the player's club team.
19. **club_name**: Name of the club the player is currently in.
20. **league_id**: Unique identifier for the league of the club.
21. **league_name**: Name of the league the club competes in.
22. **league_level**: Level of the competition league.
23. **club_position**: Playing position in the club.
24. **club_jersey_number**: Jersey number at the club.
25. **club_loaned_from**: Club the player is loaned from, if applicable.
26. **club_joined_date**: Date the player joined the club.
27. **club_contract_valid_until_year**: Year until the player's contract with the club is valid.
28. **nationality_id**: Unique identifier for the player's nationality.
29. **nationality_name**: Nationality of the player.
30. **nation_team_id**: Unique identifier for the player's national team, if applicable.
31. **nation_position**: Playing position in the national team.
32. **nation_jersey_number**: Jersey number at the national team.
33. **preferred_foot**: Preferred foot for playing.
34. **weak_foot**: Rating of the player's weaker foot.
35. **skill_moves**: Rating of the player's skill moves.
36. **work_rate**: Player's work rate in matches.
37. **body_type**: Description of the player's body type.
38. **release_clause_eur**: Release clause in euros.
39. **release_clause_dol**: Release clause in US dollars.
40. **player_tags**: Special tags indicating player's notable attributes or achievements.
41. **player_traits**: Specific traits of the player.
42-109. **Skill attributes (pace, shooting, passing, dribbling, defending, physical, etc.)**: Ratings for specific aspects of the player's abilities, including attacking, skill, movement, power, mentality, defending, goalkeeping, and then their overall based on each positional play (like LS, ST, RS, LW, etc.).

**Q: If there are set variable options in your dataset, what are their definitions?**
**A**: 
- **Player Tags and Traits**: These are usually specific labels or descriptors assigned to players based on their playing style, achievements, or unique skills. In the FIFA video game series, tags might include descriptors like "Dribbler", "Playmaker", or "Aerial Threat", while traits could be "Injury Prone", "Leadership", or "Flair". Each tag or trait affects how a player performs in specific situations or influences their interactions on the pitch.
- **League Level**:
    - Indicates the tier or level of competition the player's league belongs to, typically ranging from top-tier national leagues to lower divisions. Specific definitions or tier numbers were not provided, but generally, "1" would indicate a top division, with higher numbers indicating lower divisions.
- **preferred_foot**:
  - **Left**: The player prefers to use their left foot for playing.
  - **Right**: The player prefers to use their right foot for playing.
- **work_rate**:
  - **High**: Indicates a player who consistently exerts a lot of effort throughout the game.
  - **Medium**: Indicates a player who balances their effort between attacking and defending.
  - **Low**: Indicates a player who conserves their energy or focuses less on consistent effort.
- **body_type**:
  - This categorizes players based on their physical build, which can affect their in-game physics and performance. Specific body types might be generic (like "Lean", "Stocky") or named after specific players in certain versions of the FIFA games, but without detailed data, generic descriptions are assumed.
- **player_positions**:
  - Players can have multiple positions, indicating their versatility. Positions are abbreviated (e.g., "ST" for Striker, "LW" for Left Wing, "CB" for Center Back), each reflecting the role and area of play on the soccer field.
- **club_position**, **nation_position**:
  - Similar to **`player_positions`**, these fields specify the player's position but within their club or national team context. The abbreviations follow the same pattern as **`player_positions`**.
- **nation_jersey_number**, **club_jersey_number**:
  - While not a set of predefined options, jersey numbers are traditionally chosen from 1 to 99, with certain numbers often associated with specific positions (e.g., 1 for goalkeepers, 10 for playmakers).
- **skill_moves**, **weak_foot**:
  - These are rated on a scale from 1 to 5, with 1 being the lowest and 5 being the highest. They quantify a player's proficiency in executing skill moves and their ability to use their weaker foot, respectively.

**Q: What are the regulations for using the data?**
**A**: Specific regulations or usage rights for this dataset are not mentioned. However, since it is a public video game and public data set, there are most likely no regulations when using this data. As described in https://sofifa.com/robots.txt, there is no limitation at the time of scraping for collecting data for FIFA players, coaches, and teams.
