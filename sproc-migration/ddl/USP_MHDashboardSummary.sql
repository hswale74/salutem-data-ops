-- EXEC USP_MHDashboardSummary 17, 22 --SP_Recompile USP_MHDashboardSummary  
Create Procedure USP_MHDASHBOARDSUMMARY
    (@userId INT, @AccountId INT, @patientId INT = 0)
As Begin
    Declare @isAdmin BIT Set @isAdmin = (Select dbo.func_IsUserAdmin(@userId));
    Declare @TodayDate Date = (Select Convert(Date, GetDate()));
    Declare @TodaysActivityDetailCount INT;
    Declare @TodaysActivityDetail_CompletedCount INT;
    Declare @TodaysActivityDetail_InProgressCount INT;
    Declare @TodaysActivityDetail_YetToStartCount INT;
    Declare @DelayedActivityCount INT;
    Declare @Escalated INT = 0;
    Set
        @TodaysActivityDetailCount = (Select COUNT(TPA.PATIENT_ACTIVITY_ID) From TRN_PATIENT_ACTIVITY As TPA Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID Where P.PATIENT_STATUS = 1 And ((@isAdmin = 1 And TPA.ACTIVITY_ASSIGNED_TO > 0) Or TPA.ACTIVITY_ASSIGNED_TO = @userId) And TPA.ACTIVITY_START_DATE = @TodayDate And P.ACCOUNT_ID = @AccountId And TPA.ACTIVITY_STATUS = 1);
    Set
        @TodaysActivityDetail_CompletedCount = (Select COUNT(TPA.PATIENT_ACTIVITY_ID) From TRN_PATIENT_ACTIVITY As TPA Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID Where P.PATIENT_STATUS = 1 And ((@isAdmin = 1 And TPA.ACTIVITY_ASSIGNED_TO > 0) Or TPA.ACTIVITY_ASSIGNED_TO = @userId) And P.ACCOUNT_ID = @AccountId And TPA.ACTIVITY_START_DATE = @TodayDate And TPA.ACTIVITY_START_STATUS = 3 And TPA.ACTIVITY_STATUS = 1);
    Set
        @TodaysActivityDetail_InProgressCount = (Select COUNT(TPA.PATIENT_ACTIVITY_ID) From TRN_PATIENT_ACTIVITY As TPA Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID Where P.PATIENT_STATUS = 1 And ((@isAdmin = 1 And TPA.ACTIVITY_ASSIGNED_TO > 0) Or TPA.ACTIVITY_ASSIGNED_TO = @userId) And P.ACCOUNT_ID = @AccountId And TPA.ACTIVITY_START_DATE = @TodayDate And TPA.ACTIVITY_START_STATUS = 2 And TPA.ACTIVITY_STATUS = 1);
    Set
        @TodaysActivityDetail_YetToStartCount = (Select COUNT(TPA.PATIENT_ACTIVITY_ID) From TRN_PATIENT_ACTIVITY As TPA Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID Where P.PATIENT_STATUS = 1 And ((@isAdmin = 1 And TPA.ACTIVITY_ASSIGNED_TO > 0) Or TPA.ACTIVITY_ASSIGNED_TO = @userId) And ISNULL(TPA.ACTIVITY_START_STATUS, 1) = 1 And TPA.ACTIVITY_START_DATE = @TodayDate And P.ACCOUNT_ID = @AccountId And TPA.ACTIVITY_STATUS = 1);
    Set
        @DelayedActivityCount = (Select COUNT(TPA.PATIENT_ACTIVITY_ID) From TRN_PATIENT_ACTIVITY As TPA Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID Where P.PATIENT_STATUS = 1 And ((@isAdmin = 1 And TPA.ACTIVITY_ASSIGNED_TO > 0) Or TPA.ACTIVITY_ASSIGNED_TO = @userId) And TPA.ACTIVITY_START_DATE < @TodayDate And P.ACCOUNT_ID = @AccountId And ISNULL(TPA.ACTIVITY_START_STATUS, 1) In (1, 2) And TPA.ACTIVITY_STATUS = 1);
    Select
        @TodaysActivityDetailCount As TODAYTOTALCOUNT,
        @TodaysActivityDetail_CompletedCount As TODAYSCOMPLETEDCOUNT,
        @TodaysActivityDetail_InProgressCount As TODAYSINPROGRESSCOUNT,
        @TodaysActivityDetail_YetToStartCount As TODAYSYETTOSTARTCOUNT,
        @DelayedActivityCount As DELAYEDACTIVITYCOUNT,
        @Escalated As ESCALATEDCOUNT
End
