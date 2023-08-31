-- EXEC USP_GetPatientCurrentPsychotropicMedicationsDetails 19290, 1007,4145
create procedure dbo.usp_getpatientcurrentpsychotropicmedicationsdetails
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
                ppm.currentmedicationcomment,
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
                and ppm.iscurrentmedicine = 1
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
            ppm.currentmedicationcomment,
            mms.med_strength,
            ppm.isdeleted,
            ppm.patientactivityid
        from trn_pastpsychotropicmedicationslog as ppm
        inner join mst_medicine as mm on ppm.med_id = mm.med_id
        left join mst_med_strength as mms on ppm.med_strength_id = mms.id
        where
            ppm.patientid = @PatientID
            and ppm.assessmentid = @AssessmentID
            and ppm.isdeleted = 0
            and ppm.iscurrentmedicine = 1
            and ppm.patientactivityid = @PatientActivityID
    end
end
