CREATE TABLE travelers (
    traveler_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE airlines (
    airline_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hotels (
    hotel_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    star_rating INTEGER CHECK (star_rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE routes (
    route_id SERIAL PRIMARY KEY,
    origin VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    distance_km INTEGER CHECK (distance_km > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    traveler_id INTEGER REFERENCES travelers(traveler_id) ON DELETE CASCADE,
    airline_id INTEGER REFERENCES airlines(airline_id) ON DELETE SET NULL,
    route_id INTEGER REFERENCES routes(route_id) ON DELETE SET NULL,
    price NUMERIC(10,2) CHECK (price >= 0),
    purchase_date DATE NOT NULL,
    flight_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hotel_bookings (
    booking_id SERIAL PRIMARY KEY,
    traveler_id INTEGER REFERENCES travelers(traveler_id) ON DELETE CASCADE,
    hotel_id INTEGER REFERENCES hotels(hotel_id) ON DELETE SET NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INTEGER CHECK (number_of_guests > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO travelers (first_name, last_name, email, phone) VALUES
('Иван', 'Иванов', 'ivan.ivanov@example.com', '123-456-7890'),
('Мария', 'Петрова', 'maria.petrova@example.com', '098-765-4321'),
('Алексей', 'Сидоров', 'alexey.sidorov@example.com', '555-666-7777');

INSERT INTO airlines (name, country) VALUES
('Air Russia', 'Россия'),
('Aeroflot', 'Россия'),
('Wizz Air', 'Венгрия');

INSERT INTO hotels (name, location, star_rating) VALUES
('Отель "Золотой Дракон"', 'Москва', 5),
('Отель "Солнечный"', 'Сочи', 4),
('Отель "Лазурный Берег"', 'Санкт-Петербург', 3);

INSERT INTO routes (origin, destination, distance_km) VALUES
('Москва', 'Санкт-Петербург', 700),
('Москва', 'Сочи', 1500),
('Санкт-Петербург', 'Вена', 1700);

INSERT INTO tickets (traveler_id, airline_id, route_id, price, purchase_date, flight_date) VALUES
(1, 1, 1, 15000.00, '2023-09-01', '2023-10-25'),
(2, 2, 2, 20000.00, '2023-09-05', '2023-11-15'),
(3, 1, 3, 18000.00, '2023-09-10', '2023-12-05'),
(1, 3, 2, 12000.00, '2023-09-15', '2023-11-20'),
(2, 2, 1, 16000.00, '2023-09-20', '2023-10-30');

INSERT INTO hotel_bookings (traveler_id, hotel_id, check_in_date, check_out_date, number_of_guests) VALUES
(1, 1, '2023-10-25', '2023-10-30', 2),
(2, 2, '2023-11-15', '2023-11-20', 1),
(3, 3, '2023-12-05', '2023-12-10', 3),
(1, 2, '2023-11-20', '2023-11-25', 2),
(2, 1, '2023-10-30', '2023-11-04', 1);

SELECT
    a.airline_id,  
    a.name AS airline_name,
    COUNT(t.ticket_id) AS tickets_sold,
    ROW_NUMBER() OVER (ORDER BY COUNT(t.ticket_id) DESC) AS rank
FROM airlines a
LEFT JOIN tickets t ON a.airline_id = t.airline_id
GROUP BY a.airline_id, a.name
ORDER BY rank;

-----------

WITH ticket_counts AS (
    SELECT
        a.airline_id,
        a.name AS airline_name,
        COUNT(t.ticket_id) OVER (PARTITION BY a.airline_id) AS tickets_sold
    FROM airlines a
    LEFT JOIN tickets t ON a.airline_id = t.airline_id
)
SELECT
    airline_id,
    airline_name,
    tickets_sold,
    ROW_NUMBER() OVER (ORDER BY tickets_sold DESC) AS rank
FROM ticket_counts
GROUP BY airline_id, airline_name, tickets_sold
ORDER BY rank;

--------------------------------------

SELECT
    r.route_id,
    r.origin,
    r.destination,
    AVG(t.price) OVER (PARTITION BY r.route_id) AS average_price
FROM routes r
JOIN tickets t ON r.route_id = t.route_id
ORDER BY r.route_id;

------------

SELECT
    route_id,
    origin,
    destination,
    average_price,
    RANK() OVER (ORDER BY average_price DESC) AS rank
FROM (
    SELECT
        r.route_id,
        r.origin,
        r.destination,
        AVG(t.price) AS average_price
    FROM routes r
    JOIN tickets t ON r.route_id = t.route_id
    GROUP BY r.route_id, r.origin, r.destination
) AS route_avg
ORDER BY rank;

--------------------------------------

SELECT
    h.hotel_id,
    h.name AS hotel_name,
    COUNT(b.booking_id) AS bookings_count,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank
FROM hotels h
LEFT JOIN hotel_bookings b ON h.hotel_id = b.hotel_id
GROUP BY h.hotel_id, h.name
ORDER BY rank;

--------------------

WITH booking_counts AS (
    SELECT
        h.hotel_id,
        h.name AS hotel_name,
        COUNT(b.booking_id) AS bookings_count
    FROM hotels h
    LEFT JOIN hotel_bookings b ON h.hotel_id = b.hotel_id
    GROUP BY h.hotel_id, h.name
)
SELECT
    hotel_id,
    hotel_name,
    bookings_count,
    RANK() OVER (ORDER BY bookings_count DESC) AS rank
FROM booking_counts
ORDER BY rank;



