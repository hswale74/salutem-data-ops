-- EXEC USP_Trn_Patient_Pharmcy 3
Create Procedure USP_TRN_PATIENT_PHARMCY (@PatientId INT) As Begin
    Select
        TPP.ID,
        PATIENT_ID,
        MP.ID As PHARMACY_ID,
        PHARMACYNABP,
        PHARMACYNAME,
        PHARMACYADDRESS,
        PHARMACYCITY,
        PHARMACYSTATE,
        PHARMACYZIP,
        PHARMACYPHONE,
        PHARMACYNPI
    From TRN_PATIENT_PHARMCY As TPP
    Inner Join MST_PHARMACY As MP On TPP.PHARMACY_ID = MP.ID
    Where TPP.PATIENT_ID = @PatientId And ISNULL(TPP.ISDELETED, 0) = 0
End
