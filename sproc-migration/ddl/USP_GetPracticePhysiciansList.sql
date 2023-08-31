-- EXEC USP_GetPracticePhysiciansList	 1
Create Procedure USP_GETPRACTICEPHYSICIANSLIST (@PracticeId INT) As Begin
    Select
        TP.ID,
        PRACTICEID,
        PHYSICIANID,
        MP.PHYSICIANNAME,
        MP.PHONE,
        MP.EMAIL
    From TRN_PRACTICEPHYSICIANS As TP
    Inner Join
        MST_PHYSICIAN As MP
        On TP.PHYSICIANID = MP.ID And MP.ISDELETED = 0
    Where TP.ISDELETED = 0 And TP.PRACTICEID = @PracticeId
End
