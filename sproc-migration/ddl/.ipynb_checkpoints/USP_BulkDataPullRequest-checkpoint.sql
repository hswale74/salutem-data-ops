Create Procedure USP_BULKDATAPULLREQUEST (@FilePath NVarchar(Max)) As Begin Truncate Table SALUTEM_TEMP.DBO.MEMBERMRN; Declare @SQL NVARCHAR(Max) = '' Set @SQL = N'      BULK INSERT Salutem_Temp.DBO.MemberMRN       FROM ''' + @filePath + '''       WITH ( 		FIRSTROW = 2, 		FORMAT = ''csv'',         FIELDTERMINATOR = '','',         ROWTERMINATOR = ''0x0a'', 		TABLOCK       )' Exec SP_EXECUTESQL @SQL; Select Count(*) As ROWSCOUNT From SALUTEM_TEMP.DBO.MEMBERMRN End  --EXEC USP_BulkDataPullRequest 'C:\temp\CSV-Members that need to be deleted in Salutem Final (002).csv' --EXEC USP_BulkDataPullRequest 'C:\Working\Salutem\Docs\DataPullReport\CSV-MRN and FIN List for Data Pull Aug 22 (002).csv' --SELECT * FROM Salutem_Temp.DBO.MemberMRN