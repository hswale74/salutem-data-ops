 Create procedure USP_GetDashboardReportDaily  ( 	@AccountID int, 	@MonthOfService date, 	@SubReportType int,-- 1=>DailyReferral, 2=> DailyPatientStatus 	@PracticeID int ) AS BEGIN 	SET NOCOUNT ON 	BEGIN 	--SELECT day,DayName,date,DirectCare,COCM,MAT,SelfPay,AttemptingToEnroll,Enrolled,EnrolledNotResponding,Declined, 	--Graduated,Ineligible,UnableToReach,NewReferral,IntakePending,RescheduleIntake,CheckContactInformation,Total FROM AddDateOfMonth 	IF (@SubReportType = 1) 	BEGIN 			CREATE TABLE #AddDateOfMonth 			( 				day int, 				date date, 				DayName varchar(250), 				CreatedOn date, 				DirectCare int, 				COCM int, 				MAT int, 				Self int, 				AttemptingToEnroll int, 				Enrolled int, 				EnrolledNotResponding int, 				Declined int, 				Graduated int, 				Ineligible int, 				UnableToReach int, 				NewReferral int, 				IntakePending int, 				RescheduleIntake int, 				CheckContactInformation int 			) 	 			DECLARE @date DATE = (SELECT DATEADD(month, DATEDIFF(month, 0, @MonthOfService), 0)) 	 			;WITH N(N)AS  			(SELECT 1 FROM(VALUES(1),(1),(1),(1),(1),(1))M(N)), 			dayDate(N)AS(SELECT ROW_NUMBER()OVER(ORDER BY N.N)FROM N,N a) 			 			INSERT INTO #AddDateOfMonth(day,date,DayName) 			SELECT top(day(EOMONTH(@date))) 			  N day 			  ,dateadd(d,N-1, @date) date, 			  FORMAT(dateadd(d,N-1, @date),'dddd') DayName 			FROM dayDate 	 			--SELECT * FROM #AddDateOfMonth AM 	 			;With Result AS 			( 				SELECT * FROM 				( 					SELECT E.Discription,P.TypeOfReferral,CONVERT(Date,P.ReferralDate) CreatedOn 					FROM Mst_Patient P	 					LEFT JOIN Mst_Enum E ON P.TypeOfReferral = E.EnumValue AND E.EnumType = 'TypeOfReferral' AND P.Account_ID = @AccountID 					WHERE MONTH(P.ReferralDate) = MONTH(@MonthOfService) AND Year(P.ReferralDate) = Year(@MonthOfService) 					AND (@PracticeID = 0 OR P.PatientPracticeId = @PracticeID) 					GROUP BY E.Discription,P.TypeOfReferral, P.ReferralDate,P.Patient_First_Name, P.Patient_Last_Name 				) t 				PIVOT( 					COUNT(TypeOfReferral) 					FOR Discription IN ( 					[Direct Care], 					[CoCM], 					[MAT], 					[Self-Pay] 					) 				) AS pivot_table 			) 			UPDATE ADM SET CreatedOn = R.CreatedOn, DirectCare=Coalesce(R.[Direct Care],0),COCM=Coalesce(R.CoCM,0) 			,MAT=Coalesce(R.MAT,0),Self=Coalesce(R.[Self-Pay],0) 			FROM #AddDateOfMonth ADM 			INNER JOIN Result R ON ADM.date = R.CreatedOn  				SELECT  					day, 					DayName, 					date, 					Coalesce(DirectCare,0) DirectCare, 					Coalesce(COCM,0) COCM, 					Coalesce(MAT,0) MAT, 					Coalesce(Self,0) SelfPay, 					AttemptingToEnroll, 					Enrolled, 					EnrolledNotResponding, 					Declined, 					Graduated, 					Ineligible, 					UnableToReach, 					NewReferral, 					IntakePending, 					RescheduleIntake, 					CheckContactInformation, 					isnull(DirectCare,0) + isnull(COCM,0) + isnull(MAT,0)+ isnull(Self,0) as Total 				FROM #AddDateOfMonth 			 			DROP TABLE #AddDateOfMonth 	END 	ELSE 	BEGIN 		CREATE TABLE #AddDateOfMonthS 			( 				day int, 				date date, 				DayName varchar(250), 				CreatedOn date, 				DirectCare int, 				COCM int, 				MAT int, 				SelfPay int, 				AttemptingToEnroll int, 				Enrolled int, 				EnrolledNotResponding int, 				Declined int, 				Graduated int, 				Ineligible int, 				UnableToReach int, 				NewReferral int, 				IntakePending int, 				RescheduleIntake int, 				CheckContactInformation int 			)  			DECLARE @dates DATE = (SELECT DATEADD(month, DATEDIFF(month, 0, @MonthOfService), 0)) 	 			;WITH N(N)AS  			(SELECT 1 FROM(VALUES(1),(1),(1),(1),(1),(1))M(N)), 			dayDate(N)AS(SELECT ROW_NUMBER()OVER(ORDER BY N.N)FROM N,N a) 			 			INSERT INTO #AddDateOfMonthS(day,date,DayName) 			SELECT top(day(EOMONTH(@dates))) 			  N day 			  ,dateadd(d,N-1, @dates) date, 			  FORMAT(dateadd(d,N-1, @dates),'dddd') DayName 			FROM dayDate  			;With Results AS 			( 				SELECT * FROM 				( 					SELECT E.EnumStatusName StatusName,PS.PatientStatusId,CONVERT(Date,PS.PatientStatusDate) CreatedOn 					FROM TrnPatientStatusLog PS 					INNER JOIN Mst_Patient P ON PS.PatientID = P.Patient_ID AND P.Account_ID = @AccountID 					LEFT JOIN MstPatientStatuses E ON PS.PatientStatusId = E.StatusID 					WHERE MONTH(PS.PatientStatusDate) = MONTH(@MonthOfService) AND Year(PS.PatientStatusDate) = Year(@MonthOfService) 					AND (@PracticeID = 0 OR P.PatientPracticeId = @PracticeID) 					GROUP BY E.EnumStatusName,PS.PatientStatusId, PS.PatientStatusDate,P.Patient_First_Name, P.Patient_Last_Name 				) t 				PIVOT( 					COUNT(PatientStatusId) 					FOR StatusName IN ( 					[AttemptingToEnroll], 					[Enrolled], 					[EnrolledNotResponding], 					[Declined], 					[Graduated], 					[Ineligible], 					[UnableToReach], 					[NewReferral], 					[IntakePending], 					[RescheduleIntake], 					[CheckContactInformation] 					) 				) AS pivot_table 			) 			UPDATE ADM SET CreatedOn = R.CreatedOn, AttemptingToEnroll=Coalesce(R.[AttemptingToEnroll],0), 			Enrolled=Coalesce(R.[Enrolled],0),EnrolledNotResponding=Coalesce(R.[EnrolledNotResponding],0), 			Declined=Coalesce(R.[Declined],0),Graduated=Coalesce(R.[Graduated],0),			 			Ineligible=Coalesce(R.[Ineligible],0),UnableToReach=Coalesce(R.[UnableToReach],0), 			NewReferral=Coalesce(R.[NewReferral],0),IntakePending=Coalesce(R.[IntakePending],0), 			RescheduleIntake=Coalesce(R.[RescheduleIntake],0),CheckContactInformation=Coalesce(R.[CheckContactInformation],0) 			FROM #AddDateOfMonthS ADM 			INNER JOIN Results R ON ADM.date = R.CreatedOn  			SELECT  					day, 					DayName, 					date, 					DirectCare, 					COCM, 					MAT, 					SelfPay, 					Coalesce(AttemptingToEnroll,0) AttemptingToEnroll, 					Coalesce(Enrolled,0) Enrolled, 					Coalesce(EnrolledNotResponding,0) EnrolledNotResponding, 					Coalesce(Declined,0) Declined, 					Coalesce(Graduated,0) Graduated, 					Coalesce(Ineligible,0) Ineligible, 					Coalesce(UnableToReach,0) UnableToReach, 					Coalesce(NewReferral,0) NewReferral, 					Coalesce(IntakePending,0) IntakePending, 					Coalesce(RescheduleIntake,0) RescheduleIntake, 					Coalesce(CheckContactInformation,0) CheckContactInformation, 					isnull(AttemptingToEnroll,0) + isnull(Enrolled,0) + isnull(EnrolledNotResponding,0)+ isnull(Declined,0) + 					isnull(Graduated,0) + isnull(Ineligible,0) + isnull(UnableToReach,0)+ isnull(NewReferral,0) + 					isnull(IntakePending,0) + isnull(RescheduleIntake,0) + isnull(CheckContactInformation,0) 					as Total 				FROM #AddDateOfMonthS 			 			DROP TABLE #AddDateOfMonthS 	END 	END END --EXEC USP_GetDashboardReportDaily 31,'2023-02-27',2,0 --CREATE TABLE AddDateOfMonth --			( --				day int, --				date date, --				DayName varchar(250), --				CreatedOn date, --				DirectCare int, --				COCM int, --				MAT int, --				SelfPay int, --				AttemptingToEnroll int, --				Enrolled int, --				EnrolledNotResponding int, --				Declined int, --				Graduated int, --				Ineligible int, --				UnableToReach int, --				NewReferral int, --				IntakePending int, --				RescheduleIntake int, --				CheckContactInformation int, --				Total int --			) --DROP TABLE AddDateOfMonth