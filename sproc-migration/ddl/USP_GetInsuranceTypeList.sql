--EXEC USP_GetInsuranceTypeList
Create Procedure dbo.usp_getinsurancetypelist As Begin Select
    id,
    enumvalue,
    enumname,
    discription
From mst_enum Where enumtype = 'InsuranceType' Order By discription End
