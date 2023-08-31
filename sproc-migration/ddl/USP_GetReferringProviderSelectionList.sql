-- EXEC USP_GetReferringProviderSelectionList 1,19275
create procedure dbo.usp_getreferringproviderselectionlist
    (@PracticeID INT, @PatientID INT = 0)
as begin
    select
        ph.id,
        physicianname
    from mst_physician as ph
    inner join
        trn_practicephysicians as pp
        on ph.id = pp.physicianid and pp.isdeleted = 0 and ph.isdeleted = 0
    where pp.practiceid = @PracticeID
    union
    select
        ph.id,
        physicianname
    from mst_physician as ph
    inner join
        mst_patient as p
        on ph.id = p.referringproviderid and p.patient_id = @PatientID
end
