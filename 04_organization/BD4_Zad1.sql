WITH RECURSIVE subordinates AS (
    SELECT EmployeeID, Name, ManagerID, DepartmentID, RoleID
    FROM Employees
    WHERE EmployeeID = 1

    UNION ALL

    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    JOIN subordinates s ON e.ManagerID = s.EmployeeID
)
SELECT
    s.EmployeeID,
    s.Name       AS EmployeeName,
    s.ManagerID,
    d.DepartmentName,
    r.RoleName,
    (SELECT STRING_AGG(p.ProjectName, ', ' ORDER BY p.ProjectName)
     FROM Projects p
     WHERE p.DepartmentID = s.DepartmentID) AS ProjectNames,
    (SELECT STRING_AGG(t.TaskName, ', ' ORDER BY t.TaskName)
     FROM Tasks t
     WHERE t.AssignedTo = s.EmployeeID)     AS TaskNames
FROM subordinates s
JOIN Departments d ON s.DepartmentID = d.DepartmentID
JOIN Roles r       ON s.RoleID = r.RoleID
ORDER BY s.Name;