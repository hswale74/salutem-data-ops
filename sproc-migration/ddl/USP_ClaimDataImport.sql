Create Procedure USP_CLAIMDATAIMPORT
    (@importClaimDataTable ClaimImportTableType Readonly)
As Begin
    Insert Into SALUTEM_TEMP.DBO.CLAIM_IMPORT
    Select *
    From @importClaimDataTable
    Select @@ROWCOUNT
End
