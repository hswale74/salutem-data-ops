Create Procedure USP_GETPRACTICELISTFORPHYSICIAN (@PhysicianId INT) As Begin
    Select
        TP.ID,
        PRACTICEID,
        PHYSICIANID,
        MP.PRACTICENAME
    From TRN_PRACTICEPHYSICIANS As TP
    Inner Join MST_PRACTICE As MP On TP.PRACTICEID = MP.ID
    Where TP.ISDELETED = 0 And TP.PHYSICIANID = @PhysicianId
End