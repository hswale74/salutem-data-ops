-- EXEC USP_GetPatientStatusReasonList 11
Create Procedure USP_GETPATIENTSTATUSREASONLIST (@StatusId INT) As Begin Select
    ID,
    STATUSID,
    REASONID,
    REASONTEXT,
    HASTEXTFIELD,
    TEXTFIELDLABLENAME,
    HASREASON
From MSTPATIENTSTATUSREASONS Where STATUSID = @StatusId End
