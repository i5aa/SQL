
DECLARE @html NVARCHAR(MAX)

SELECT @html = 
    '<style>
        table { border-collapse: collapse; width: 100%; font-family: Arial; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; text-align: left; }
    </style>
    <h3>Index Metadata Report</h3>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Name</th>
            <th>Column Type</th>
        </tr>' + 
    (
    SELECT
        td.name AS [Table Name],
        i.name AS [Index Name],
        i.type_desc AS [Index Type],
        c.name AS [Column Name],
        CASE 
            WHEN ic.is_included_column = 1 THEN 'Included'
            ELSE 'Key'
        END AS [Column Type]
    FROM 
        sys.indexes i
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        INNER JOIN sys.tables td ON i.object_id = td.object_id
    WHERE 
        i.type > 0 AND td.is_ms_shipped = 0
    ORDER BY 
        td.name, i.name, ic.key_ordinal
    FOR XML PATH('tr'), TYPE
    ).value('.', 'NVARCHAR(MAX)') + '</table>';

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'YourDatabaseMailProfile',
    @recipients = 'you@example.com',
    @subject = 'SQL Server Index Metadata Report',
    @body = @html,
    @body_format = 'HTML';