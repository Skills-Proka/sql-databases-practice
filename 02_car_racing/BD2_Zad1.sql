WITH car_stats AS (
    SELECT
        c.name        AS car_name,
        c.class       AS car_class,
        AVG(r.position) AS average_position,
        COUNT(r.race)   AS race_count
    FROM Cars c
    JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
),
min_per_class AS (
    SELECT car_class, MIN(average_position) AS min_avg_pos
    FROM car_stats
    GROUP BY car_class
)
SELECT cs.car_name, cs.car_class, cs.average_position, cs.race_count
FROM car_stats cs
JOIN min_per_class mpc
    ON cs.car_class = mpc.car_class
    AND cs.average_position = mpc.min_avg_pos
ORDER BY cs.average_position, cs.car_name;