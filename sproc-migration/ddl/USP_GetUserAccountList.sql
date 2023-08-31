Create Procedure USP_GETUSERACCOUNTLIST (@UserId int) As Begin
    Select
        ID,
        ACCOUNTID,
        USERID,
        ACCOUNT_NAME
    From TRN_USER_ACCOUNT As UA
    Inner Join
        MST_ACCOUNT As MA
        On UA.ACCOUNTID = MA.ACCOUNT_ID And UA.USERID = @UserId;
End
