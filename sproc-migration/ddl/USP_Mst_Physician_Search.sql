--Exec USP_Mst_Physician_Search ''
Create Procedure dbo.usp_mst_physician_search
    (@SearchText nvarchar(Max))
As Begin
    Select
        id,
        physicianname,
        phone,
        email
    From mst_physician
    Where (physicianname Like @SearchText + '%' Or phone Like @SearchText + '%')
End
