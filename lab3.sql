CREATE TABLE Travelers (
    traveler_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20),
    passport_number VARCHAR(20) UNIQUE
);

CREATE TABLE Airlines (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100) NOT null
);

CREATE TABLE Hotels (
    hotel_id INT PRIMARY KEY,
    hotel_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    star_rating INT CHECK (star_rating >= 1 AND star_rating <= 5),
    room_price DECIMAL(10, 2)
);

CREATE TABLE TouristRoutes (
    route_id INT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    destination VARCHAR(100),
    duration INT NOT NULL CHECK (duration > 0),
    price DECIMAL(10, 2)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    traveler_id INT,
    airline_id INT,
    flight_number VARCHAR(20),
    departure_date DATE NOT NULL,
    arrival_date DATE NOT NULL,
    price DECIMAL(10, 2),
    FOREIGN KEY (traveler_id) REFERENCES Travelers(traveler_id),
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id)
);

CREATE TABLE HotelBookings (
    booking_id INT PRIMARY KEY,
    traveler_id INT,
    hotel_id INT,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    FOREIGN KEY (traveler_id) REFERENCES Travelers(traveler_id),
    FOREIGN KEY (hotel_id) REFERENCES Hotels(hotel_id)
);

CREATE TABLE RouteBookings (
    booking_id INT PRIMARY KEY,
    traveler_id INT,
    route_id INT,
    booking_date DATE NOT NULL,
    FOREIGN KEY (traveler_id) REFERENCES Travelers(traveler_id),
    FOREIGN KEY (route_id) REFERENCES TouristRoutes(route_id)
);

alter table Airlines
add iata_code VARCHAR(3) NOT NULL UNIQUE,
add country VARCHAR(50);

INSERT INTO Travelers (traveler_id, first_name, last_name, email, phone_number, passport_number)
VALUES 
(1, 'Иван', 'Иванов', 'ivanov@example.com', '89991112233', 'AA1234567'),
(2, 'Мария', 'Петрова', 'petrova@example.com', '89992223344', 'BB9876543'),
(3, 'Алексей', 'Смирнов', 'smirnov@example.com', '89993334455', 'CC2233445'),
(4, 'Екатерина', 'Федорова', 'fedorova@example.com', '89994445566', 'DD5566778'),
(5, 'Дмитрий', 'Кузнецов', 'kuznetsov@example.com', '89995556677', 'EE1122334'),
(6, 'Ольга', 'Соколова', 'sokolova@example.com', '89996667788', 'FF9988776'),
(7, 'Максим', 'Волков', 'volkov@example.com', '89997778899', 'GG5566888');

INSERT INTO Airlines (airline_id, airline_name, iata_code, country)
VALUES 
(1, 'Аэрофлот', 'SU', 'Россия'),
(2, 'Lufthansa', 'LH', 'Германия'),
(3, 'Emirates', 'EK', 'ОАЭ'),
(4, 'Turkish Airlines', 'TK', 'Турция'),
(5, 'S7 Airlines', 'S7', 'Россия'),
(6, 'Qatar Airways', 'QR', 'Катар'),
(7, 'Air France', 'AF', 'Франция');

INSERT INTO Hotels (hotel_id, hotel_name, location, star_rating, room_price)
VALUES 
(1, 'Хилтон', 'Москва', 5, 300.00),
(2, 'Марриотт', 'Санкт-Петербург', 4, 250.00),
(3, 'Шератон', 'Сочи', 5, 350.00),
(4, 'Holiday Inn', 'Казань', 3, 150.00),
(5, 'Рэдиссон Блу', 'Новосибирск', 4, 200.00),
(6, 'Novotel', 'Екатеринбург', 4, 220.00),
(7, 'Кортъярд', 'Владивосток', 3, 180.00);

INSERT INTO TouristRoutes (route_id, route_name, destination, duration, price)
VALUES 
(1, 'Экскурсия по Красной площади', 'Москва', 1, 50.00),
(2, 'Дворцы и мосты', 'Санкт-Петербург', 3, 200.00),
(3, 'Кавказские горы', 'Сочи', 5, 500.00),
(4, 'Татарские традиции', 'Казань', 2, 150.00),
(5, 'Золотое кольцо', 'Владимир', 4, 300.00),
(6, 'Озеро Байкал', 'Иркутск', 6, 600.00),
(7, 'Куршская коса', 'Калининград', 3, 250.00);

INSERT INTO Tickets (ticket_id, traveler_id, airline_id, flight_number, departure_date, arrival_date, price)
VALUES 
(1, 1, 1, 'SU100', '2024-10-21', '2024-10-22', 120.00),
(2, 2, 2, 'LH200', '2024-11-10', '2024-11-13', 150.00),
(3, 3, 3, 'EK300', '2024-12-05', '2024-12-07', 450.00),
(4, 4, 4, 'TK400', '2024-12-15', '2024-12-19', 400.00),
(5, 5, 5, 'S7100', '2024-12-20', '2024-12-25', 100.00),
(6, 6, 6, 'QR500', '2025-01-05', '2025-01-06', 550.00),
(7, 7, 7, 'AF600', '2025-01-10', '2025-01-17', 180.00);

TRUNCATE table Tickets;

INSERT INTO Tickets (ticket_id, traveler_id, airline_id, flight_number, departure_date, arrival_date, price)
VALUES 
(1, 1, 1, 'SU100', '2024-10-21', '2024-10-21', 120.00),
(2, 2, 2, 'LH200', '2024-11-10', '2024-11-10', 150.00),
(3, 3, 3, 'EK300', '2024-12-05', '2024-12-06', 450.00),
(4, 4, 4, 'TK400', '2024-12-15', '2024-12-16', 400.00),
(5, 5, 5, 'S7100', '2024-12-20', '2024-12-20', 100.00),
(6, 6, 6, 'QR500', '2025-01-05', '2025-01-06', 550.00),
(7, 7, 7, 'AF600', '2025-01-10', '2025-01-10', 180.00);

INSERT INTO HotelBookings (booking_id, traveler_id, hotel_id, check_in_date, check_out_date)
VALUES 
(1, 1, 1, '2024-10-21', '2024-10-23'),
(2, 2, 2, '2024-11-10', '2024-11-12'),
(3, 3, 3, '2024-12-05', '2024-12-07'),
(4, 4, 4, '2024-12-15', '2024-12-18'),
(5, 5, 5, '2024-12-20', '2024-12-22'),
(6, 6, 6, '2025-01-05', '2025-01-08'),
(7, 7, 7, '2025-01-10', '2025-01-12');

INSERT INTO RouteBookings (booking_id, traveler_id, route_id, booking_date)
VALUES 
(1, 1, 1, '2024-10-22'),
(2, 2, 2, '2024-11-11'),
(3, 3, 3, '2024-12-06'),
(4, 4, 4, '2024-12-17'),
(5, 5, 5, '2024-12-21'),
(6, 6, 6, '2025-01-07'),
(7, 7, 7, '2025-01-11');

UPDATE Hotels
SET room_price = room_price * 1.10;

-- 1. Вывести среднюю стоимость билета в зависимости от сезона и направления
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM t.departure_date) IN (3, 4, 5) THEN 'Весна'
        WHEN EXTRACT(MONTH FROM t.departure_date) IN (6, 7, 8) THEN 'Лето'
        WHEN EXTRACT(MONTH FROM t.departure_date) IN (9, 10, 11) THEN 'Осень'
        WHEN EXTRACT(MONTH FROM t.departure_date) IN (12, 1, 2) THEN 'Зима'
    END AS Season,
    a.country AS Direction,
    AVG(t.price) AS Average_cost
FROM 
    Tickets t
JOIN 
    Airlines a ON t.airline_id = a.airline_id
GROUP BY 
    Season, Direction
ORDER BY 
    Season, Direction;
   
 
   
SELECT 
    CASE 
        WHEN EXTRACT(MONTH FROM departure_date) IN (3, 4, 5) THEN 'Весна'
        WHEN EXTRACT(MONTH FROM departure_date) IN (6, 7, 8) THEN 'Лето'
        WHEN EXTRACT(MONTH FROM departure_date) IN (9, 10, 11) THEN 'Осень'
        WHEN EXTRACT(MONTH FROM departure_date) IN (12, 1, 2) THEN 'Зима'
    END AS Season,
    (SELECT a.country 
     FROM Airlines a 
     WHERE a.airline_id = t.airline_id) AS Direction,
    AVG(t.price) AS Average_cost
FROM 
    Tickets t
GROUP BY 
    Season, Direction
ORDER BY 
    Season, Direction;
   
-- 2. Вывести рейтинг авиакомпаний по количеству проданных билетов и общей сумме выручки от их продажи
   
SELECT 
    a.airline_name AS Airline,
    COUNT(t.ticket_id) AS Tickets_Sold,
    SUM(t.price) AS Total_Revenue
FROM 
    Tickets t
JOIN 
    Airlines a ON t.airline_id = a.airline_id
GROUP BY 
    a.airline_name
ORDER BY 
    Tickets_Sold DESC, Total_Revenue DESC;
   
   

SELECT 
    (SELECT airline_name FROM Airlines WHERE airline_id = t.airline_id) AS Airline,
    COUNT(t.ticket_id) AS Tickets_Sold,
    SUM(t.price) AS Total_Revenue
FROM 
    Tickets t
GROUP BY 
    t.airline_id
ORDER BY 
    Tickets_Sold DESC, Total_Revenue DESC;


   
   
   
   
ALTER TABLE Travelers
ADD COLUMN gender VARCHAR(10) CHECK (gender IN ('Male', 'Female'));


UPDATE Travelers
SET gender = 'Male'
WHERE traveler_id = 7;


INSERT INTO Travelers (traveler_id, first_name, last_name, email, phone_number, passport_number, gender)
VALUES 
(8, 'Сергей', 'Попов', 'popov@example.com', '89998889900', 'HH1122448', 'Male'),
(9, 'Анна', 'Козлова', 'kozlova@example.com', '89990001122', 'II3344556', 'Female'),
(10, 'Михаил', 'Новиков', 'novikov@example.com', '89991112233', 'JJ6677889', 'Male'),
(11, 'Дарья', 'Лебедева', 'lebedeva@example.com', '89992223344', 'KK4455667', 'Female'),
(12, 'Артем', 'Морозов', 'morozov@example.com', '89993334455', 'LL8899001', 'Male'),
(13, 'Ксения', 'Орлова', 'orlova@example.com', '89994445566', 'MM2233446', 'Female'),
(14, 'Илья', 'Крылов', 'krylov@example.com', '89995556677', 'NN4455778', 'Male');



-- 3. Для каждого направления вывести количество путешествий по месяцам в процентах. Также вывести, кто посещает это направление чаще – мужчины или женщины

--Получение количества путешествий по месяцам в процентах
SELECT 
    TR.route_name,
    EXTRACT(MONTH FROM RB.booking_date) AS booking_month,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY TR.route_id) AS percentage
FROM 
    RouteBookings RB
JOIN 
    TouristRoutes TR ON RB.route_id = TR.route_id
GROUP BY 
    TR.route_id, TR.route_name, EXTRACT(MONTH FROM RB.booking_date);
   
   
SELECT 
    (SELECT TR.route_name 
     FROM TouristRoutes TR 
     WHERE TR.route_id = RB.route_id) AS route_name,
    EXTRACT(MONTH FROM RB.booking_date) AS booking_month,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY RB.route_id) AS percentage
FROM 
    RouteBookings RB
GROUP BY 
    RB.route_id, EXTRACT(MONTH FROM RB.booking_date);

--Определение пола, наиболее часто посещающего каждое направление
WITH GenderCounts AS (
    SELECT
        RB2.route_id,
        T2.gender,
        COUNT(*) AS gender_count
    FROM
        RouteBookings RB2
    JOIN
        Travelers T2 ON RB2.traveler_id = T2.traveler_id
    GROUP BY
        RB2.route_id, T2.gender
),
MaxGenderCounts AS (
    SELECT
        route_id,
        MAX(gender_count) AS max_gender_count
    FROM
        GenderCounts
    GROUP BY
        route_id
)

SELECT 
    TR.route_name,
    GC.gender,
    GC.gender_count AS count
FROM 
    (
        SELECT
            RB.route_id,
            T.gender,
            COUNT(*) AS gender_count
        FROM
            RouteBookings RB
        JOIN
            Travelers T ON RB.traveler_id = T.traveler_id
        GROUP BY
            RB.route_id, T.gender
    ) AS GC
JOIN 
    (
        SELECT
            route_id,
            MAX(gender_count) AS max_gender_count
        FROM
            (
                SELECT
                    RB2.route_id,
                    T2.gender,
                    COUNT(*) AS gender_count
                FROM
                    RouteBookings RB2
                JOIN
                    Travelers T2 ON RB2.traveler_id = T2.traveler_id
                GROUP BY
                    RB2.route_id, T2.gender
            ) AS GenderCounts
        GROUP BY
            route_id
    ) AS MGC ON GC.route_id = MGC.route_id AND GC.gender_count = MGC.max_gender_count
JOIN 
    TouristRoutes TR ON GC.route_id = TR.route_id;
   
   
   
SELECT 
    (SELECT TR.route_name 
     FROM TouristRoutes TR 
     WHERE TR.route_id = GC.route_id) AS route_name,
    GC.gender,
    GC.gender_count AS count
FROM 
    (
        SELECT
            RB.route_id,
            T.gender,
            COUNT(*) AS gender_count
        FROM
            RouteBookings RB,
            Travelers T
        WHERE
            RB.traveler_id = T.traveler_id
        GROUP BY
            RB.route_id, T.gender
    ) AS GC
WHERE 
    GC.gender_count = (
        SELECT MAX(sub_gender_count)
        FROM 
            (
                SELECT
                    COUNT(*) AS sub_gender_count
                FROM
                    RouteBookings RB2,
                    Travelers T2
                WHERE
                    RB2.traveler_id = T2.traveler_id 
                    AND RB2.route_id = GC.route_id
                GROUP BY
                    RB2.route_id, T2.gender
            ) AS GenderCounts
    );


--4. Для каждой страны вывести самый посещаемый отель

SELECT 
    A.country,
    H.hotel_name,
    COUNT(HB.booking_id) AS visit_count
FROM 
    Hotels H
JOIN 
    HotelBookings HB ON H.hotel_id = HB.hotel_id
JOIN 
    Travelers T ON HB.traveler_id = T.traveler_id
JOIN 
    Airlines A ON T.traveler_id = T.traveler_id  
GROUP BY 
    A.country, H.hotel_name
HAVING 
    COUNT(HB.booking_id) = (
        SELECT 
            MAX(visit_count)
        FROM (
            SELECT 
                COUNT(HB2.booking_id) AS visit_count
            FROM 
                Hotels H2
            JOIN 
                HotelBookings HB2 ON H2.hotel_id = HB2.hotel_id
            JOIN 
                Travelers T2 ON HB2.traveler_id = T2.traveler_id
            JOIN 
                Airlines A2 ON T2.traveler_id = T2.traveler_id  
            WHERE 
                A2.country = A.country
            GROUP BY 
                H2.hotel_id
        ) AS subquery
    );

INSERT INTO Airlines (airline_id, airline_name, iata_code, country)
VALUES 
(8, 'Аэрофлот', 'SU2', 'США'),  
(9, 'Lufthansa', 'LH2', 'Австрия'), 
(10, 'Emirates', 'EK2', 'Индия'),  
(11, 'Turkish Airlines', 'TK2', 'Италия'), 
(12, 'S7 Airlines', 'S72', 'Китай'), 
(13, 'Qatar Airways', 'QR2', 'Япония'), 
(14, 'Air France', 'AF2', 'Испания'); 
   
INSERT INTO Hotels (hotel_id, hotel_name, location, star_rating, room_price)
VALUES 
(8, 'Hilton Berlin', 'Берлин', 3, 250.00),
(9, 'Hotel Adlon', 'Берлин', 5, 300.00),
(10, 'Atlantis The Palm', 'Дубай', 5, 400.00),
(11, 'Burj Al Arab', 'Дубай', 5, 800.00),
(12, 'Radisson Blu Hotel', 'Стамбул', 4, 200.00),
(13, 'Hilton Istanbul Bosphorus', 'Стамбул', 5, 300.00),
(14, 'Qatar Hotel', 'Доха', 4, 220.00),
(15, 'The St. Regis Doha', 'Доха', 5, 450.00),
(16, 'Le Meurice', 'Париж', 5, 500.00),
(17, 'Hotel de Crillon', 'Париж', 3, 600.00),
(18, 'Marriott Marquis', 'Нью-Йорк', 5, 350.00),
(19, 'Hilton New York', 'Нью-Йорк', 4, 280.00),
(20, 'Hilton Vienna Park', 'Вена', 5, 250.00),
(21, 'InterContinental Vienna', 'Вена', 5, 300.00),
(22, 'Taj Mahal Palace', 'Мумбаи', 3, 400.00),
(23, 'Oberoi Udaivilas', 'Удаипур', 5, 450.00),
(24, 'Hotel Danieli', 'Венеция', 5, 500.00),
(25, 'Grand Hotel Tremezzo', 'Тремеццо', 5, 600.00),
(26, 'The Peninsula', 'Пекин', 2, 350.00),
(27, 'Waldorf Astoria', 'Шанхай', 5, 400.00),
(28, 'Park Hyatt', 'Токио', 5, 550.00),
(29, 'Mandarin Oriental', 'Токио', 5, 600.00),
(30, 'Hotel Arts', 'Барселона', 4, 400.00),
(31, 'W Barcelona', 'Барселона', 5, 450.00);

INSERT INTO TouristRoutes (route_id, route_name, destination, duration, price)
VALUES 
(8, 'Экскурсия по Бранденбургским воротам', 'Берлин', 2, 70.00),
(9, 'Круиз по Дубаю', 'Дубай', 3, 150.00),
(10, 'Экскурсия по историческим достопримечательностям', 'Стамбул', 4, 180.00),
(11, 'Поездка по Дохе', 'Доха', 2, 100.00),
(12, 'Прогулка по Елисейским полям', 'Париж', 3, 120.00),
(13, 'Экскурсия по Централ Парк', 'Нью-Йорк', 2, 90.00),
(14, 'Посещение дворцов Вены', 'Вена', 3, 110.00),
(15, 'Кулинарная экскурсия в Мумбаи', 'Мумбаи', 6, 300.00),
(16, 'Круиз по озеру Пичола', 'Удаипур', 5, 200.00),
(17, 'Прогулка по Венеции', 'Венеция', 3, 130.00),
(18, 'Экскурсия по озеру Комо', 'Тремеццо', 4, 160.00),
(19, 'Экскурсия по Великой Китайской стене', 'Пекин', 5, 250.00),
(20, 'Прогулка по набережной в Шанхае', 'Шанхай', 2, 80.00),
(21, 'Посещение святилищ в Токио', 'Токио', 4, 170.00),
(22, 'Экскурсия по Готическому кварталу', 'Барселона', 3, 140.00);

INSERT INTO Tickets (ticket_id, traveler_id, airline_id, flight_number, departure_date, arrival_date, price)
VALUES 
(8, 6, 6, 'QR500', '2025-01-05', '2025-01-06', 550.00),
(9, 7, 7, 'AF600', '2025-01-10', '2025-01-17', 180.00),
(10, 7, 1, 'SU102', '2024-11-08', '2024-11-12', 140.00),
(11, 8, 1, 'SU101', '2024-11-01', '2024-11-02', 130.00),
(12, 9, 2, 'LH202', '2024-11-20', '2024-11-25', 160.00),
(13, 10, 3, 'EK301', '2024-12-10', '2024-12-12', 470.00),
(14, 11, 4, 'TK401', '2024-12-25', '2024-12-30', 390.00),
(15, 12, 5, 'S7101', '2025-01-01', '2025-01-05', 110.00),
(16, 13, 6, 'QR501', '2025-01-15', '2025-01-16', 580.00),
(17, 14, 7, 'AF601', '2025-01-20', '2025-01-25', 200.00),
(18, 1, 3, 'EK002', '2025-02-01', '2025-02-05', 400.00),
(19, 2, 1, 'SU201', '2025-06-10', '2025-06-11', 180.00),
(20, 3, 2, 'LH300', '2025-06-20', '2025-06-25', 250.00),
(21, 4, 3, 'EK400', '2025-05-15', '2025-05-18', 300.00),
(22, 4, 4, 'TK501', '2025-05-20', '2025-05-25', 350.00),
(23, 5, 5, 'S7200', '2025-06-10', '2025-06-15', 130.00),
(24, 6, 6, 'QR600', '2025-05-01', '2025-05-02', 400.00),
(25, 6, 7, 'AF700', '2025-05-10', '2025-05-17', 220.00),
(26, 7, 1, 'SU202', '2025-06-25', '2025-06-30', 190.00),
(27, 8, 2, 'LH301', '2025-06-05', '2025-06-10', 270.00),
(28, 9, 2, 'LH302', '2025-06-15', '2025-06-18', 260.00),
(29, 10, 3, 'EK401', '2025-05-10', '2025-05-13', 420.00),
(30, 11, 4, 'TK502', '2025-05-25', '2025-05-28', 370.00);


--ИСПРАВИТЬ
INSERT INTO HotelBookings (booking_id, traveler_id, hotel_id, check_in_date, check_out_date) VALUES
(8, 6, 6, '2025-01-06', '2025-01-07'),
(9, 7, 7, '2025-01-17', '2025-01-20'),
(10, 7, 1, '2024-11-12', '2024-11-15'),
(11, 8, 1, '2024-11-02', '2024-11-05'),
(12, 9, 2, '2024-11-25', '2024-11-29'),
(13, 10, 3, '2024-12-12', '2024-12-20'),
(14, 11, 4, '2024-12-30', '2024-12-31'),
(15, 12, 5, '2025-01-05', '2025-01-09'),
(16, 13, 6, '2025-01-16', '2025-01-22'),
(17, 14, 7, '2025-01-25', '2025-01-26'),
(18, 1, 3, '2025-02-05', '2025-02-08'),
(19, 2, 1, '2025-06-11', '2025-06-14'),
(20, 3, 2, '2025-06-25', '2025-06-28'),
(21, 4, 3, '2025-05-18', '2025-05-19'),
(22, 4, 4, '2025-05-25', '2025-05-27'),
(23, 5, 5, '2025-06-15', '2025-06-19'),
(24, 6, 6, '2025-05-02', '2025-05-10'),
(25, 6, 7, '2025-05-17', '2025-05-21'),
(26, 7, 1, '2025-06-30', '2025-07-05'),
(27, 8, 2, '2025-06-10', '2025-06-18'),
(28, 9, 2, '2025-06-18', '2025-06-22'),
(29, 10, 3, '2025-05-13', '2025-05-17'),
(30, 11, 4, '2025-05-28', '2025-05-29');

   
INSERT INTO RouteBookings (booking_id, traveler_id, route_id, booking_date) VALUES
(8, 6, 6, '2025-01-06'),
(9, 7, 7, '2025-01-17'),
(10, 7, 1, '2024-11-12'),
(11, 8, 1, '2024-11-02'),
(12, 9, 2, '2024-11-25'),
(13, 10, 3, '2024-12-12'),
(14, 11, 4, '2024-12-30'),
(15, 12, 5, '2025-01-05'),
(16, 13, 6, '2025-01-16'),
(17, 14, 7, '2025-01-25'),
(18, 1, 3, '2025-02-05'),
(19, 2, 1, '2025-06-11'),
(20, 3, 2, '2025-06-25'),
(21, 4, 3, '2025-05-18'),
(22, 4, 4, '2025-05-25'),
(23, 5, 5, '2025-06-15'),
(24, 6, 6, '2025-05-02'),
(25, 6, 7, '2025-05-17'),
(26, 7, 1, '2025-06-30'),
(27, 8, 2, '2025-06-10'),
(28, 9, 2, '2025-06-18'),
(29, 10, 3, '2025-05-13'),
(30, 11, 4, '2025-05-28');
   
   

   
   
   


   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   











































