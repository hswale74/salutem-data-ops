Create Procedure USP_GETASSOCIATEDALLACTIVITIESFORUSER
    (
        @PatientID int = 0,
        @userId int,
        @SelectedAssociatedActivityID varchar(Max) = ''
    )
As Begin Set Nocount On Begin
    Select
        PATIENT_ACTIVITY_ID As PATIENTACTIVITYID,
        Cast(DATEOFSERVICE As date) As DATEOFSERVICE,
        Case
            When
                A.ACTIVITYTYPE In ('Call', 'EnrollmentStatusNote')
                Then
                    Coalesce(
                        TPA.ACTIVITY_ACTUAL_END_TIME,
                        TPA.ACTIVITY_ACTUAL_START_TIME,
                        TPA.ACTIVITY_START_DATE
                    )
            Else TPAL.ENCOUNTERDATE
        End As ENCOUNTERDATE,
        Case
            When A.ACTIVITYTYPE = 'Call' Then 'PatientCommunication' Else
                A.ACTIVITYTYPE
        End As ACTIVITYTYPE,
        U.USER_FIRST_NAME + ' ' + U.USER_LAST_NAME As ACTIVITYASSIGNEDTONAME
    From TRN_PATIENT_ACTIVITY As TPA
    Inner Join MST_ACTIVITY As A On TPA.ACTIVITY_ID = A.ACTIVITY_ID
    Inner Join MST_USER As U On TPA.ACTIVITY_ASSIGNED_TO = U.USER_ID
    Left Join
        TRNPATIENTASSESSMENTLOG As TPAL
        On TPA.PATIENT_ACTIVITY_ID = TPAL.PATIENTACTIVITYID
    Where
        PATIENT_ID = @PatientID
        And (
            (
                TPA.ACTIVITY_ASSIGNED_TO = @userId
                And @SelectedAssociatedActivityID = ''
            )
            Or @SelectedAssociatedActivityID != ''
        )
        And ACTIVITY_START_STATUS = 3
        And TPA.ACTIVITY_STATUS = 1
        And A.ACTIVITYTYPE Not In ('SignatureAttestation')
        And A.ACTIVITYTYPE In (
            'ClinicalCareScreening',
            'InitialAssessment',
            'ProgressNote',
            'GroupNote',
            'PsychConsult'
        )
        And (
            @SelectedAssociatedActivityID = ''
            Or (
                TPA.PATIENT_ACTIVITY_ID In (
                    Select *
                    From dbo.func_Split(@SelectedAssociatedActivityID, ',')
                )
            )
        )
    Order By Cast(ENCOUNTERDATE As date) Desc
End End --EXEC USP_GetAssociatedAllActivitiesForUser 22310, '03/15/2023','ClinicalCareScreening'     
