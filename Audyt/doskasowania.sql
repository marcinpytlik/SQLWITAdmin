WITH bpCTE
AS
(
SELECT permission_name, covering_permission_name AS parent_permission, 1 AS hierarchy_level
FROM sys.fn_builtin_permissions('SERVER')
WHERE permission_name = 'CONTROL SERVER'
UNION ALL
SELECT bp.permission_name, bp.covering_permission_name, hierarchy_level + 1 AS hierarchy_level
FROM bpCTE AS r
CROSS APPLY sys.fn_builtin_permissions('SERVER') AS bp
WHERE bp.covering_permission_name = r.permission_name
)
SELECT * FROM bpCTE
ORDER BY hierarchy_level, permission_name;
