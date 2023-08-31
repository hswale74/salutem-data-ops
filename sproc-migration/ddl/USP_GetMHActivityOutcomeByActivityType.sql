Create Procedure dbo.usp_getmhactivityoutcomebyactivitytype
    (@ActivityType varchar(250) = '')
As Begin Set Nocount On; Select
    id,
    activityoutcomename,
    activitystatusid
From mstmhactivityoutcome Where activitytypecommalist Like '%' + @ActivityType + '%' End -- EXEC USP_GetMHActivityOutcomeByActivityType 'CALL' -- SP_Recompile USP_GetMHActivityOutcomeByActivityType
