Create Procedure USP_GETALLEVENTS
    (
        @Patient_ID int,
        @AppointmentId int,
        @StartDate datetime,
        @EndDate datetime
    )
As Begin
    Select
        TPA.ID,
        PATIENTAPPOINTMENTTYPEID,
        MAT.APPOINTMENTTYPE,
        PATIENT_ID,
        PRESCRIBER_ID,
        MP.PRESCRIBERFIRSTNAME,
        MP.PRESCRIBERLASTNAME,
        APPOINTMENTDATE,
        APPOINTMENTTIME,
        NOTES,
        DIDPATIENTVISIT,
        SERVICETYPE,
        STARTDATE,
        ENDDATE,
        STARTTIME,
        ENDTIME,
        APPOINTMENTTYPEID
    From TRN_PATIENT_APPOINTMENT As TPA
    Inner Join
        MST_PATIENTAPPOINTMENTTYPE As MAT
        On TPA.PATIENTAPPOINTMENTTYPEID = MAT.ID
    Inner Join MST_PRESCRIBER As MP On TPA.PRESCRIBER_ID = MP.ID
    Where
        (@AppointmentId = 0 Or TPA.ID = @AppointmentId)
        And (@Patient_ID = 0 Or TPA.PATIENT_ID = @Patient_ID)
        And TPA.STARTDATE >= @StartDate
        And TPA.ENDDATE >= @EndDate
        And TPA.ISDELETED = 0
End
