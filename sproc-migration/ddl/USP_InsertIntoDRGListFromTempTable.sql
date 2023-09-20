--EXEC USP_InsertIntoDRGListFromTempTable
CREATE PROCEDURE USP_INSERTINTODRGLISTFROMTEMPTABLE
    (@CanUpdateTitle BIT = 0)
AS BEGIN
    IF
        (@CanUpdateTitle = 1)
        BEGIN
            UPDATE MST_DRG SET
                DRGTITLE = T.DRGTITLE,
                MDC = T.MDC,
                TYPE = T.TYPE,
                WEIGHTS = T.WEIGHTS,
                GEOMETRICMEANLOS = T.GEOMETRICMEANLOS,
                ARITHMETICMEANLOS = T.ARITHMETICMEANLOS,
                UPDATEDON = GETDATE()
            FROM DRGTEMPTABLE AS T
            LEFT JOIN MST_DRG AS M ON T.DRGCODE = M.DRGNUMBER
            WHERE M.ID IS NOT NULL
        END
    INSERT INTO MST_DRG (
        DRGNUMBER,
        DRGTITLE,
        STATUS,
        MDC,
        TYPE,
        WEIGHTS,
        GEOMETRICMEANLOS,
        ARITHMETICMEANLOS,
        CREATEDON
    ) SELECT
        T.DRGCODE,
        T.DRGTITLE,
        1,
        T.MDC,
        T.TYPE,
        T.WEIGHTS,
        T.GEOMETRICMEANLOS,
        T.ARITHMETICMEANLOS,
        GETDATE()
    FROM DRGTEMPTABLE AS T
    LEFT JOIN MST_DRG AS M ON T.DRGCODE = M.DRGNUMBER
    WHERE M.ID IS NULL
    SELECT @@ROWCOUNT AS RCOUNT
END