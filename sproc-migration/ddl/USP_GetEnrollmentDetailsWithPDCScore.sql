Create Procedure dbo.usp_getenrollmentdetailswithpdcscore
    (
        @AccountID INT,
        @fromDate DATETIME,
        @toDate DATETIME,
        @status INT,
        @EnrollmentYear INT,
        @orderBy NVARCHAR(50) = 'PatientFullName',
        @orderDir VARCHAR(4) = 'asc',
        @StartFrom INT = 0,
        @PageSize INT = 999999999
    )
As Begin Set Nocount On; With enrollmentdetailswithpdcscoreresult As (
    Select
        p.patient_id,
        p.patient_mrn,
        p.patient_last_name,
        p.patient_first_name,
        pe.patient_enroll_id,
        pe.patient_enrollment_status,
        me.discription As enrollstatusname,
        pe.enrollmentdate As actualenrollment,
        p.patient_dob,
        p.madscore,
        p.mahscore,
        p.macscore,
        p.patient_languageid,
        fhv.firsthomevisiton,
        pe.createdon As uploadeddate,
        p.refillduedate,
        p.patient_last_name + ' ' + p.patient_first_name As patientfullname
    From dbo.mst_patient As p
    Inner Join
        dbo.trn_patient_enrollment As pe
        On
            p.patient_id = pe.patient_id
            And (
                pe.uploadedyear = @EnrollmentYear
                Or YEAR(pe.enrollmentdate) = @EnrollmentYear
            )
            And p.account_id = @AccountID
    Inner Join
        dbo.mst_enum As me
        On
            pe.patient_enrollment_status = me.enumvalue
            And me.enumtype = 'EnrollmentStatus'
    Left Join
        dbo.view_firsthomevisitdetails As fhv
        On
            p.patient_id = fhv.patient_id
            And YEAR(fhv.firsthomevisiton) = YEAR(pe.enrollmentdate)
    Where
        p.patient_status = 1
        And (@status = 99 Or pe.patient_enrollment_status = @status)
        And pe.createdon >= @fromDate
        And pe.createdon <= @toDate
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
                    @orderBy = 'EnrollStatusName' And @orderDir = 'asc'
                    Then enrollstatusname
            End,
            Case
                When
                    @orderBy = 'EnrollStatusName' And @orderDir = 'desc'
                    Then enrollstatusname
            End Desc,
            Case
                When
                    @orderBy = 'UploadedDate' And @orderDir = 'asc'
                    Then uploadeddate
            End,
            Case
                When
                    @orderBy = 'UploadedDate' And @orderDir = 'desc'
                    Then uploadeddate
            End Desc,
            Case
                When
                    @orderBy = 'ActualEnrollment' And @orderDir = 'asc'
                    Then actualenrollment
            End,
            Case
                When
                    @orderBy = 'ActualEnrollment' And @orderDir = 'desc'
                    Then actualenrollment
            End Desc
    ) As rownumber
From enrollmentdetailswithpdcscoreresult)

Select
    *,
    (Select Count(patient_id) From enrollmentdetailswithpdcscoreresult
    ) As totalrows
From orderbyresult Where orderbyresult.rownumber Between (@StartFrom + 1) And (@StartFrom + @pageSize) End  -- EXEC dbo.USP_GetEnrollmentDetailsWithPDCScore 5, '01Feb2020','31July2021',0,2021,'PatientFullName','asc',0,10 -- sp_recompile '[dbo].USP_GetEnrollmentDetailsWithPDCScore'
