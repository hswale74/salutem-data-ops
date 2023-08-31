--EXEC USP_GetPatientActivityGenericNoteDetails 3179
Create Procedure USP_GETPATIENTACTIVITYGENERICNOTEDETAILS
    (@PatientActivityID int = 0)
As Begin
    Set
        Nocount On Begin
        If
            Exists (
                Select ID
                From TRNPATIENTASSESSMENTLOG
                Where PATIENTACTIVITYID = @PatientActivityId
            )
            Begin
                Select
                    TPA.ASSESSMENTID,
                    P.PATIENT_DOB,
                    TPA.PATIENT_ACTIVITY_ID,
                    TPA.PATIENT_ID,
                    TPA.ACTIVITY_ID,
                    TPA.SPENTTIMEINMINUTES,
                    PA.NOTETYPE,
                    PA.NOTETYPEOTHERTEXT,
                    TPA.ACTIVITY_START_STATUS,
                    PA.GENNOTEDISCRIPTION,
                    TPA.ACTIVITYOUTCOME,
                    PA.ACTIVITYTYPEASSOCIATED,
                    PA.GENNOTEMONTHOFSERVICE,
                    PA.ASSOCIATEDPATIENTACTIVITYID,
                    P.PATIENT_FIRST_NAME
                    + ' '
                    + P.PATIENT_LAST_NAME As PATIENTFULLNAME
                From TRN_PATIENT_ACTIVITY As TPA
                Inner Join
                    TRNPATIENTASSESSMENTLOG As PA
                    On TPA.PATIENT_ACTIVITY_ID = PA.PATIENTACTIVITYID
                Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID
                Where TPA.PATIENT_ACTIVITY_ID = @PatientActivityId
            End
        Else Begin
            Select
                TPA.ASSESSMENTID,
                P.PATIENT_DOB,
                TPA.PATIENT_ACTIVITY_ID,
                TPA.PATIENT_ID,
                TPA.ACTIVITY_ID,
                TPA.SPENTTIMEINMINUTES,
                0 As NOTETYPE,
                '' As NOTETYPEOTHERTEXT,
                TPA.ACTIVITY_START_STATUS,
                '' As GENNOTEDISCRIPTION,
                TPA.ACTIVITYOUTCOME,
                '' As ACTIVITYTYPEASSOCIATED,
                null As GENNOTEMONTHOFSERVICE,
                0 As ASSOCIATEDPATIENTACTIVITYID,
                P.PATIENT_FIRST_NAME
                + ' '
                + P.PATIENT_LAST_NAME As PATIENTFULLNAME
            From TRN_PATIENT_ACTIVITY As TPA
            Inner Join MST_PATIENT As P On TPA.PATIENT_ID = P.PATIENT_ID
            Where TPA.PATIENT_ACTIVITY_ID = @PatientActivityId
        End
    End
End
