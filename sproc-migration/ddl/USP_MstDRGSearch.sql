--EXEC USP_MstDRGSearch 'acu'
Create Procedure dbo.usp_mstdrgsearch (@SearchText nvarchar(Max)) As Begin
    Select
        id,
        drgnumber,
        drgtitle
    From mst_drg
    Where
        drgnumber Like @SearchText + '%'
        Or drgtitle Like '%' + @SearchText + '%'
End
