WITH car_stats AS (
    SELECT
        c.name          AS car_name,
        c.class         AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race)   AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
class_avg AS (
    SELECT car_class, AVG(average_position) AS class_avg_pos
    FROM car_stats
    GROUP BY car_class
),
best_classes AS (
    SELECT car_class
    FROM class_avg
    WHERE class_avg_pos = (SELECT MIN(class_avg_pos) FROM class_avg)
),
class_total_races AS (
    SELECT c.class AS car_class, COUNT(r.race) AS total_races
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.class
)
SELECT
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cl.country  AS car_country,
    ctr.total_races
FROM car_stats cs
JOIN best_classes bc ON cs.car_class = bc.car_class
JOIN Classes cl ON cs.car_class = cl.class
JOIN class_total_races ctr ON cs.car_class = ctr.car_class
ORDER BY cs.car_name;