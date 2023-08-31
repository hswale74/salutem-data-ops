--EXEC USP_MstInsuranceSearch 0, '', 1
Create Procedure dbo.usp_mstinsurancesearch
    (@ID INT = 0, @SearchText NVARCHAR(Max) = '', @IsIncludeDeleted INT = 0)
As Begin
    Select
        i.id,
        i.insurance As insurancename,
        i.insurancetype,
        e.enumname As insurancetypename,
        i.insurance + ' - ' + st.statename As insurance,
        Isnull(st.id, 0) As stateid,
        Isnull(st.statename, '') As statename
    From mst_insurance As i
    Left Join
        mst_enum As e
        On
            ISNULL(i.insurancetype, 0) = e.enumvalue
            And e.enumtype = 'InsuranceType'
    Left Join mst_state As st On i.stateid = st.id
    Where
        (@IsIncludeDeleted = 1 Or isdeleted = 0)
        And (@ID = 0 Or i.id = @ID)
        And insurance Like @SearchText + '%'
End
