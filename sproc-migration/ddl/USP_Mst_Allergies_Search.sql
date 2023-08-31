-- Exec USP_Mst_Allergies_Search 'Dilantin'
Create Procedure USP_MST_ALLERGIES_SEARCH (@SearchText nvarchar(Max)) As Begin
    Select
        ALLERGY_ID,
        ALLERG_NAME
    From MST_ALLERGIES Where ALLERG_NAME Like @SearchText + '%'
End
