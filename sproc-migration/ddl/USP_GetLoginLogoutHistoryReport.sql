CREATE PROCEDURE dbo.usp_getloginlogouthistoryreport
    (
        @AccountId INT,
        @fromDate DATETIME,
        @toDate DATETIME,
        @userId INT,
        @orderBy NVARCHAR(50) = 'UserFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
AS BEGIN WITH loginlogoutreportresult AS (
    SELECT
        u.user_id AS userid,
        ulh.logintime,
        ulh.logouttime,
        u.user_first_name + u.user_last_name AS userfullname
    FROM trntrackuserloginlogouthistory AS ulh
    INNER JOIN
        mst_user AS u
        ON
            ulh.userid = u.user_id
            AND u.user_status = 1
            AND ulh.logouttime IS NOT NULL
    WHERE
        CONVERT(DATE, ulh.logintime) >= @fromDate
        AND CONVERT(DATE, ulh.logintime) <= @toDate
        AND (@userId = 0 OR ulh.userid = @userId)
),

orderbyresult AS (SELECT
    *,
    ROW_NUMBER() OVER (
        ORDER BY
            CASE
                WHEN
                    @orderBy = 'UserFullName' AND @orderDir = 'asc'
                    THEN userfullname
            END,
            CASE
                WHEN
                    @orderBy = 'UserFullName' AND @orderDir = 'desc'
                    THEN userfullname
            END DESC
    ) AS rownumber
FROM loginlogoutreportresult)

SELECT
    *,
    (SELECT Count(userid) FROM loginlogoutreportresult) AS totalrows
FROM orderbyresult WHERE orderbyresult.rownumber BETWEEN (@StartFrom + 1) AND (@StartFrom + @pageSize) END  --EXEC USP_GetLoginLogoutHistoryReport 22, '12/09/2022 12.00.00 AM','12/16/2022 12.00.00 AM',0
