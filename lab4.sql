CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role_id INTEGER REFERENCES roles(id) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL
);

CREATE TABLE trainers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) NOT NULL,
    service_id INTEGER REFERENCES services(id) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_visits INTEGER NOT NULL,
    remaining_visits INTEGER NOT null
    subscription_id INTEGER REFERENCES subscriptions(subscription_id) NOT NULL
);

CREATE TABLE bookings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) NOT NULL,
    trainer_id INTEGER REFERENCES trainers(id) NOT NULL,
    service_id INTEGER REFERENCES services(id) NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE available_slots (
    id SERIAL PRIMARY KEY,
    trainer_id INTEGER NOT NULL REFERENCES trainers(id) ON DELETE CASCADE,
    slot_date DATE NOT NULL,
    slot_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (trainer_id, slot_date, slot_time)
);

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL, 
    old_data JSONB,
    new_data JSONB,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by INTEGER REFERENCES users(id)
);

INSERT INTO roles (name) VALUES ('Administrator'), ('Manager'), ('Member');

INSERT INTO users (name, email, password, role_id) 
VALUES 
('Иван Иванов', 'ivan@example.com', 'hashed_password', 1),
('Мария Петрова', 'maria@example.com', 'hashed_password', 2),
('Алексей Смирнов', 'alexey@example.com', 'hashed_password', 3);

INSERT INTO services (name, description, price) 
VALUES 
('Йога', 'Занятия йогой для всех уровней', 1500.00),
('Пилатес', 'Пилатес для укрепления мышц', 1600.00),
('Бодибилдинг', 'Тренировки по наращиванию мышечной массы', 2000.00);

INSERT INTO trainers (name, specialization) 
VALUES 
('Тренер 1', 'Йога'),
('Тренер 2', 'Пилатес'),
('Тренер 3', 'Бодибилдинг');

INSERT INTO subscriptions (user_id, service_id, start_date, end_date, total_visits, remaining_visits) 
VALUES 
(3, 1, '2023-10-01', '2024-09-30', 100, 100),
(3, 2, '2023-10-01', '2024-09-30', 80, 80);

INSERT INTO available_slots (trainer_id, slot_date, slot_time)
   VALUES 
   (1, '2023-10-25', '09:00'),
   (1, '2023-10-25', '10:00'),
   (2, '2023-10-25', '11:00'),
   (3, '2023-10-25', '12:00'),
   (1, '2023-10-26', '09:00'),
   (2, '2023-10-26', '10:00');
  

INSERT INTO bookings (user_id, trainer_id, service_id, booking_date, booking_time, subscription_id) values
(3, 1, 1, '2023-10-25', '09:00', 1);  

CREATE OR REPLACE FUNCTION log_changes() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs (table_name, operation, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(NEW), NULL); 
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO logs (table_name, operation, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(OLD), to_jsonb(NEW), NULL);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (table_name, operation, old_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, to_jsonb(OLD), NULL);
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
    tbl TEXT;
    tbl_list TEXT[] := ARRAY['users', 'roles', 'services', 'trainers', 'subscriptions', 'bookings'];
BEGIN
    FOREACH tbl IN ARRAY tbl_list
    LOOP
        EXECUTE format('
            CREATE TRIGGER trg_log_%I
            AFTER INSERT OR UPDATE OR DELETE ON %I
            FOR EACH ROW EXECUTE FUNCTION log_changes();', tbl, tbl);
    END LOOP;
END;
$$;

CREATE OR REPLACE FUNCTION update_remaining_visits() RETURNS TRIGGER AS $$
BEGIN

    UPDATE subscriptions
    SET remaining_visits = remaining_visits - 1
    WHERE subscription_id = NEW.subscription_id; 

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_remaining_visits
AFTER INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_remaining_visits();

CREATE VIEW top_services AS
SELECT 
    s.id,
    s.name,
    COUNT(b.id) AS bookings_count
FROM 
    services s
JOIN 
    bookings b ON s.id = b.service_id
GROUP BY 
    s.id, s.name
ORDER BY 
    bookings_count DESC
LIMIT 10;

CREATE VIEW admin_view AS
SELECT u.*, r.name AS role_name
FROM users u
JOIN roles r ON u.role_id = r.id;

CREATE VIEW manager_view AS
SELECT 
    u.id,
    u.name,
    u.email,
    r.name AS role_name,
    s.name AS service_name,
    b.booking_date,
    b.booking_time
FROM 
    users u
JOIN 
    roles r ON u.role_id = r.id
JOIN 
    bookings b ON u.id = b.user_id
JOIN 
    services s ON b.service_id = s.id
WHERE 
    r.name <> 'Administrator';
   
CREATE OR REPLACE FUNCTION get_remaining_visits(p_subscription_id INTEGER) 
RETURNS INTEGER AS $$
DECLARE
    remaining INTEGER;
BEGIN
    SELECT remaining_visits INTO remaining
    FROM subscriptions
    WHERE id = p_subscription_id;
    
    RETURN remaining;
END;
$$ LANGUAGE plpgsql;

SELECT get_remaining_visits(1);

CREATE OR REPLACE FUNCTION get_available_slots(p_trainer_id INTEGER, p_date DATE) 
RETURNS TABLE(slot_time TIME) AS $$
BEGIN
    RETURN QUERY
    SELECT aslots.time_slot
    FROM available_slots aslots
    WHERE aslots.trainer_id = p_trainer_id
      AND aslots.date = p_date
      AND aslots.time_slot NOT IN (
          SELECT b.booking_time
          FROM bookings b
          WHERE b.trainer_id = p_trainer_id
            AND b.booking_date = p_date
      );
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_available_slots(1, '2023-10-25');

DROP TRIGGER IF EXISTS trg_update_remaining_visits ON bookings;

CREATE TRIGGER trg_update_remaining_visits
AFTER INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION update_remaining_visits();





