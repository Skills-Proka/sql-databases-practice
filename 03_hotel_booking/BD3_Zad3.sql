WITH hotel_category AS (
    SELECT
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE
            WHEN AVG(r.price) < 175  THEN 'Дешевый'
            WHEN AVG(r.price) <= 300 THEN 'Средний'
            ELSE                          'Дорогой'
        END AS category
    FROM Hotel h
    JOIN Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
customer_hotels AS (
    SELECT DISTINCT
        c.ID_customer,
        c.name         AS customer_name,
        hc.hotel_name,
        hc.category
    FROM Customer c
    JOIN Booking b      ON c.ID_customer = b.ID_customer
    JOIN Room r         ON b.ID_room = r.ID_room
    JOIN hotel_category hc ON r.ID_hotel = hc.ID_hotel
)
SELECT
    ID_customer,
    customer_name                                                        AS name,
    CASE
        WHEN MAX(CASE WHEN category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 'Дорогой'
        WHEN MAX(CASE WHEN category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 'Средний'
        ELSE 'Дешевый'
    END                                                                  AS preferred_hotel_type,
    STRING_AGG(DISTINCT hotel_name, ',' ORDER BY hotel_name)            AS visited_hotels
FROM customer_hotels
GROUP BY ID_customer, customer_name
ORDER BY
    CASE
        WHEN MAX(CASE WHEN category = 'Дорогой' THEN 1 ELSE 0 END) = 1 THEN 3
        WHEN MAX(CASE WHEN category = 'Средний' THEN 1 ELSE 0 END) = 1 THEN 2
        ELSE 1
    END,
    ID_customer;