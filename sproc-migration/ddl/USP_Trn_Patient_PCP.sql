--EXEC USP_Trn_Patient_PCP 3
Create Procedure USP_TRN_PATIENT_PCP (@PatientId INT) As Begin
    Select
        TPCP.ID,
        TPCP.PATIENTID,
        PCPID,
        MPCP.PCP_FIRST_NAME,
        MPCP.PCP_LAST_NAME,
        PCP_PHONE,
        MPCP.PCP_FIRST_NAME + ' ' + MPCP.PCP_LAST_NAME As PCPFULLNAME
    From TRN_PATIENT_PCP As TPCP
    Inner Join MST_PCP As MPCP On TPCP.PCPID = MPCP.ID
    Where TPCP.PATIENTID = @PatientId And ISNULL(TPCP.ISDELETED, 0) = 0
End
