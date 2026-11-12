CREATE DATABASE IF NOT EXISTS service_desk_db;
USE service_desk_db;

CREATE TABLE Departments (
    dept_id VARCHAR(2) PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE Categories (
    cat_id VARCHAR(2) PRIMARY KEY,
    cat_name VARCHAR(100) NOT NULL
);

CREATE TABLE Priorities (
    prior_id VARCHAR(2) PRIMARY KEY,
    prior_name VARCHAR(50) NOT NULL
);

CREATE TABLE Specialists (
    spec_id VARCHAR(4) PRIMARY KEY,
    spec_name VARCHAR(150) NOT NULL
);

CREATE TABLE Manufactures (
    man_id VARCHAR(3) PRIMARY KEY,
    man_name VARCHAR(100) NOT NULL
);

CREATE TABLE Employees (
    emp_id VARCHAR(4) PRIMARY KEY,
    emp_name VARCHAR(150) NOT NULL,
    dept_id VARCHAR(2),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

CREATE TABLE Equipment (
    equip_id VARCHAR(6) PRIMARY KEY,
    model VARCHAR(100) NOT NULL,
    man_id VARCHAR(3),
    FOREIGN KEY (man_id) REFERENCES Manufactures(man_id)
);

CREATE TABLE Requests (
    req_id VARCHAR(6) PRIMARY KEY,
    reg_date DATE NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Новая',
    emp_id VARCHAR(4),
    cat_id VARCHAR(2),
    prior_id VARCHAR(2),
    spec_id VARCHAR(4),
    equip_id VARCHAR(6),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
    FOREIGN KEY (cat_id) REFERENCES Categories(cat_id),
    FOREIGN KEY (prior_id) REFERENCES Priorities(prior_id),
    FOREIGN KEY (spec_id) REFERENCES Specialists(spec_id),
    FOREIGN KEY (equip_id) REFERENCES Equipment(equip_id)
);

ALTER TABLE Requests ADD completion_date DATE;

INSERT INTO Departments (dept_id, dept_name) VALUES 
('01', 'Бухгалтерия'),
('02', 'Отдел продаж'),
('03', 'IT-отдел');

INSERT INTO Specialists (spec_id, spec_name) VALUES 
('2001', 'Смирнов А.А.'),
('2002', 'Кузнецов И.И.');

INSERT INTO Categories (cat_id, cat_name) VALUES 
('01', 'Оборудование'),
('02', 'Программное обеспечение'),
('03', 'Сеть и интернет');

INSERT INTO Priorities (prior_id, prior_name) VALUES 
('01', 'Низкий'),
('02', 'Средний'),
('03', 'Высокий');

INSERT INTO Manufactures (man_id, man_name) VALUES 
('001', 'Dell'),
('002', 'HP'),
('003', 'Apple');

INSERT INTO Employees (emp_id, emp_name, dept_id) VALUES 
('1001', 'Иванов И.И.', '01'),
('1002', 'Петров П.П.', '02'),
('1003', 'Сидоров С.С.', '03');

INSERT INTO Equipment (equip_id, model, man_id) VALUES 
('5001', 'Latitude 5420', '001'),
('5002', 'ProBook 450', '002'),
('5003', 'MacBook Air M1', '003');

INSERT INTO Requests (req_id, reg_date, description, status, emp_id, cat_id, prior_id, spec_id, equip_id) VALUES 
('000001', '2026-10-15', 'Не включается ноутбук', 'Выполнена', '1001', '01', '03', '2001', '5001'),
('000002', '2026-10-16', 'Не работает корпоративная почта', 'В работе', '1002', '02', '02', '2001', '5002'),
('000003', '2026-10-16', 'Пропал интернет в отделе', 'Новая', '1003', '03', '03', NULL, NULL);

UPDATE Requests SET status = 'В работе', spec_id = '2002' WHERE req_id = '000002';
UPDATE Requests SET completion_date = '2026-10-15' WHERE req_id = '000001';

DELETE FROM Requests WHERE req_id = '000003';

CREATE USER 'admin_it'@'localhost' IDENTIFIED BY 'AdminPass123!';
CREATE USER 'dispatcher'@'localhost' IDENTIFIED BY 'DispPass123!';
CREATE USER 'employee_user'@'localhost' IDENTIFIED BY 'EmpPass123!';

GRANT ALL PRIVILEGES ON service_desk_db.* TO 'admin_it'@'localhost';
GRANT SELECT ON service_desk_db.* TO 'dispatcher'@'localhost';
GRANT UPDATE ON service_desk_db.Requests TO 'dispatcher'@'localhost';
GRANT SELECT ON service_desk_db.* TO 'employee_user'@'localhost';
GRANT INSERT ON service_desk_db.Requests TO 'employee_user'@'localhost';

FLUSH PRIVILEGES;
