CREATE PROCEDURE USP_GETREADMISSIONDETAILS (@InPatientLogId int) AS BEGIN
    SET NOCOUNT ON; SELECT
        IPL.INPATIENTLOGID,
        IPL.DISCHARGEDATE,
        IPL.READMISSIONDATE,
        IPL.READMISSIONDIAGNOSIS,
        P.PATIENT_FIRST_NAME + ' ' + P.PATIENT_LAST_NAME AS PATIENTFULLNAME
    FROM TRN_INPATIENTLOG AS IPL WITH (NOLOCK)
    INNER JOIN
        MST_PATIENT AS P
        ON
            IPL.PATIENT_ID = P.PATIENT_ID
            AND IPL.INPATIENTLOGID = @InPatientLogId
END
