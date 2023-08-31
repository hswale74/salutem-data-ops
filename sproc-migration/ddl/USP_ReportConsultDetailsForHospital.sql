CREATE PROCEDURE USP_REPORTCONSULTDETAILSFORHOSPITAL
    (
        @AccountID INT,
        @ActivityID INT,
        @fromDate DATETIME,
        @toDate DATETIME,
        @pccId INT,
        @status INT,
        @orderBy NVARCHAR(50) = 'PatientFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
AS BEGIN WITH CONSULTDETAILSRESULT AS (
    SELECT
        PATIENT.PATIENT_MRN,
        PATIENT.PATIENT_ID,
        PA.PATIENT_ACTIVITY_ID,
        ME.ENUMNAME AS ACTIVITY_START_STATUS,
        PA.ACTIVITY_ASSIGNED_TO,
        PATIENT.ZIPCODE,
        I.FINNUMBER,
        I.DRG,
        I.UNITNUMBER,
        PA.ACTIVITYREASONDESCRIPTION,
        PA.ACTIVITYOUTCOMENAME,
        PA.SPENTTIMEINMINUTES,
        I.DISCHARGEDATE,
        PATIENT.PATIENT_FIRST_NAME
        + ' '
        + PATIENT.PATIENT_LAST_NAME AS PATIENTFULLNAME,
        COALESCE(
            PA.ACTIVITY_ACTUAL_END_TIME,
            PA.ACTIVITY_ACTUAL_START_TIME,
            PA.ACTIVITY_START_DATE
        ) AS ACTIVITY_DATE,
        U.USER_FIRST_NAME + ' ' + U.USER_LAST_NAME AS PCCFULLNAME
    FROM TRN_PATIENT_ACTIVITY AS PA
    INNER JOIN
        DBO.MST_PATIENT AS PATIENT
        ON
            PA.PATIENT_ID = PATIENT.PATIENT_ID
            AND PATIENT.ACCOUNT_ID = @AccountID
    INNER JOIN
        MST_ENUM AS ME
        ON
            COALESCE(PA.ACTIVITY_START_STATUS, 1) = ME.ENUMVALUE
            AND ME.ENUMTYPE = 'ActivityStatus'
    LEFT JOIN
        MST_USER AS U
        ON
            PA.ACTIVITY_ASSIGNED_TO = U.USER_ID
            AND ME.ENUMTYPE = 'ActivityStatus'
    INNER JOIN
        TRN_INPATIENTLOG AS I
        ON
            PATIENT.PATIENT_ID = I.PATIENT_ID
            AND PA.INPATIENTLOGID = I.INPATIENTLOGID
    WHERE
        CONVERT(
            DATE,
            COALESCE(
                PA.ACTIVITY_ACTUAL_END_TIME,
                PA.ACTIVITY_ACTUAL_START_TIME,
                PA.ACTIVITY_START_DATE
            )
        )
        >= @fromDate
        AND CONVERT(
            DATE,
            COALESCE(
                PA.ACTIVITY_ACTUAL_END_TIME,
                PA.ACTIVITY_ACTUAL_START_TIME,
                PA.ACTIVITY_START_DATE
            )
        )
        <= @toDate
        AND (@pccId = 0 OR PA.ACTIVITY_ASSIGNED_TO = @pccId)
        AND (@status = 0 OR COALESCE(PA.ACTIVITY_START_STATUS, 1) = @status)
        AND PA.ACTIVITY_ID = @ActivityID
),

ORDERBYRESULT AS (SELECT
    *,
    ROW_NUMBER() OVER (
        ORDER BY
            CASE
                WHEN
                    @orderBy = 'Activity_Date' AND @orderDir = 'asc'
                    THEN ACTIVITY_DATE
            END,
            CASE
                WHEN
                    @orderBy = 'Activity_Date' AND @orderDir = 'desc'
                    THEN ACTIVITY_DATE
            END DESC,
            CASE
                WHEN
                    @orderBy = 'Patient_MRN' AND @orderDir = 'asc'
                    THEN PATIENT_MRN
            END,
            CASE
                WHEN
                    @orderBy = 'Patient_MRN' AND @orderDir = 'desc'
                    THEN PATIENT_MRN
            END DESC,
            CASE
                WHEN
                    @orderBy = 'PatientFullName' AND @orderDir = 'asc'
                    THEN PATIENTFULLNAME
            END,
            CASE
                WHEN
                    @orderBy = 'PatientFullName' AND @orderDir = 'desc'
                    THEN PATIENTFULLNAME
            END DESC,
            CASE
                WHEN
                    @orderBy = 'PCCFullName' AND @orderDir = 'asc'
                    THEN PCCFULLNAME
            END,
            CASE
                WHEN
                    @orderBy = 'PCCFullName' AND @orderDir = 'desc'
                    THEN PCCFULLNAME
            END DESC
    ) AS ROWNUMBER
FROM CONSULTDETAILSRESULT)

SELECT
    *,
    (SELECT Count(PATIENT_ID) FROM CONSULTDETAILSRESULT) AS TOTALROWS
FROM ORDERBYRESULT WHERE ORDERBYRESULT.ROWNUMBER BETWEEN (@StartFrom + 1) AND (@StartFrom + @pageSize) END   -- exec [dbo].[USP_ReportConsultDetailsForHospital] @AccountID=21,@ActivityID=4,@fromDate='2022-10-10 00:00:00',@toDate='2022-11-08 00:00:00',@pccId=0,@status=0,@orderBy=N'Display_Activity_Date',@orderDir='asc',@StartFrom=0,@PageSize=10  
