Create Procedure dbo.usp_mst_region_search
    (@SearchText nvarchar(Max))
As Begin Select
    id,
    regionname,
    businessunit,
    department,
    locationcode,
    account
From mst_region Where regionname Like @SearchText + '%' End
