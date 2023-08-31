-- Exec USP_GetAccountWiseActivityList 5
Create Procedure dbo.usp_getaccountwiseactivitylist (@AccountId INT) As Begin
    Declare
        @AccountTypeId INT
        = (Select accounttype From mst_account Where account_id = @AccountId)
    Select
        ma.activity_id,
        ma.activity_name,
        ma.activity_description,
        ma.activity_status,
        maa.activitytypevalue,
        ma.activitytype,
        ma.sequencenumber,
        ma.activitynumber
    From mst_account As m
    Inner Join
        mst_accountactivity As maa
        On
            m.accounttype = maa.accounttypeid
            And m.account_id = @AccountId
            And maa.accounttypeid = @AccountTypeId
    Inner Join
        mst_activity As ma
        On maa.activitytype = ma.activitytype And ma.activity_status = 1
    Order By sequencenumber, activitynumber
End
