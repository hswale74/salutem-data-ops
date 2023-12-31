Create Procedure USP_INSERTINTO_TRN_BOOKAPPOINTMENT
    (
        @Patient_Id INT,
        @ResourceID INT,
        @ServiceType INT,
        @StartDate DATE,
        @EndDate DATE,
        @StartTime TIME,
        @EndTime TIME,
        @SelectedTimeZoneID INT,
        @UtcStartDateTime DATETIME,
        @UtcEndDateTime DATETIME,
        @LocationID INT,
        @RepeatTypeID INT,
        @RepeatEvery INT,
        @RepeatOn NVARCHAR(50),
        @RepeatEnd NVARCHAR(50),
        @RepeatEndUntil DATE,
        @RepeatEndCount INT,
        @USER_ID INT
    )
As Begin
    Declare @AppointmentId INT = 0 Insert Into TRN_BOOKAPPOINTMENT (
        PATIENT_ID,
        RESOURCEID,
        SERVICETYPE,
        STARTDATE,
        ENDDATE,
        STARTTIME,
        ENDTIME,
        SELECTEDTIMEZONEID,
        UTCSTARTDATETIME,
        UTCENDDATETIME,
        LOCATIONID,
        REPEATTYPEID,
        REPEATEVERY,
        REPEATON,
        REPEATEND,
        REPEATENDUNTIL,
        REPEATENDCOUNT,
        CREATEDBY,
        CREATEDON,
        UPDATEDBY,
        UPDATEDON
    ) Values (
        @Patient_Id,
        @ResourceID,
        @ServiceType,
        @StartDate,
        @EndDate,
        @StartTime,
        @EndTime,
        @SelectedTimeZoneID,
        @UtcStartDateTime,
        @UtcEndDateTime,
        @LocationID,
        @RepeatTypeID,
        @RepeatEvery,
        @RepeatOn,
        @RepeatEnd,
        @RepeatEndUntil,
        @RepeatEndCount,
        @USER_ID,
        GETDATE(),
        @USER_ID,
        GETDATE()
    )
    Select @AppointmentId = SCOPE_IDENTITY()
    Select @AppointmentId As APPOINTMENTID
End
