-- EXEC USP_GetPatientStatusReasonOptionsList 6,5
Create Procedure USP_GETPATIENTSTATUSREASONOPTIONSLIST
    (@StatusId INT, @ReasonId INT)
As Begin
    Select
        ID,
        STATUSID,
        REASONID,
        OPTIONID,
        OPTIONTEXT,
        HASTEXTFIELD,
        TEXTFIELDLABLENAME,
        HASREASON
    From MSTPATIENTSTATUSREASONSOPTIONS
    Where STATUSID = @StatusId And REASONID = @ReasonId
End
