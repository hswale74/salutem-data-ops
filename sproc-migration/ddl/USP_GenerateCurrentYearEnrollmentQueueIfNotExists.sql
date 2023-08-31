 Create procedure USP_GenerateCurrentYearEnrollmentQueueIfNotExists (@UserId INT) AS BEGIN 	-- this procesdure will create enrollment queue for the previous year registered patient if the enrollment entry not exist for the current year. 	DECLARE @currentYear int = YEAR(GETDATE()); 	 	WITH CurrentYearEnrollment AS ( 		SELECT P.Patient_ID,P.Patient_MRN,PE.Patient_Enroll_ID ,UploadedYear,EnrollmentDate  		From Mst_Patient P INNER JOIN Trn_Patient_Enrollment PE ON P.Patient_ID = PE.Patient_ID  		WHERE PE.UploadedYear = @currentYear OR YEAR(PE.EnrollmentDate) = @currentYear 	) 	 	INSERT INTO Trn_Patient_Enrollment (Patient_ID,Patient_Enrollment_Status,CreatedOn,CreatedBy,UploadedYear) 	SELECT P.Patient_ID,0,GETDATE(),@UserId,@currentYear 	From Salutem_Temp.dbo.Member_Import MP  	INNER JOIN Mst_Patient P ON MP.Member_MBI = P.Patient_MRN 	LEFT JOIN Trn_Patient_Enrollment PE ON P.Patient_ID = PE.Patient_ID  	WHERE (PE.Patient_Enrollment_Status IS NULL OR (PE.UploadedYear != @currentYear AND PE.Patient_Enrollment_Status > 0)) 	AND P.Patient_ID NOT IN (SELECT Patient_ID FROM CurrentYearEnrollment);  	 	SELECT @@ROWCOUNT AS [ROWCOUNT]; END  --EXEC USP_GenerateCurrentYearEnrollmentQueueIfNotExists 3