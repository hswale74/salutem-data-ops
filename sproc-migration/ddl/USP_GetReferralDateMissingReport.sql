Create Procedure dbo.usp_getreferraldatemissingreport
    (
        @AccountID INT,
        @search NVARCHAR(50) = '',
        @orderBy NVARCHAR(50) = 'PatientFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
As Begin With result As (
    Select
        patient.patient_id,
        patient.account_id,
        patient.patient_first_name,
        patient.patient_last_name,
        patient.patient_dob,
        patient.mobile,
        patient.patient_status,
        patient.patient_mrn,
        patient_gender,
        patient.patientstatusid,
        mps.statusname As dispalypatientstatus,
        mp.practicename,
        patient.patient_first_name
        + ' '
        + patient.patient_last_name As patientfullname
    From dbo.mst_patient As patient
    Inner Join mst_practice As mp On patient.patientpracticeid = mp.id
    Left Join mstpatientstatuses As mps On patient.patientstatusid = mps.id
    Where
        patient.patient_status = 1
        And patient.account_id = @AccountID
        And patient.referraldate Is Null
        And (
            (
                patient.patient_first_name + ' ' + patient.patient_last_name
            ) Like '%'
            + @search
            + '%'
            Or (
                patient.patient_last_name + ' ' + patient.patient_first_name
            ) Like '%'
            + @search
            + '%'
            Or mp.practicename Like '%' + @search + '%'
            Or patient.patient_mrn Like '%' + @search + '%'
            Or patient.mobile Like '%' + @search + '%'
            Or mps.statusname Like '%' + @search + '%'
        )
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
            End Desc
    ) As rownumber
From result)

Select
    *,
    (Select Count(patient_id) From result) As totalrows
From orderbyresult Where orderbyresult.rownumber Between (@StartFrom + 1) And (@StartFrom + @pageSize); End  -- EXEC USP_GetReferralDateMissingReport 22,'01Oct2022','19Oct2022' -- EXEC sp_recompile N'dbo.USP_GetReferralDateMissingReport';    select * from Mst_Patient 
