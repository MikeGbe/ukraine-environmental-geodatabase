# Ukraine Environmental Monitoring Geodatabase

This project implements a spatially enabled PostgreSQL/PostGIS geodatabase to monitor industrial pollution and assess environmental infrastructure across Eastern Ukraine, with a focus on the Donetsk Oblast. The system is designed to help planners and environmental specialists identify gaps in monitoring coverage and assess the potential environmental impact of mining activities.

## 📍 Project Objectives

- Create a centralized geodatabase to store environmental, industrial, and administrative spatial data
- Use spatial queries and aggregation to identify districts at environmental risk
- Visualize results in QGIS via a live PostGIS connection

## 📂 Data Sources

- **Water Bodies** (OpenStreetMap)
- **Mines** (Curated from public datasets)
- **Admin Districts** (ArcGIS Online)
- **Hydrological Monitoring Stations** (State Hydro Network)
- **City Classifications** (Statistical tables)

## 🧱 Schema Overview

![ER Diagram](docs/er_diagram.png)

Key tables:
- `waterbodies (Polygon)`
- `mines (Point)`
- `hydro_stations (Point)`
- `admin_districts (Polygon)`
- `cities (Polygon)`
- `city_class (Table)`

## 🔍 Key Questions Answered

1. **Top mining districts** – Which districts have the highest number of mines (by status)?
2. **Gaps in monitoring** – Which districts with water bodies have no hydrological stations?
3. **Proximity checks** – What is the farthest distance between any water body and the nearest hydrological station?
4. **Mine–water proximity** – What is the shortest distance between a mine and a nearby body of water?
5. **Risk assessment** – Which districts contain both mines and water but no monitoring infrastructure?

## 🧪 Sample Query

```sql
-- Find districts with mines and water bodies but no hydro monitoring stations
SELECT d.admin_name, COUNT(DISTINCT m.mine_id) as mine_count
FROM admin_districts d
JOIN mines m ON ST_Intersects(d.geom, m.geom)
JOIN waterbodies w ON ST_Intersects(d.geom, w.geom)
LEFT JOIN hydro_stations h ON ST_Intersects(d.geom, h.geom)
WHERE h.point_id IS NULL
GROUP BY d.admin_name;
```

## 🗺 Visualizations

Final query results and views were visualized using QGIS. The project includes:

- Spatial joins and overlays between mines, waterbodies, and monitoring stations
- Choropleth maps of mine density per district
- Distance buffers from hydrological stations
- Highlighted districts with infrastructure gaps (e.g., water but no monitoring)

See the `docs/` folder for sample screenshots, and the `qgis/` folder for the full project file (`.qgz`).

## 🛠 Tech Stack

- **PostgreSQL 14** with **PostGIS 3.x** – Spatial database for storing and querying geodata
- **pgAdmin 4** – GUI for managing the database
- **QGIS 3.x** – GIS desktop software used for visualization and reprojection
- **Python (optional)** – For scripting and executing queries with `psycopg2` or `geopandas`
- **Git/GitHub** – Version control and project hosting

