-- EXEC USP_GetMasterPracticeSelectionList 19275
create procedure dbo.usp_getmasterpracticeselectionlist
    (@PatientID INT = 0, @LoggedInUserID INT = 0)
as begin
    select distinct
        mp.id,
        practicename
    from mst_practice as mp
    left join trnuserpractices as up on mp.id = up.practiceid
    where
        practicestatus = 1
        and (@LoggedInUserID = 0 or up.userid = @LoggedInUserID)
    union
    select
        id,
        practicename
    from mst_practice as pr
    inner join
        mst_patient as p
        on pr.id = p.patientpracticeid and p.patient_id = @PatientID
end
