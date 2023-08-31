--EXEC USP_CheckRxNumberExist 3,'511119','2021-03-10 00:00:00.000',10278
Create Procedure USP_CHECKRXNUMBEREXIST
    (@PatientId INT, @RxNumber VARCHAR(50), @ServiceDate DATETIME, @Med_ID INT)
As Begin
    Select PATIENT_DOSAGE_ID
    From TRN_PATIENT_MED_DOSAGE
    Where
        SERVICEDATE = @ServiceDate
        And MED_ID = @Med_ID
        And PATIENT_ID = @PatientId
        And RXNUMBER = @RxNumber
End
