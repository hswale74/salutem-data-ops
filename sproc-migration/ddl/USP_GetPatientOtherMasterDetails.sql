-- EXEC USP_GetPatientOtherMasterDetails 3
CREATE PROCEDURE dbo.usp_getpatientothermasterdetails
    (@PatientID INT)
AS BEGIN
    SELECT
        p.patient_id,
        referringproviderid,
        ph.physicianname AS referringprovidername,
        patientpracticeid,
        pr.practicename,
        pr.practicetype,
        pr.billingtype,
        pr.billingtime,
        pr.billingtimefees
    FROM mst_patient AS p
    LEFT JOIN mst_physician AS ph ON p.referringproviderid = ph.id
    LEFT JOIN mst_practice AS pr ON p.patientpracticeid = pr.id
    WHERE p.patient_id = @PatientID
END
