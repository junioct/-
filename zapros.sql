Вывести все заявки со статусом «В работе» вместе с ФИО сотрудника и названием его отдела. Отсортировать по дате регистрации (сначала новые).

SELECT r.req_id, r.reg_date, e.emp_name, d.dept_name, r.status 
FROM Requests r, Employees e, Departments d
WHERE r.emp_id = e.emp_id 
  AND e.dept_id = d.dept_id 
  AND r.status = 'В работе'
ORDER BY r.reg_date DESC;

Вывести заявки с названием категории и ФИО назначенного специалиста. 

SELECT r.req_id, r.description, c.cat_name, s.spec_name, r.status
FROM Requests r
JOIN Categories c ON r.cat_id = c.cat_id
LEFT JOIN Specialists s ON r.spec_id = s.spec_id;

Вывести общую статистику по заявкам.

SELECT 
    COUNT(*) AS Total_Requests, 
    COUNT(DISTINCT emp_id) AS Unique_Employees, 
    MIN(reg_date) AS First_Request_Date, 
    MAX(reg_date) AS Last_Request_Date
FROM Requests;

Посчитать, сколько заявок приходится на каждый приоритет, и вывести только те приоритеты, по которым есть хотя бы одна заявка.

SELECT p.prior_name, COUNT(r.req_id) AS Requests_Count
FROM Priorities p
JOIN Requests r ON p.prior_id = r.prior_id
GROUP BY p.prior_name
HAVING COUNT(r.req_id) > 0;

Найти ФИО всех сотрудников, которые создавали заявки категории «Оборудование».

SELECT emp_name 
FROM Employees 
WHERE emp_id IN (
    SELECT emp_id FROM Requests 
    WHERE cat_id = (SELECT cat_id FROM Categories WHERE cat_name = 'Оборудование')
);

Найти заявки, которые были зарегистрированы позже, чем ВСЕ заявки сотрудника с кодом '1001' (Иванова).

SELECT req_id, reg_date, description 
FROM Requests 
WHERE reg_date > ALL (
    SELECT reg_date FROM Requests WHERE emp_id = '1001'
);

Вывести список заявок. С помощью CASE перевести код статуса в понятный текст, а с помощью IF показать, закрыта ли заявка.

SELECT 
    req_id, 
    description,
    CASE status
        WHEN 'Новая' THEN 'Ожидает диспетчера'
        WHEN 'В работе' THEN 'В процессе решения'
        WHEN 'Выполнена' THEN 'Успешно закрыта'
        ELSE 'Неизвестный статус'
    END AS Status_RU,
    IF(completion_date IS NULL, 'Нет', 'Да') AS Is_Completed
FROM Requests;

Создать виртуальную таблицу (представление) для удобного просмотра всех незавершенных заявок.

CREATE VIEW vw_Active_Requests AS
SELECT r.req_id, e.emp_name, r.description, r.status, p.prior_name
FROM Requests r
JOIN Employees e ON r.emp_id = e.emp_id
JOIN Priorities p ON r.prior_id = p.prior_id
WHERE r.status != 'Выполнена';
SELECT * FROM vw_Active_Requests;
