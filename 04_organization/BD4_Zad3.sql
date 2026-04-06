WITH RECURSIVE all_subordinates AS (
    -- Якорь: все прямые связи менеджер → подчинённый
    SELECT ManagerID AS manager_id, EmployeeID AS sub_id
    FROM Employees
    WHERE ManagerID IS NOT NULL

    UNION ALL

    -- Рекурсия: идём на уровень глубже
    SELECT s.manager_id, e.EmployeeID
    FROM Employees e
    JOIN all_subordinates s ON e.ManagerID = s.sub_id
),
sub_counts AS (
    SELECT manager_id, COUNT(*) AS total_subordinates
    FROM all_subordinates
    GROUP BY manager_id
)
SELECT
    e.EmployeeID,
    e.Name       AS EmployeeName,
    e.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName)
     FROM Projects p
     WHERE p.DepartmentID = e.DepartmentID) AS ProjectNames,
    (SELECT STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName)
     FROM Tasks t
     WHERE t.AssignedTo = e.EmployeeID)     AS TaskNames,
    sc.total_subordinates                   AS TotalSubordinates
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
JOIN Roles r       ON e.RoleID = r.RoleID
JOIN sub_counts sc ON e.EmployeeID = sc.manager_id
WHERE r.RoleName = 'Менеджер'
ORDER BY e.Name;