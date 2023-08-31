-- exec USP_GetAssessmentEnumByType 'ConsentToProgramReason'
Create Procedure dbo.usp_getassessmentenumbytype (@Type varchar(250)) As Begin
    Select
        id,
        enumtype,
        sequencenumber,
        discription,
        enumvalue,
        hasreason,
        hasothertext,
        othertextlable
    From mstassessmentenum Where enumtype = @Type Order By sequencenumber
End
