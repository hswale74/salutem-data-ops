-- Exec USP_CreatePDCActivity 3,3,11,'29Mar2021','08:00',4038 
Create Procedure USP_CREATEPDCACTIVITY
    (
        @PatientId int,
        @UserId int,
        @Activity_ID int,
        @Activity_Start_Date datetime,
        @Activity_Start_Time time(7),
        @EnrollmentID int
    )
As Begin
    Declare @PatientActivityID int = 0;
    Insert Into TRN_PATIENT_ACTIVITY (
        PATIENT_ID,
        ACTIVITY_ID,
        ACTIVITY_TYPE_ID,
        ACTIVITY_START_DATE,
        ACTIVITY_START_TIME,
        ACTIVITY_START_STATUS,
        ACTIVITY_STATUS,
        ACTIVITY_CRETAEDAT,
        ACTIVITY_CREATEDBY,
        PATIENT_ENROLL_ID
    ) Values (
        @PatientId,
        @Activity_ID,
        1,
        @Activity_Start_Date,
        @Activity_Start_Time,
        1,
        1,
        GetDate(),
        @UserId,
        @EnrollmentID
    ) Set @PatientActivityID = SCOPE_IDENTITY()
    Select @PatientActivityID
End
