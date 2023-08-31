Create Procedure USP_GETLOGGEDINUSERACCOUNTLIST (@UserId int) As Begin
    Select
        UA.ID,
        ACCOUNTID,
        USERID,
        ACCOUNT_NAME,
        ACCOUNTTYPE,
        ME.DISCRIPTION As ACCOUNTTYPENAME
    From TRN_USER_ACCOUNT As UA
    Inner Join
        MST_ACCOUNT As MA
        On
            UA.ACCOUNTID = MA.ACCOUNT_ID
            And UA.USERID = @UserId
            And MA.ACCOUNT_STATUS = 1
    Inner Join
        MST_ENUM As ME
        On MA.ACCOUNTTYPE = ME.ENUMVALUE And ME.ENUMTYPE = 'AccountType'
    Order By ACCOUNT_NAME
End
