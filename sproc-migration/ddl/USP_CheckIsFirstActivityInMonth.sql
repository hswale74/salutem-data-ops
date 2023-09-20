 Create procedure USP_CheckIsFirstActivityInMonth ( 	@ActivityId INT,  	@PatientID INT,  	@DateOfService DateTime ) AS BEGIN 	SET NOCOUNT ON 	SELECT Count(Patient_Activity_ID) AS IsFirstActivityInMonth FROM Trn_Patient_Activity  	WHERE Activity_ID = @ActivityId 		AND Patient_ID = @PatientID  		AND Activity_Start_Status=3 AND IsSubmited = 1 -- activity should be completed and submitted 		AND DateOfService = @DateOfService END -- EXEC USP_CheckIsFirstActivityInMonth 18, 19278, '30Apr2022'