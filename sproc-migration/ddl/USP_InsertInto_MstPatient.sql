 Create procedure USP_InsertInto_MstPatient ( 	@USER_ID INT, 	@Account_ID int, 	@MEMBER_MBI VARCHAR(50), 	@MEMBER_LAST_NAME VARCHAR(100), 	@MEMBER_FIRST_NAME VARCHAR(50), 	@MEMBER_GENDER VARCHAR(10), 	@MEMBER_DATE_OF_BIRTH DATETIME, 	@MEMBER_MIDDLE_INITIAL VARCHAR(20), 	@MEMBER_ADDRESS1 NVARCHAR(100), 	@MEMBER_ADDRESS2 NVARCHAR(100), 	@MEMBER_CITY NVARCHAR(150), 	@MEMBER_STATE NVARCHAR(150), 	@MEMBER_ZIP_CODE VARCHAR(20), 	@MEMBER_PHONE_NUMBER VARCHAR(20), 	@MEMBER_SECONDARY_PHONE_NUMBER VARCHAR(20), 	@MEMBER_PRIMARY_LANGUAGE VARCHAR(50), 	@LIS_INDICATOR VARCHAR(10), 	@DISABLED_FLAG VARCHAR(10), 	@PLAN_EFFECTIVE_DATE DATETIME, 	@TERM_DATE_FROM_PLAN DATETIME, 	@CMR_FLAG VARCHAR(10), 	@CMS_CONTRACT_NUMBER VARCHAR(20), 	@CMS_PBP_NUMBER VARCHAR(50), 	@LTC_INDICATOR VARCHAR(10), 	@REASON_FOR_TERMINATION VARCHAR(500), 	@PCP_FIRST_NAME VARCHAR(250), 	@PCP_LAST_NAME VARCHAR(250), 	@PCP_PHONE VARCHAR(20), 	@MAD_PDC VARCHAR(50), 	@MAH_PDC VARCHAR(50), 	@MAC_PDC VARCHAR(50), 	@MEMBER_TIMEZONE_NAME VARCHAR(250), 	@CLIENT_DEF_3 VARCHAR(250) )AS BEGIN 	BEGIN TRANSACTION 	BEGIN TRY 		DECLARE @Patient_MRN VARCHAR(50) = (SELECT Patient_MRN FROM Mst_Patient WHERE Patient_MRN = @MEMBER_MBI) 		DECLARE @Patient_ID INT = 0; 		DECLARE @NewEnrollmentCount INT = 0; 		DECLARE @YEAR INT = YEAR(GetDATE()); 		--We have to make sure Patient MRN number already not exist. 		IF @Patient_MRN IS NULL 		BEGIN  			DECLARE @LanguageID INT = (SELECT Language_ID FROM Mst_Language WHERE Language_Description = @MEMBER_PRIMARY_LANGUAGE) 			 			IF @LanguageID IS NULL AND LEN(ISNULL(@MEMBER_PRIMARY_LANGUAGE,'')) > 0 			BEGIN  				INSERT Mst_Language (Language_Description,Language_Status,Language_CreatedAt,Language_CreatedBy)  				VALUES (@MEMBER_PRIMARY_LANGUAGE, 1,GETDATE(),@USER_ID) 				SET @LanguageID = SCOPE_IDENTITY(); 			END 			DECLARE @CLIENT_DEF_3_Text varchar(250) = ''; 			IF @CLIENT_DEF_3 IS NULL 			BEGIN 				SET @CLIENT_DEF_3 = 0; 				SET @CLIENT_DEF_3_Text = (SELECT Discription FROM Mst_Enum WHERE EnumType='Client_Def_3' AND EnumValue=0) 			END 			ELSE 			BEGIN 				SET @CLIENT_DEF_3_Text = (SELECT Discription FROM Mst_Enum WHERE EnumType='Client_Def_3' AND EnumValue=@CLIENT_DEF_3) 			END 			--ELSE  			--BEGIN 			--	SET @LanguageID = 0; 			--END  			INSERT INTO Mst_Patient (Account_ID,Patient_First_Name,Patient_Middle_Name,Patient_Last_Name,Patient_MRN,Patient_DOB,Patient_Gender,Patient_LanguageID, 			Patient_Low_Income,Patient_Status,Patient_CreatedAt,Patient_CreatedBy,DisableFlag,CMRCompleted,CMROutcome,MACScore,MADScore,MAHScore,CLIENT_DEF_3,CLIENT_DEF_3_Text,Mobile) 			VALUES (@Account_ID,@MEMBER_FIRST_NAME,@MEMBER_MIDDLE_INITIAL,@MEMBER_LAST_NAME,@MEMBER_MBI,@MEMBER_DATE_OF_BIRTH,@MEMBER_GENDER,@LanguageID, 			@LIS_INDICATOR,1,GETDATE(),@USER_ID,@DISABLED_FLAG,@CMR_FLAG,0,@MAC_PDC,@MAD_PDC,@MAH_PDC,@CLIENT_DEF_3,@CLIENT_DEF_3_Text,@MEMBER_PHONE_NUMBER)  			SET @Patient_ID = SCOPE_IDENTITY();  			-- Newly added patient id should be greter than 0 			IF @Patient_ID > 0 			BEGIN  				--Generating first PDC score history log 				INSERT INTO TrnPatientPDCHistoryLog (PatientId,MACScore,MADScore,MAHScore,CreatedOn)VALUES (@Patient_ID,@MAC_PDC,@MAD_PDC,@MAH_PDC,GETDATE());  				--Creating primary contact details 				IF LEN(ISNULL(@MEMBER_PHONE_NUMBER, '')) > 0  				BEGIN  					INSERT INTO Trn_Patient_Contact (Patient_ID,Patient_Relation_ID,Patient_Contact_Phone,Patient_Contact_Add1,Patient_Contact_Add2,Patient_Contact_City,Patient_Contact_State,Patient_Contact_CreatedAt,Patient_Contact_CreatedBy,IsPrimary,ZipCode,TimeZoneName)  					VALUES (@Patient_ID,1,@MEMBER_PHONE_NUMBER,@MEMBER_ADDRESS1,@MEMBER_ADDRESS2,@MEMBER_CITY,@MEMBER_STATE,GETDATE(),@USER_ID,1,@MEMBER_ZIP_CODE,@MEMBER_TIMEZONE_NAME) 				END  				--Creating secondary contact details 				IF LEN(ISNULL(@MEMBER_SECONDARY_PHONE_NUMBER, '')) > 0  				BEGIN  					INSERT INTO Trn_Patient_Contact (Patient_ID,Patient_Relation_ID,Patient_Contact_Phone,Patient_Contact_Add1,Patient_Contact_Add2,Patient_Contact_City,Patient_Contact_State,Patient_Contact_CreatedAt,Patient_Contact_CreatedBy,IsPrimary,ZipCode,TimeZoneName)  					VALUES (@Patient_ID,1,@MEMBER_SECONDARY_PHONE_NUMBER,@MEMBER_ADDRESS1,@MEMBER_ADDRESS2,@MEMBER_CITY,@MEMBER_STATE,GETDATE(),@USER_ID,0,@MEMBER_ZIP_CODE,@MEMBER_TIMEZONE_NAME) 				END 				 				--Creating Trn_Patient_UHCDetails transaction entry for the patient. 				INSERT INTO Trn_Patient_UHCDetails (PatientId,Plan_Effective_Date,Term_Date_From_Plan,CMS_Contract_Number,CMS_PBP_Number,LTC_Indicator,Reason_For_Termination) 				VALUES (@Patient_ID,@PLAN_EFFECTIVE_DATE,@TERM_DATE_FROM_PLAN,@CMS_CONTRACT_NUMBER,@CMS_PBP_NUMBER,@LTC_INDICATOR,@REASON_FOR_TERMINATION)  				--Patient PCP Details if any of below fields not empty then only we are processing for PCP 				IF LEN(ISNULL(@PCP_FIRST_NAME,'')) > 0 OR LEN(ISNULL(@PCP_LAST_NAME,'')) > 0 OR LEN(ISNULL(@PCP_PHONE,'')) > 0 				BEGIN  					--Checking if Master PCP exists for for the details  					--IF not exist then creating Master PCP details first. 					DECLARE @PCP_ID INT = (SELECT ID FROM Mst_PCP WHERE PCP_First_Name = @PCP_FIRST_NAME AND PCP_Last_Name = @PCP_LAST_NAME AND PCP_Phone = @PCP_PHONE) 					IF @PCP_ID IS NULL  					BEGIN  						INSERT INTO Mst_PCP (PCP_First_Name,PCP_Last_Name,PCP_Phone,CreatedBy,CreatedAt) 						VALUES (@PCP_FIRST_NAME,@PCP_LAST_NAME,@PCP_PHONE,@USER_ID,GETDATE()) 						SET @PCP_ID = SCOPE_IDENTITY(); 					END  					--Checking if the PCP id is greater than 0 then only creating Trn PCP entry for the patient. 					IF @PCP_ID > 0 					BEGIN  						INSERT INTO Trn_Patient_PCP (PatientId,PcpId) VALUES (@Patient_ID,@PCP_ID);  					END 				END 				--End PCP details block  				--Creating Enrollment queue entry for the current year. 				 				INSERT INTO Trn_Patient_Enrollment (Patient_ID,Patient_Enrollment_Status,CreatedOn,CreatedBy,UploadedYear) 				VALUES (@Patient_ID, 0, GETDATE(), @USER_ID, @YEAR) 				SET @NewEnrollmentCount = @@ROWCOUNT 			END 		END 		ELSE 		BEGIN 			DECLARE @ULanguageID INT = (SELECT Language_ID FROM Mst_Language WHERE Language_Description = @MEMBER_PRIMARY_LANGUAGE) 			 			IF @ULanguageID IS NULL AND LEN(ISNULL(@MEMBER_PRIMARY_LANGUAGE,'')) > 0 			BEGIN  				INSERT Mst_Language (Language_Description,Language_Status,Language_CreatedAt,Language_CreatedBy)  				VALUES (@MEMBER_PRIMARY_LANGUAGE, 1,GETDATE(),@USER_ID) 				SET @ULanguageID = SCOPE_IDENTITY(); 			END 			--DECLARE @UCLIENT_DEF_3_Text varchar(250) = ''; 			--IF @CLIENT_DEF_3 IS NULL 			--BEGIN 			--	SET @CLIENT_DEF_3 = 0; 			--	SET @UCLIENT_DEF_3_Text = (SELECT Discription FROM Mst_Enum WHERE EnumType='Client_Def_3' AND EnumValue=0) 			--END 			--ELSE 			--BEGIN 			--	SET @UCLIENT_DEF_3_Text = (SELECT Discription FROM Mst_Enum WHERE EnumType='Client_Def_3' AND EnumValue=@CLIENT_DEF_3) 			--END 			SET @Patient_ID = (SELECT Patient_ID FROM Mst_Patient WHERE Patient_MRN = @Patient_MRN) 			IF @Patient_ID > 0 			BEGIN 				UPDATE Mst_Patient SET 					Patient_First_Name = @MEMBER_FIRST_NAME 					,Patient_Middle_Name = @MEMBER_MIDDLE_INITIAL 					,Patient_Last_Name = @MEMBER_LAST_NAME 					,Patient_DOB = @MEMBER_DATE_OF_BIRTH 					,Patient_Gender = @MEMBER_GENDER 					,Patient_LanguageID = @ULanguageID 					,Mobile = @MEMBER_PHONE_NUMBER 					--,CLIENT_DEF_3 = @CLIENT_DEF_3 					--,CLIENT_DEF_3_Text = @UCLIENT_DEF_3_Text 				WHERE Patient_ID = @Patient_ID  				--UPDATING Trn_Patient_UHCDetails transaction entry for the patient. 				DECLARE @ExistingUHCPatient_ID INT = (SELECT PatientId FROM Trn_Patient_UHCDetails WHERE PatientId = @Patient_ID); 				IF @ExistingUHCPatient_ID > 0 				BEGIN 					INSERT INTO Trn_Patient_UHCDetailsHistoryLog (PatientId,Plan_Effective_Date,Term_Date_From_Plan,MTM_Effective_Date,MTM_Term_Date 						,CMS_Contract_Number,CMS_PBP_Number,LTC_Indicator,Reason_For_Termination, CreatedOn) 					SELECT  						PatientId,Plan_Effective_Date,Term_Date_From_Plan,MTM_Effective_Date,MTM_Term_Date 						,CMS_Contract_Number,CMS_PBP_Number,LTC_Indicator,Reason_For_Termination, GETDATE() 					FROM Trn_Patient_UHCDetails WHERE PatientId = @Patient_ID  					UPDATE Trn_Patient_UHCDetails SET  						Plan_Effective_Date = @PLAN_EFFECTIVE_DATE 						,Term_Date_From_Plan = @TERM_DATE_FROM_PLAN 						,CMS_Contract_Number = @CMS_CONTRACT_NUMBER 						,CMS_PBP_Number = @CMS_PBP_NUMBER 					WHERE PatientId = @Patient_ID 				END 				ELSE 				BEGIN 					--Creating Trn_Patient_UHCDetails transaction entry for the patient. 					INSERT INTO Trn_Patient_UHCDetails (PatientId,Plan_Effective_Date,Term_Date_From_Plan,CMS_Contract_Number,CMS_PBP_Number,LTC_Indicator,Reason_For_Termination) 					VALUES (@Patient_ID,@PLAN_EFFECTIVE_DATE,@TERM_DATE_FROM_PLAN,@CMS_CONTRACT_NUMBER,@CMS_PBP_NUMBER,@LTC_INDICATOR,@REASON_FOR_TERMINATION) 				END  				-- UPDATING Contact detail 				--UPDATING primary contact details 				IF LEN(ISNULL(@MEMBER_PHONE_NUMBER, '')) > 0  				BEGIN  					UPDATE Trn_Patient_Contact  					SET Patient_Contact_State = @MEMBER_STATE, 						Patient_Contact_Phone = @MEMBER_PHONE_NUMBER 					WHERE Patient_ID = @Patient_ID AND IsPrimary = 1 				END  				--UPDATING secondary contact details 				IF LEN(ISNULL(@MEMBER_SECONDARY_PHONE_NUMBER, '')) > 0  				BEGIN  					UPDATE Trn_Patient_Contact SET Patient_Contact_State = @MEMBER_STATE 					WHERE Patient_ID = @Patient_ID AND IsPrimary = 0 				END  				---UPDATE UPLOADED YEAR For patient which is still Not enrolled or Not attempted 				DECLARE @UploadedYear INT 				select @UploadedYear = UploadedYear from Trn_Patient_Enrollment where Patient_ID= @Patient_ID and Patient_Enrollment_Status = 0 				IF @UploadedYear < @YEAR 				  BEGIN 					UPDATE Trn_Patient_Enrollment 					SET UploadedYear = @YEAR, 					    UpdatedOn =  GETDATE(), 						UpdatedBy = @USER_ID	 					WHERE Patient_ID= @Patient_ID 					AND Patient_Enrollment_Status = 0 				  END 			END 		END  		COMMIT TRANSACTION 		SELECT @Patient_ID as Patient_ID,@NewEnrollmentCount as NewEnrollmentCount  	END TRY 	BEGIN CATCH 		ROLLBACK TRAN 	END CATCH END  --EXEC USP_InsertInto_MstPatient 3,5,'4GD7K38GG46','MOBLEY','ALICE','Female','1955-01-08 00:00:00.000','R','253 TRECER RD',NULL,'COPE','SC','29038','8035341866','9860628787','ENGLISH', --'1','0','2021-01-01 00:00:00.000',NULL,NULL,'R2604','001',NULL,NULL,'F','MARION DWIGHT MD PA (RHC)','(803) 245-5168',2,3,4  --SELECT * FROM Mst_Patient WHERE Patient_MRN='4GD7K38GG46' --SELECT * FROM Trn_Patient_Contact WHERE Patient_ID=8411 --SELECT * FROM Trn_Patient_PCP WHERE PatientId=8411 --SELECT * FROM Trn_Patient_UHCDetails WHERE PatientId=8411 --SELECT * FROM Trn_Patient_Enrollment WHERE Patient_ID =8411  --DELETE FROM Trn_Patient_Contact WHERE Patient_ID=8411 --DELETE FROM Trn_Patient_PCP WHERE PatientId=8411 --DELETE FROM Trn_Patient_UHCDetails WHERE PatientId=8411 --DELETE FROM Trn_Patient_Enrollment WHERE Patient_ID =8411 --DELETE FROM Mst_Patient WHERE Patient_MRN='4GD7K38GG46'