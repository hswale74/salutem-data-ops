--EXEC USP_GetAllInsurance
create procedure USP_GETALLINSURANCE as begin
    select
        MI.ID,
        MI.INSURANCE,
        MI.ISDELETED,
        MI.CREATEDON,
        MI.CREATEDBY,
        MI.UPDATEDON,
        MI.UPDATEDBY,
        MI.INSURANCETYPE,
        ME.ENUMNAME as INSURANCETYPENAME,
        MI.STATEID,
        ST.STATENAME
    from MST_INSURANCE as MI
    left join
        MST_ENUM as ME
        on MI.INSURANCETYPE = ME.ENUMVALUE and ME.ENUMTYPE = 'InsuranceType'
    left join MST_STATE as ST on MI.STATEID = ST.ID
end
