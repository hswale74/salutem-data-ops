 Create procedure USP_Update_All_Patient_NextRefillDueDate AS  BEGIN 	DECLARE @RowCount INT = 0; 	With NextRefillDueDate AS (  		Select Patient_ID,Min(Refill_Next_Date) Refill_Next_Date  		From Trn_Patient_Med_Dosage WHERE Refill_Next_Date > GETDATE() AND ISNULL(Patient_Dosage_Prescribed_Status, 1) = 1 --Getting next minimum date from active medicine only. 		GROUP BY Patient_ID  	)  	Update Mst_Patient SET ReFillDueDate = NRD.Refill_Next_Date  	FROM Mst_Patient P INNER JOIN NextRefillDueDate NRD ON P.Patient_ID = NRD.Patient_ID 	SELECT @RowCount = @@ROWCOUNT 	SELECT @RowCount END -- exec USP_Update_All_Patient_NextRefillDueDate