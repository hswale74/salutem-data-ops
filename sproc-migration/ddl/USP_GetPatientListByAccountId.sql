 Create procedure [dbo].USP_GetPatientListByAccountId ( 	@userId int, 	@AccountId INT, 	@search nvarchar(50) = '',  	@orderBy nvarchar(50) = 'Paitent_ID',  	@orderDir varchar(4) = 'asc',  	@pageIndex int = 0,  	@pageSize int = 99999, 	@DateOfBirth Datetime =null ) AS BEGIN 	SET NOCOUNT ON; 	Declare @isAdmin BIT; 	SET @isAdmin = dbo.func_IsUserAdmin(@userId);  	--getting list of practices assigned to user. 	--This is for to get only assigned practices patient for the user. 	CREATE TABLE #AssignedPracticesID ( 		ID INT 	)  	INSERT INTO #AssignedPracticesID Select DISTINCT MP.ID FROM  Mst_Practice  MP  	LEFT JOIN TrnUserPractices UP ON UP.PracticeID = MP.ID   	WHERE  ( @isAdmin = 1 OR UP.UserID = @userId ); -- AND MP.PracticeStatus = 1;  	WITH Result AS ( 		SELECT  			patient.Patient_ID, 			patient.Account_ID, 			patient.Patient_First_Name, 			patient.Patient_Last_Name, 			patient.Patient_First_Name + ' '+ patient.Patient_Last_Name  AS Patient_Full_Name, 			patient.Patient_DOB, 			patient.Mobile, 			patient.Patient_Status, 			patient.Patient_MRN, 			Patient_Gender, 			TPI.PrimaryInsurance, 			MI.Insurance AS PrimaryInsuranceName, 			patient.PatientStatusId, 			MPS.StatusName AS DispalyPatientStatus, 			MP.PracticeName 		FROM dbo.Mst_Patient patient  		INNER JOIN #AssignedPracticesID AP ON  patient.PatientPracticeId = AP.ID -- Listing out users practices assigned patients only. 		INNER JOIN Mst_Practice MP ON MP.ID = patient.PatientPracticeId 		LEFT JOIN Trn_PatientInsurance TPI ON patient.Patient_ID = TPI.PatientId 		LEFT JOIN Mst_Insurance MI ON TPI.PrimaryInsurance = MI.ID 		LEFT JOIN MstPatientStatuses MPS ON patient.PatientStatusId = MPS.ID 		WHERE patient.Account_ID = @AccountId  AND  ((Patient_First_Name + ' ' + Patient_Last_Name) LIKE '%' + @search + '%' 			OR (Patient_Last_Name + ' ' + Patient_First_Name) LIKE '%' + @search + '%' 			OR Patient_MRN LIKE '%' + @search + '%' 			OR patient.Mobile LIKE '%' + @search + '%')  			AND (@isAdmin = 1 OR patient.Patient_Status = 1) 			AND (patient.Patient_DOB =  @DateOfBirth OR @DateOfBirth is null) 	),  	OrderByResult AS (SELECT *, 			ROW_NUMBER() over ( 			order BY case when @orderBy = 'Patient_Full_Name' and @orderDir = 'asc' then Patient_Full_Name end, 						case when @orderBy = 'Patient_Full_Name' and @orderDir = 'desc' then Patient_Full_Name end desc, 						case when @orderBy = 'Patient_DOB' and @orderDir = 'asc' then Patient_DOB end, 						case when @orderBy = 'Patient_DOB' and @orderDir = 'desc' then Patient_DOB end desc, 						case when @orderBy = 'Patient_Age' and @orderDir = 'asc' then Patient_DOB end, 						case when @orderBy = 'Patient_Age' and @orderDir = 'desc' then Patient_DOB end desc, 						case when @orderBy = 'PrimaryInsuranceName' and @orderDir = 'asc' then PrimaryInsuranceName end, 						case when @orderBy = 'PrimaryInsuranceName' and @orderDir = 'desc' then PrimaryInsuranceName end desc, 						case when @orderBy = 'DispalyPatientStatus' and @orderDir = 'asc' then DispalyPatientStatus end, 						case when @orderBy = 'DispalyPatientStatus' and @orderDir = 'desc' then DispalyPatientStatus end desc, 						case when @orderBy = 'Patient_Status' and @orderDir = 'asc' then Patient_Status end, 						case when @orderBy = 'Patient_Status' and @orderDir = 'desc' then Patient_Status end desc 			) AS RowNumber FROM Result  	)   	SELECT *, (Select Count(Patient_ID) FROM Result) TotalRows   	FROM OrderByResult  	WHERE --OrderByResult.RowNumber BETWEEN ((@pageIndex * @pageSize) + 1) AND ((@pageIndex + 1) * @pageSize) 		OrderByResult.RowNumber BETWEEN (@pageIndex + 1) AND (@pageIndex  + @pageSize) 	DROP TABLE #AssignedPracticesID; END -- EXEC USP_GetPatientListByAccountId 18, 22