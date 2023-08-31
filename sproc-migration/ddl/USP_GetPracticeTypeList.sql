Create Procedure dbo.usp_getpracticetypelist
    (
        @search nvarchar(50) = '',
        @orderBy nvarchar(50) = 'ID',
        @orderDir varchar(4) = 'asc',
        @pageIndex int = 0,
        @pageSize int = 99999
    )
As Begin
    Set Nocount On; With result As (
        Select
            p.id,
            p.practicetype,
            p.isdeleted
        From dbo.mst_practicetype As p With (Nolock)
        Where (p.practicetype Like '%' + @search + '%')
    ),

orderbyresult As (Select
        *,
        Row_number() Over (
            Order By
                Case
                    When
                        @orderBy = 'PracticeType' And @orderDir = 'asc'
                        Then practicetype
                End,
                Case
                    When
                        @orderBy = 'PracticeType' And @orderDir = 'desc'
                        Then practicetype
                End Desc
        ) As rownumber
    From result)

    Select
        *,
        (Select Count(id) From result) As totalrows
    From orderbyresult
    Where
        orderbyresult.rownumber Between (@pageIndex + 1) And (
            @pageIndex + @pageSize
        )
End
