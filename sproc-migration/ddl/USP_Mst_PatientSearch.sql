--EXEC USP_Mst_PatientSearch 22, 'Cynthia Tuscano'
create procedure USP_MST_PATIENTSEARCH
    (@AccountId INT, @SearchText NVARCHAR(max))
as begin
    select
        PATIENT_ID,
        PATIENT_FIRST_NAME,
        PATIENT_MIDDLE_NAME,
        PATIENT_LAST_NAME,
        PATIENT_GENDER,
        MOBILE,
        coalesce(PATIENT_FIRST_NAME, '')
        + ' '
        + coalesce(PATIENT_MIDDLE_NAME, '')
        + ' '
        + coalesce(PATIENT_LAST_NAME, '') as PATIENTFULLNAME
    from MST_PATIENT
    where
        ACCOUNT_ID = @AccountId
        and (
            MOBILE like '%' + @SearchText + '%'
            or PATIENT_FIRST_NAME like '%' + @SearchText + '%'
            or PATIENT_LAST_NAME like '%' + @SearchText + '%'
            or (PATIENT_FIRST_NAME + ' ' + PATIENT_LAST_NAME) like '%'
            + @SearchText
            + '%'
        )
end
