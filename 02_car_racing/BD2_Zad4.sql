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
class_stats AS (
    SELECT
        car_class,
        AVG(average_position) AS class_avg,
        COUNT(*)               AS car_count
    FROM car_stats
    GROUP BY car_class
    HAVING COUNT(*) >= 2
)
SELECT
    cs.car_name,
    cs.car_class,
    cs.average_position,
    cs.race_count,
    cl.country AS car_country
FROM car_stats cs
JOIN class_stats css ON cs.car_class = css.car_class
JOIN Classes cl ON cs.car_class = cl.class
WHERE cs.average_position < css.class_avg
ORDER BY cs.car_class, cs.average_position;