-- EXEC USP_GetPatientDSMVDiagnosisDetails 0,0
create procedure dbo.usp_getpatientdsmvdiagnosisdetails
    (@PatientID int, @AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                dsmdiagnosisid,
                patientid,
                assessmentid,
                diagnosisid,
                md.icd10code,
                hasprimarydiagnosis,
                hassecondarydiagnosis,
                hasadditionaldiagnosis,
                dd.isdeleted,
                md.icd10code + ' ' + md.diagnosis_name as displaydiagnosisname
            from trn_dsmvdiagnosis as dd
            inner join mst_diagnosis as md on dd.diagnosisid = md.diagnosis_id
            where
                dd.patientid = @PatientID
                and dd.assessmentid = @AssessmentID
                and dd.isdeleted = 0
        end
    else begin
        select
            dsmdiagnosisid,
            patientid,
            assessmentid,
            diagnosisid,
            md.icd10code,
            hasprimarydiagnosis,
            hassecondarydiagnosis,
            hasadditionaldiagnosis,
            dd.isdeleted,
            md.icd10code + ' ' + md.diagnosis_name as displaydiagnosisname
        from trn_dsmvdiagnosislog as dd
        inner join
            mst_diagnosis as md
            on
                dd.diagnosisid = md.diagnosis_id
                and dd.patientactivityid = @PatientActivityID
        where dd.patientid = @PatientID and dd.isdeleted = 0
    end
end
