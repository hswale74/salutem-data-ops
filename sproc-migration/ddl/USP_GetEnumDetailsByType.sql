-- exec USP_GetEnumDetailsByType 'Salutation'
Create Procedure dbo.usp_getenumdetailsbytype (@Type varchar(250)) As Begin
    Select
        id,
        enumtype,
        enumvalue,
        enumname,
        discription
    From mst_enum Where enumtype = @Type
End
