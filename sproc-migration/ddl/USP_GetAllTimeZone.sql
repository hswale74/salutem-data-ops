Create Procedure dbo.usp_getalltimezone As Begin
    Select
        id,
        country,
        countrycode,
        description,
        utc + ' ' + timezone As timezonewithutc
    From mst_timezone
End
