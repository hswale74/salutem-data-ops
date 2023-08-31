-- EXEC USP_GetPatientPastPsychotropicMedicationsDetails 0,0
create procedure dbo.usp_getpatientpastpsychotropicmedicationsdetails
    (@PatientID int, @AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                pastpsychotropicid,
                patientid,
                assessmentid,
                behavioralhealthid,
                ppm.med_id,
                med_strength_id,
                frequency,
                mm.med_name,
                mms.med_strength,
                ppm.isdeleted
            from trn_pastpsychotropicmedications as ppm
            inner join mst_medicine as mm on ppm.med_id = mm.med_id
            left join
                mst_med_strength as mms
                on ppm.med_strength_id = mms.id
            where
                ppm.patientid = @PatientID
                and ppm.assessmentid = @AssessmentID
                and ppm.isdeleted = 0
                and ppm.iscurrentmedicine = 0
        end
    else begin
        select
            pastpsychotropicid,
            patientid,
            assessmentid,
            behavioralhealthid,
            ppm.med_id,
            med_strength_id,
            frequency,
            mm.med_name,
            mms.med_strength,
            ppm.isdeleted
        from trn_pastpsychotropicmedicationslog as ppm
        inner join mst_medicine as mm on ppm.med_id = mm.med_id
        left join mst_med_strength as mms on ppm.med_strength_id = mms.id
        where
            ppm.patientid = @PatientID
            and ppm.assessmentid = @AssessmentID
            and ppm.isdeleted = 0
            and ppm.iscurrentmedicine = 0
            and ppm.patientactivityid = @PatientActivityID
    end
end
