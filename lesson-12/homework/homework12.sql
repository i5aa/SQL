
--Task 1
declare @db_name sysname;
declare @sql nvarchar(max);


if object_id('tempdb..#column_info') is not null drop table #column_info;

create table #column_info (
    database_name sysname,
    schema_name sysname,
    table_name sysname,
    column_name sysname,
    data_type sysname
);

declare db_cursor cursor for
select name from sys.databases
where name not in ('master', 'tempdb', 'model', 'msdb') -- exclude system databases
  and state_desc = 'ONLINE';

open db_cursor;
fetch next from db_cursor into @db_name;

while @@fetch_status = 0
begin
    set @sql = '
    insert into #column_info (database_name, schema_name, table_name, column_name, data_type)
    select 
        db_name(),
        s.name as schema_name,
        t.name as table_name,
        c.name as column_name,
        ty.name as data_type
    from [' + quotename(@db_name) + '].sys.schemas s
    join [' + quotename(@db_name) + '].sys.tables t on t.schema_id = s.schema_id
    join [' + quotename(@db_name) + '].sys.columns c on c.object_id = t.object_id
    join [' + quotename(@db_name) + '].sys.types ty on c.user_type_id = ty.user_type_id
    ';
    
    exec sp_executesql @sql;
    fetch next from db_cursor into @db_name;
end

close db_cursor;
deallocate db_cursor;

select * from #column_info
order by database_name, schema_name, table_name, column_name;

--Task 2
go
create procedure GetAllProceduresAndFunctions
    @DatabaseName sysname = null
as
begin
    set nocount on;

    
    if object_id('tempdb..#ObjectParams') is not null drop table #ObjectParams;

    create table #ObjectParams (
        DatabaseName sysname,
        SchemaName sysname,
        ObjectName sysname,
        ObjectType varchar(20),
        ParameterName sysname,
        DataType sysname,
        MaxLength int
    );

    declare @db sysname;
    declare @sql nvarchar(max);

    -
    declare db_cursor cursor for
    select name from sys.databases
    where (@DatabaseName is null and name not in ('master', 'tempdb', 'model', 'msdb'))
       or (name = @DatabaseName);

    open db_cursor;
    fetch next from db_cursor into @db;

    while @@fetch_status = 0
    begin
        set @sql = '
        use [' + quotename(@db) + '];

        insert into #ObjectParams (DatabaseName, SchemaName, ObjectName, ObjectType, ParameterName, DataType, MaxLength)
        select 
            ''' + @db + ''' as DatabaseName,
            schema_name(o.schema_id) as SchemaName,
            o.name as ObjectName,
            case when o.type in (''P'') then ''Stored Procedure''
                 when o.type in (''FN'', ''IF'', ''TF'') then ''Function''
                 else o.type end as ObjectType,
            p.name as ParameterName,
            t.name as DataType,
            p.max_length
        from sys.objects o
        left join sys.parameters p on o.object_id = p.object_id
        left join sys.types t on p.user_type_id = t.user_type_id
        where o.type in (''P'', ''FN'', ''IF'', ''TF'')
        ';

        exec sp_executesql @sql;
        fetch next from db_cursor into @db;
    end

    close db_cursor;
    deallocate db_cursor;


    select * from #ObjectParams
    order by DatabaseName, SchemaName, ObjectType, ObjectName, ParameterName;
end;
exec GetAllProceduresAndFunctions;
