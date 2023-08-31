Create Procedure USP_GETUSERPRACTICELIST (@UserId int) As Begin
    Select
        MP.ID,
        MP.PRACTICENAME,
        UP.USERID
    From TRNUSERPRACTICES As UP
    Inner Join
        MST_PRACTICE As MP
        On UP.PRACTICEID = MP.ID And MP.PRACTICESTATUS = 1 And UP.USERID = @UserId;
End
