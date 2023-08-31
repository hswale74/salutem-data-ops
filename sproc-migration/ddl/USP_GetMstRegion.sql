-- EXEC USP_GetMstRegion
Create Procedure USP_GETMSTREGION As Begin
    Select Distinct REGION From MST_REGIONTOCMSCONTACT
End
