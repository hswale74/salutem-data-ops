--EXEC USP_GetUserListByRole 22, 1, 3
Create Procedure dbo.usp_getuserlistbyrole
    (@AccountId INT, @UserRole INT, @PracticeID INT = 0)
As Begin
    Select Distinct
        user_id,
        cust_id,
        user_first_name,
        user_last_name,
        user_role,
        user_email,
        user_timezone,
        user_first_name + ' ' + user_last_name As userfullname
    From mst_user As u
    Inner Join
        trn_user_account As ua
        On
            u.user_id = ua.userid
            And ua.accountid = @AccountId
            And u.user_role = @UserRole
    Left Join trnuserpractices As up On u.user_id = up.userid
    Where
        u.user_status = 1 And (@PracticeID = 0 Or up.practiceid = @PracticeID)
End
