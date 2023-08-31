--EXEC USP_Member_Import 'C:\Working\IPEP\Upload\c3_member_20210331.csv'
Create Procedure USP_MEMBER_IMPORT (@FilePath NVarchar(Max)) As Begin
    Truncate Table SALUTEM_TEMP.DBO.MEMBER_IMPORT;
    Declare @SQL NVARCHAR(Max) = '' Set
        @SQL
        = N'     BULK INSERT Salutem_Temp.DBO.Member_Import       FROM '''
        + @filePath
        + '''       WITH ( 		FIRSTROW = 2,         FIELDTERMINATOR = '','', 		FORMAT=''CSV'',         ROWTERMINATOR = ''0x0a'', 		TABLOCK       )'
    Exec SP_EXECUTESQL @SQL;
    Select Count(MEMBER_MBI) As ROWSCOUNT
    From SALUTEM_TEMP.DBO.MEMBER_IMPORT
End
