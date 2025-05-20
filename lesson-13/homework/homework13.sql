DECLARE @Year INT = 2025;
DECLARE @Month INT = 5;

;WITH Dates AS (
    -- Generate all dates for the month
    SELECT CAST(DATEFROMPARTS(@Year, @Month, 1) AS DATE) AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM Dates
    WHERE MONTH(DATEADD(DAY, 1, CalendarDate)) = @Month
),
CalendarCTE AS (
    SELECT 
        CalendarDate,
        DATEPART(WEEK, CalendarDate) - DATEPART(WEEK, DATEFROMPARTS(@Year, @Month, 1)) 
            + CASE WHEN DATENAME(WEEKDAY, DATEFROMPARTS(@Year, @Month, 1)) = 'Sunday' THEN 0 ELSE 1 END AS WeekNum,
        DATENAME(WEEKDAY, CalendarDate) AS WeekdayName
    FROM Dates
)
SELECT 
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Sunday' THEN DAY(CalendarDate) END) AS Sunday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Monday' THEN DAY(CalendarDate) END) AS Monday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Tuesday' THEN DAY(CalendarDate) END) AS Tuesday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Wednesday' THEN DAY(CalendarDate) END) AS Wednesday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Thursday' THEN DAY(CalendarDate) END) AS Thursday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Friday' THEN DAY(CalendarDate) END) AS Friday,
    MAX(CASE WHEN DATENAME(WEEKDAY, CalendarDate) = 'Saturday' THEN DAY(CalendarDate) END) AS Saturday
FROM CalendarCTE
GROUP BY WeekNum
ORDER BY WeekNum
OPTION (MAXRECURSION 1000);
