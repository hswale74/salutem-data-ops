 CREATE procedure USP_MHAuditReport ( 	@AccountID INT, 	@fromDate DATETIME, 	@toDate DATETIME, 	@search nvarchar(50) = '',  	@orderBy nvarchar(50) = 'PatientFullName',  	@orderDir varchar(4) = 'asc',  	@pageIndex int = 0, 	@PageSize int = 999999999 ) AS BEGIN WITH Result AS ( 	SELECT  			P.Patient_ID, 			P.Patient_First_Name +' ' + P.Patient_Last_Name AS PatientFullName, 			TPAL.EncounterDate, 			TPA.Activity_Actual_End_Time AS DateOfCompletion, 			TPA.Patient_Activity_ID, 			A.Activity_Description ActivityName, 			TPA.SpentTimeInMinutes, 			U.User_First_Name+ ' ' + U.User_Last_Name AS ActivityAssignedToName, 			MP.PracticeName, 			TPA.IsBillable, 			ME.Discription ActivityStartStatus, 			EN.Discription AS NoteTypeName, 			TPA.TypeOfCommunicationName, 			--TPA.ActivityOutcomeName, 			CASE WHEN A.ActivityType='InitialAssessment' OR A.ActivityType='ProgressNote'OR A.ActivityType='GroupNote'OR A.ActivityType='ClinicalCareScreening' THEN MAE.Discription ELSE TPA.ActivityOutcomeName END AS ActivityOutcomeName 		FROM Trn_Patient_Activity TPA 		INNER JOIN Mst_Patient P ON TPA.Patient_ID = P.Patient_ID AND P.Account_ID = @AccountID AND TPA.Activity_Actual_End_Time IS NOT NULL 		INNER JOIN Mst_Activity A ON TPA.Activity_ID = A.Activity_ID 		INNER JOIN Mst_User U ON TPA.Activity_Assigned_To = U.User_ID 		LEFT JOIN Mst_Practice MP ON P.PatientPracticeId = MP.ID 		LEFT JOIN TrnPatientAssessmentLog TPAL ON TPA.Patient_Activity_ID = TPAL.PatientActivityID 		LEFT JOIN Mst_Enum ME ON TPA.Activity_Start_Status = ME.EnumValue AND ME.EnumType = 'ActivityStatus' 		LEFT JOIN Mst_Enum EN ON TPAL.NoteType = EN.ID AND EN.EnumType='GenericNoteType'  		LEFT JOIN MstAssessmentEnum MAE ON TPAL.Attendance = MAE.EnumValue AND MAE.EnumType = 'Attendance' 		WHERE TPA.Activity_Start_Status = 3 		AND CONVERT(Date,TPA.Activity_Actual_End_Time) >= @fromDate and CONVERT(Date,TPA.Activity_Actual_End_Time) <= @toDate 		AND ((P.Patient_First_Name + ' ' + P.Patient_Last_Name)  LIKE '%' + @search + '%' 				OR (P.Patient_Last_Name + ' ' + P.Patient_First_Name) LIKE '%' + @search + '%' 				OR MP.PracticeName LIKE '%' + @search + '%' 				OR TPA.Patient_Activity_ID LIKE '%' + @search + '%' 			) ), OrderByResult AS (SELECT *, 			ROW_NUMBER() over ( 			order BY case when @orderBy = 'PatientFullName' and @orderDir = 'asc' then PatientFullName end, 					case when @orderBy = 'PatientFullName' and @orderDir = 'desc' then PatientFullName end desc, 					case when @orderBy = 'PracticeName' and @orderDir = 'asc' then PracticeName end, 					case when @orderBy = 'PracticeName' and @orderDir = 'desc' then PracticeName end desc 			) AS RowNumber FROM Result  	) 	SELECT *, (Select Count(Patient_ID) FROM Result) TotalRows   	FROM OrderByResult  	WHERE 		OrderByResult.RowNumber BETWEEN (@pageIndex + 1) AND (@pageIndex  + @pageSize) END