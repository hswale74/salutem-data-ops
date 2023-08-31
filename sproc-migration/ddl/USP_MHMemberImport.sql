Create Procedure USP_MHMEMBERIMPORT
    (@importTable MHMemberTableType Readonly)
As Begin
    Insert Into DBO.MHMEMBERTABLE Select * From @importTable Select @@ROWCOUNT
End
