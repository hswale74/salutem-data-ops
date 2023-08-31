--EXEC USP_GetAllMedicineList '','NDC', 'asc',0,10 Create procedure [dbo].[USP_GetAllMedicineList] (	 	@search nvarchar(50) = '',	 	@orderBy nvarchar(50) = 'Med_Name',  	@orderDir varchar(4) = 'asc',  	@pageIndex int = 0,  	@pageSize int = 99999 ) AS BEGIN 	SET NOCOUNT ON; 	WITH Result AS ( 		SELECT NDC.NDC,NDC.ProductName,NDC.PRODUCTNDC,NDC.Med_ID,NDC.Strength_ID,M.Med_Name,S.Med_Strength,NDC.DOSAGEFORMNAME,NDC.ROUTENAME,NDC.SUBSTANCENAME FROM Mst_MedNDC NDC 		INNER JOIN Mst_Medicine M ON NDC.Med_ID=M.Med_ID 		INNER JOIN Mst_Med_Strength S ON NDC.Strength_ID=S.ID 		WHERE @search = '' OR (M.Med_Name LIKE '%' + @search + '%' 		OR NDC.PRODUCTNDC LIKE '%' + @search + '%' 		OR NDC.NDC LIKE '%' + @search + '%') 	),  	OrderByResult AS (SELECT *, 			ROW_NUMBER() over ( 			order BY case when @orderBy = 'Med_Name' and @orderDir = 'asc' then Med_Name end, 								case when @orderBy = 'Med_Name' and @orderDir = 'desc' then Med_Name end desc 			) AS RowNumber FROM Result  	)  	SELECT *, (Select Count(Med_ID) FROM Result) TotalRows   	FROM OrderByResult  	WHERE 		OrderByResult.RowNumber BETWEEN (@pageIndex + 1) AND (@pageIndex  + @pageSize) END
