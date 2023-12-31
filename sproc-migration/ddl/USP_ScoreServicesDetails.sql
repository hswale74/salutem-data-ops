--exec USP_ScoreServicesDetails 22,'2022-07-01','2022-07-31'
CREATE PROCEDURE USP_SCORESERVICESDETAILS
    (@AccountID INT, @fromDate DATETIME, @toDate DATETIME)
AS BEGIN
    SELECT * INTO #TempTable FROM (SELECT
        PATIENTID,
        PATIENTACTIVITYID,
        DATEOFSERVICE,
        ACTIVITYASSIGNEDTO
    FROM TRNPATIENTBILLINGDETAIL AS BD WHERE BD.ACTIVITYTYPE IN ('InitialAssessment', 'ProgressNote') AND BD.DATEOFSERVICE >= @fromDate AND BD.DATEOFSERVICE <= @toDate) AS A;
    SELECT *
    INTO #TempTable2 FROM (
        SELECT
            A.PATIENTID AS PATIENT_ID,
            A.PATIENTACTIVITYID,
            A.DATEOFSERVICE,
            PR.PHQ9FIRSTSCORE AS PHQ9_SCORE,
            PR.GAD7FIRSTSCORE AS GAD7_SCORE,
            PR.PRACTICENAME AS PRACTICE_NAME,
            PR.REFERRINGPROVIDERNAME AS PRIMARY_PHYSICIAN,
            PR.DIAGNOSIS AS DX_CODES,
            D.ICD10CODE AS REASON_FOR_REFERRAL,
            P.PATIENT_FIRST_NAME + ' ' + P.PATIENT_LAST_NAME AS PATIENT_NAME,
            U.USER_FIRST_NAME + ' ' + U.USER_LAST_NAME AS BCM
        FROM #TempTable AS A
        INNER JOIN TRNPATIENTREGISTRY AS PR ON A.PATIENTID = PR.PATIENTID
        INNER JOIN
            MST_PATIENT AS P
            ON
                A.PATIENTID = P.PATIENT_ID
                AND P.PATIENT_STATUS = 1
                AND P.ACCOUNT_ID = @AccountId
        LEFT JOIN MST_USER AS U ON A.ACTIVITYASSIGNEDTO = U.USER_ID
        LEFT JOIN MST_DIAGNOSIS AS D ON P.REASONFORREFERRAL = D.DIAGNOSIS_ID
    ) AS B; SELECT
        B.DATEOFSERVICE AS DATE_RECORDED,
        B.PRACTICE_NAME,
        B.PHQ9_SCORE,
        B.GAD7_SCORE,
        B.PRIMARY_PHYSICIAN,
        B.BCM,
        B.PATIENT_NAME,
        B.PATIENT_ID,
        B.DX_CODES,
        B.REASON_FOR_REFERRAL,
        PHQSCORE.SCORE AS PHQ9_INITIAL,
        GADSCORE.SCORE AS GAD7_INITIAL
    FROM #TempTable2 AS B
    CROSS APPLY
        FUNCGETPATIENTPHQORGADSCORE(B.PATIENT_ID, B.PATIENTACTIVITYID, 1, 1)
            AS PHQSCORE
    CROSS APPLY
        FUNCGETPATIENTPHQORGADSCORE(B.PATIENT_ID, B.PATIENTACTIVITYID, 1, 2)
            AS GADSCORE
    DROP TABLE #TempTable;
    DROP TABLE #TempTable2;
END
