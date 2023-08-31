-- EXEC USP_GetMHCallOutcomeReasonOptionsList 11
Create Procedure USP_GETMHCALLOUTCOMEREASONOPTIONSLIST
    (@OutcomeID INT, @ReasonID INT)
As Begin
    Select
        ID,
        OUTCOMEID,
        REASONID,
        OPTIONID,
        OPTIONTEXT,
        HASTEXTFIELD,
        TEXTFIELDLABLENAME,
        HASREASON
    From MSTMHCALLOUTCOMEREASONOPTIONS
    Where OUTCOMEID = @OutcomeID And REASONID = @ReasonID
End
