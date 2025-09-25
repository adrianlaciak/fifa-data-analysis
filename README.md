# FIFA Data Analysis (2017–2022)

This repository contains a complete workflow for **analyzing FIFA player data** across multiple editions (FIFA 17–FIFA 22), using **SQL Server** for data processing and **Power BI** for interactive reporting.

## 📂 Repository Structure
- `Fifa.sql` – SQL script that:
  - Creates database schema (`players`, `fifa_players`, `value`, `stat`, `photo`)
  - Cleans raw FIFA datasets (replacing `nan`, normalizing values/wages)
  - Loads player information, statistics, values, and club logos
  - Aggregates positions into categories (Attackers, Midfielders, Defenders, Goalkeepers)

- `Fifa.pbix` – Power BI report that visualizes:
  - Average player ratings (overall, potential, pace, shooting, passing, etc.)
  - Trends in values and wages across FIFA editions
  - KPI indicators showing growth or decline in club performance
  - Logos, flags, and club visuals for better presentation

## 🛠️ Technologies Used
- **SQL Server** (T-SQL, data cleaning, schema design, ETL logic)
- **Power BI Desktop** (data modeling, measures, dashboards, KPI visuals)

## 🚀 How to Use
1. Run the `Fifa.sql` script in SQL Server to set up the database and load FIFA data.
2. Open `Fifa.pbix` in Power BI Desktop.
3. Connect the Power BI report to your SQL Server database.
4. Explore dashboards with filters for clubs, nationalities, and FIFA editions.

## 📊 Example Insights
- Track how player `Overall` and `Potential` evolved across FIFA editions.
- Compare club average ratings and wages year over year.
- Identify trends in player positions and performance attributes.
