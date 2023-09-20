 CREATE PROCEDURE USP_GetAllReadmissionCheckLog ( 	@userId int, 	@AccountId INT, 	@search nvarchar(50) = '', 	@orderBy nvarchar(50) = 'Paitent_ID',  	@orderDir varchar(4) = 'asc',  	@pageIndex int = 0,  	@pageSize int = 99999 ) AS BEGIN 	SET NOCOUNT ON; 	--DECLARE @currentYear int = YEAR(GETDATE()); 	Declare @isAdmin BIT; 	SET @isAdmin = dbo.func_IsUserAdmin(@userId);  	WITH Result AS ( 		Select  		IPL.Patient_ID, 		P.Patient_First_Name, 		P.Patient_Last_Name, 		P.Patient_First_Name + ' '+ P.Patient_Last_Name  AS PatientFullName, 		P.Patient_DOB, 		P.Patient_MRN, 		patientContact.Patient_Contact_Phone, 		IPL.InPatientLogId, 		IPL.DischargeDate, 		IPL.EpisodeId, 		VFHV.Discription AS FistHomeVisitStatus, 		VSHV.Discription AS SecondHomeVisitStatus, 		VPC.Discription AS PharmacyConsultStatus, 		IPL.ProgramCompletion, 		VTHV.Discription AS ThirdHomeVisitStatus 	From Trn_InPatientLog IPL with (nolock) 	INNER JOIN Mst_Patient P ON P.Patient_ID = IPL.Patient_ID AND P.Patient_Status = 1 AND P.Account_ID = @AccountId 	LEFT JOIN View_HWF_PatientFirstHomeVisitStatus VFHV ON VFHV.Patient_ID = IPL.Patient_ID AND VFHV.InPatientLogId = IPL.InPatientLogId 	LEFT JOIN View_HWF_PatientSecondHomeVisitStatus VSHV ON VSHV.Patient_ID = IPL.Patient_ID AND VSHV.InPatientLogId = IPL.InPatientLogId 	LEFT JOIN View_HWF_PharmacyConsultActivityStatus VPC ON VPC.Patient_ID = IPL.Patient_ID AND VPC.InPatientLogId = IPL.InPatientLogId 	LEFT JOIN dbo.Trn_Patient_Contact patientContact with (nolock) ON P.Patient_ID = patientContact.Patient_ID AND patientContact.IsPrimary = 1  	LEFT JOIN View_HWF_PatientThirdHomeVisitStatus VTHV ON VSHV.Patient_ID = IPL.Patient_ID AND VTHV.InPatientLogId = IPL.InPatientLogId 	 	WHERE ((Patient_First_Name + ' ' + Patient_Last_Name)  LIKE '%' + @search + '%' 				OR Patient_MRN LIKE '%' + @search + '%' 				OR patientContact.Patient_Contact_Phone LIKE '%' + @search + '%' 			) 			AND IPL.DischargeDate IS NOT NULL 			AND IPL.EnrollmentStatus = 1 -- Accepted 			AND DATEDIFF(day, IPL.DischargeDate, GETDATE()) >= 30 			AND (IPL.ProgramCompletion IS NULL OR (IPL.ProgramCompletion IS NULL AND IPL.ReadmissionDate IS NOT NULL)) 			 	),  	OrderByResult AS (SELECT *, 			ROW_NUMBER() over ( 			order BY case when @orderBy = 'PatientFullName' and @orderDir = 'asc' then PatientFullName end, 					case when @orderBy = 'PatientFullName' and @orderDir = 'desc' then PatientFullName end desc, 					case when @orderBy = 'DischargeDate' and @orderDir = 'asc' then DischargeDate end, 					case when @orderBy = 'DischargeDate' and @orderDir = 'desc' then DischargeDate end desc, 					case when @orderBy = 'FistHomeVisitStatus' and @orderDir = 'asc' then FistHomeVisitStatus end, 					case when @orderBy = 'FistHomeVisitStatus' and @orderDir = 'desc' then FistHomeVisitStatus end desc, 					case when @orderBy = 'SecondHomeVisitStatus' and @orderDir = 'asc' then SecondHomeVisitStatus end, 					case when @orderBy = 'SecondHomeVisitStatus' and @orderDir = 'desc' then SecondHomeVisitStatus end desc 				) AS RowNumber FROM Result  	)   	SELECT *, (Select Count(Patient_ID) FROM Result) TotalRows   	FROM OrderByResult  	WHERE 		OrderByResult.RowNumber BETWEEN (@pageIndex + 1) AND (@pageIndex  + @pageSize)  END  --EXEC USP_GetAllReadmissionCheckLog 3,21,'','PatientFullName','desc',0,10