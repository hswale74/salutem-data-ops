Create Procedure USP_DRGLISTIMPORT
    (@importTable DRGTableTypes Readonly)
As Begin
    Insert Into DBO.DRGTEMPTABLE Select
        DRGCODE,
        DRGTITLE,
        MDC,
        EN.ENUMVALUE As TYPE,
        WEIGHTS,
        GEOMETRICMEANLOS,
        ARITHMETICMEANLOS
    From @importTable As IMT
    Left Join
        MST_ENUM As EN
        On IMT.TYPE = EN.DISCRIPTION And EN.ENUMTYPE = 'DRGType'
    Select @@ROWCOUNT
End
