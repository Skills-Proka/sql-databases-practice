WITH car_avg AS (
    SELECT
        c.name          AS car_name,
        c.class         AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race)   AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
class_stats AS (
    SELECT
        car_class,
        SUM(race_count)                                          AS total_races,
        COUNT(*) FILTER (WHERE average_position >= 3.0)         AS low_position_count
    FROM car_avg
    GROUP BY car_class
)
SELECT
    ca.car_name,
    ca.car_class,
    ca.average_position,
    ca.race_count,
    cl.country  AS car_country,
    cs.total_races,
    cs.low_position_count
FROM car_avg ca
JOIN class_stats cs ON ca.car_class = cs.car_class
JOIN Classes cl ON ca.car_class = cl.class
WHERE ca.average_position > 3.0
ORDER BY cs.low_position_count DESC, ca.car_class, ca.average_position;