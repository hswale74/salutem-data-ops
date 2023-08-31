Create Procedure dbo.usp_getdeletedactivitiesreport
    (
        @AccountID INT,
        @fromDate DATETIME,
        @toDate DATETIME,
        @orderBy NVARCHAR(50) = 'PatientFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
As Begin Select @toDate = dateadd(Dd, 1, @toDate); With result As (
    Select
        p.patientfullname,
        tpa.activity_start_time,
        ma.activity_name,
        activityoutcomename,
        tpa.activity_updatedat,
        ma.activity_id,
        tpa.patient_id,
        Coalesce(
            tpa.activity_actual_end_time,
            tpa.activity_actual_start_time,
            tpa.activity_start_date
        ) As activity_start_date,
        mu.user_first_name
        + ' '
        + mu.user_last_name As activity_assigned_to_name,
        Coalesce(tpa.activity_start_status, 1) As activity_start_status,
        dmu.user_first_name + ' ' + dmu.user_last_name As activity_deleted_by
    From dbo.trn_patient_activity As tpa With (Nolock)
    Inner Join
        dbo.mst_activity As ma With (Nolock)
        On tpa.activity_id = ma.activity_id
    Inner Join
        dbo.view_mst_patient As p With (Nolock)
        On tpa.patient_id = p.patient_id And p.account_id = @AccountId
    Left Join
        dbo.mst_user As mu With (Nolock)
        On tpa.activity_assigned_to = mu.user_id
    Left Join
        dbo.mst_user As dmu With (Nolock)
        On tpa.activity_updatedby = dmu.user_id
    Where
        p.patient_status = 1
        And tpa.activity_status = 0
        And tpa.activity_updatedat >= @fromDate
        And tpa.activity_updatedat <= @toDate
),

orderbyresult As (Select
    *,
    Row_number() Over (
        Order By
            Case
                When
                    @orderBy = 'PatientFullName' And @orderDir = 'asc'
                    Then patientfullname
            End,
            Case
                When
                    @orderBy = 'PatientFullName' And @orderDir = 'desc'
                    Then patientfullname
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Start_Date' And @orderDir = 'asc'
                    Then activity_start_date
            End,
            Case
                When
                    @orderBy = 'Activity_Start_Date' And @orderDir = 'desc'
                    Then activity_start_date
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Name' And @orderDir = 'asc'
                    Then activity_name
            End,
            Case
                When
                    @orderBy = 'Activity_Name' And @orderDir = 'desc'
                    Then activity_name
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Assigned_To_Name' And @orderDir = 'asc'
                    Then activity_assigned_to_name
            End,
            Case
                When
                    @orderBy = 'Activity_Assigned_To_Name'
                    And @orderDir = 'desc'
                    Then activity_assigned_to_name
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Start_Status_Name'
                    And @orderDir = 'asc'
                    Then activity_start_status
            End,
            Case
                When
                    @orderBy = 'Activity_Start_Status_Name'
                    And @orderDir = 'desc'
                    Then activity_start_status
            End Desc,
            Case
                When
                    @orderBy = 'ActivityOutcomeName' And @orderDir = 'asc'
                    Then activityoutcomename
            End,
            Case
                When
                    @orderBy = 'ActivityOutcomeName' And @orderDir = 'desc'
                    Then activityoutcomename
            End Desc,
            Case
                When
                    @orderBy = 'Activity_UpdatedAt' And @orderDir = 'asc'
                    Then activity_updatedat
            End,
            Case
                When
                    @orderBy = 'Activity_UpdatedAt' And @orderDir = 'desc'
                    Then activity_updatedat
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Deleted_By' And @orderDir = 'desc'
                    Then activity_deleted_by
            End Desc,
            Case
                When
                    @orderBy = 'Activity_Deleted_By' And @orderDir = 'desc'
                    Then activity_deleted_by
            End Desc
    ) As rownumber
From result)

Select
    *,
    (Select count(activity_id) From result) As totalrows
From orderbyresult Where orderbyresult.rownumber Between (@StartFrom + 1) And (@StartFrom + @pageSize); End  -- EXEC USP_GetDeletedActivitiesReport 22,'01Oct2022','19Oct2022' -- EXEC sp_recompile N'dbo.USP_GetDeletedActivitiesReport';   
