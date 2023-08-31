CREATE PROCEDURE dbo.usp_reportreadmissiondetailshospital
    (
        @AccountID INT,
        @fromDate DATETIME,
        @toDate DATETIME,
        @ProgramCompletionStatus INT,
        @PatientReadmitted INT,
        @orderBy NVARCHAR(50) = 'PatientFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
AS BEGIN DECLARE @Today DATETIME = GETDATE(); WITH readmissiondetailsresult AS (
    SELECT
        patient.patient_id,
        patient.patient_mrn,
        ipl.finnumber,
        ipl.unitnumber,
        ipl.dischargedate,
        ipl.ispatientreadmitted,
        ipl.readmissiondate,
        ipl.readmissiondiagnosis,
        ipl.programcompletion,
        patient.zipcode,
        drg.drgtitle,
        patient.patient_first_name
        + ' '
        + patient.patient_last_name AS patientfullname
    FROM trn_inpatientlog AS ipl
    INNER JOIN
        mst_patient AS patient
        ON
            ipl.patient_id = patient.patient_id
            AND patient.account_id = @AccountID
    LEFT JOIN mst_drg AS drg ON ipl.drg = drg.id
    WHERE
        ipl.dischargedate >= @fromDate
        AND ipl.dischargedate <= @toDate
        AND (
            @ProgramCompletionStatus = 0
            OR COALESCE(ipl.programcompletion, 0) = @ProgramCompletionStatus
        )
        AND (
            @PatientReadmitted = 0
            OR COALESCE(ipl.ispatientreadmitted, 0) = @PatientReadmitted
        )
        AND DATEDIFF(DAY, ipl.dischargedate, @Today) >= 30
        AND ipl.enrollmentstatus = 1
        AND ipl.dischargedate IS NOT NULL
),

orderbyresult AS (SELECT
    *,
    ROW_NUMBER() OVER (
        ORDER BY
            CASE
                WHEN
                    @orderBy = 'DischargeDate' AND @orderDir = 'asc'
                    THEN dischargedate
            END,
            CASE
                WHEN
                    @orderBy = 'DischargeDate' AND @orderDir = 'desc'
                    THEN dischargedate
            END DESC,
            CASE
                WHEN
                    @orderBy = 'ReadmissionDate' AND @orderDir = 'asc'
                    THEN readmissiondate
            END,
            CASE
                WHEN
                    @orderBy = 'ReadmissionDate' AND @orderDir = 'desc'
                    THEN readmissiondate
            END DESC,
            CASE
                WHEN
                    @orderBy = 'Patient_MRN' AND @orderDir = 'asc'
                    THEN patient_mrn
            END,
            CASE
                WHEN
                    @orderBy = 'Patient_MRN' AND @orderDir = 'desc'
                    THEN patient_mrn
            END DESC,
            CASE
                WHEN
                    @orderBy = 'PatientFullName' AND @orderDir = 'asc'
                    THEN patientfullname
            END,
            CASE
                WHEN
                    @orderBy = 'PatientFullName' AND @orderDir = 'desc'
                    THEN patientfullname
            END DESC,
            CASE
                WHEN
                    @orderBy = 'ProgramCompletion' AND @orderDir = 'asc'
                    THEN programcompletion
            END,
            CASE
                WHEN
                    @orderBy = 'ProgramCompletion' AND @orderDir = 'desc'
                    THEN programcompletion
            END DESC,
            CASE
                WHEN
                    @orderBy = 'IsPatientReadmitted' AND @orderDir = 'asc'
                    THEN ispatientreadmitted
            END,
            CASE
                WHEN
                    @orderBy = 'IsPatientReadmitted' AND @orderDir = 'desc'
                    THEN ispatientreadmitted
            END DESC
    ) AS rownumber
FROM readmissiondetailsresult)

SELECT
    *,
    (SELECT Count(patient_id) FROM readmissiondetailsresult) AS totalrows
FROM orderbyresult WHERE orderbyresult.rownumber BETWEEN (@StartFrom + 1) AND (@StartFrom + @pageSize) END --EXEC USP_ReportReadmissionDetailsHospital 21,'01/01/2021 12:00:00','12/08/2022 12:00:00',0,0,'Patient_MRN','asc',0,10
