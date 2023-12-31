CREATE PROCEDURE USP_MHAUDITREPORTSERVICES
    (@AccountID INT, @fromDate DATETIME, @toDate DATETIME)
AS BEGIN
    SELECT
        P.PATIENT_ID,
        TPAL.ENCOUNTERDATE,
        TPA.ACTIVITY_ACTUAL_END_TIME AS DATEOFCOMPLETION,
        TPA.PATIENT_ACTIVITY_ID,
        A.ACTIVITY_DESCRIPTION AS ACTIVITYNAME,
        TPA.SPENTTIMEINMINUTES,
        MP.PRACTICENAME,
        P.PATIENT_FIRST_NAME + ' ' + P.PATIENT_LAST_NAME AS PATIENTFULLNAME,
        U.USER_FIRST_NAME + ' ' + U.USER_LAST_NAME AS ACTIVITYASSIGNEDTONAME
    FROM TRN_PATIENT_ACTIVITY AS TPA
    INNER JOIN
        MST_PATIENT AS P
        ON
            TPA.PATIENT_ID = P.PATIENT_ID
            AND P.ACCOUNT_ID = @AccountID
            AND TPA.ACTIVITY_ACTUAL_END_TIME IS NOT NULL
    INNER JOIN MST_ACTIVITY AS A ON TPA.ACTIVITY_ID = A.ACTIVITY_ID
    INNER JOIN MST_USER AS U ON TPA.ACTIVITY_ASSIGNED_TO = U.USER_ID
    LEFT JOIN MST_PRACTICE AS MP ON P.PATIENTPRACTICEID = MP.ID
    LEFT JOIN
        TRNPATIENTASSESSMENTLOG AS TPAL
        ON TPA.PATIENT_ACTIVITY_ID = TPAL.PATIENTACTIVITYID
    WHERE
        TPA.ACTIVITY_START_STATUS = 3
        AND CONVERT(Date, TPA.ACTIVITY_ACTUAL_END_TIME) >= @fromDate
        AND CONVERT(Date, TPA.ACTIVITY_ACTUAL_END_TIME) <= @toDate
END
