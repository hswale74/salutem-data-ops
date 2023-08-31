-- EXEC USP_GetPatientAdditionalAllergiesDetails 1255, 2
create procedure dbo.usp_getpatientadditionalallergiesdetails
    (@PatientID int, @AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                tpaa.id,
                tpaa.allergyid,
                ma.allerg_name,
                tpaa.isdeleted,
                coalesce(tpaa.patientid, @PatientID, 0) as patientid,
                coalesce(tpaa.assessmentid, @AssessmentID, 0) as assessmentid
            from trnpatientassessmentallergies as tpaa
            inner join mst_allergies as ma on tpaa.allergyid = ma.allergy_id
            where
                tpaa.patientid = @PatientID
                and tpaa.assessmentid = @AssessmentID
                and tpaa.isdeleted = 0
        end
    else begin
        select
            tpaa.id,
            tpaa.allergyid,
            ma.allerg_name,
            tpaa.isdeleted,
            coalesce(tpaa.patientid, @PatientID, 0) as patientid,
            coalesce(tpaa.assessmentid, @AssessmentID, 0) as assessmentid
        from trnpatientassessmentallergieslog as tpaa
        inner join mst_allergies as ma on tpaa.allergyid = ma.allergy_id
        where
            tpaa.patientid = @PatientID
            and tpaa.assessmentid = @AssessmentID
            and tpaa.isdeleted = 0
            and tpaa.patientactivityid = @PatientActivityID
    end
end
