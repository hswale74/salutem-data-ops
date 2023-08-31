-- EXEC USP_GetPatientBehavioralHealthHistoryDetails 1255, 2
create procedure dbo.usp_getpatientbehavioralhealthhistorydetails
    (@PatientID int, @AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                bhl.id as mstbhid,
                bhl.behavioralname,
                bhl.behavioraltypeid,
                bhh.yeardiagnosed,
                bhh.treatmentplace,
                bhh.treatmentdate,
                bhh.isdeleted,
                ISNULL(bhh.id, 0) as id,
                coalesce(bhh.patientid, @PatientID, 0) as patientid,
                coalesce(bhh.assessmentid, @AssessmentID, 0) as assessmentid,
                ISNULL(bhh.behavioralhealthid, 0) as behavioralhealthid
            from mstbehavioralhealthlist as bhl
            left join
                trn_behavioralhealthhistory as bhh
                on
                    bhl.id = bhh.behavioralhealthid
                    and bhh.patientid = @PatientID
                    and bhh.assessmentid = @AssessmentID
        end
    else begin
        select
            bhl.id as mstbhid,
            bhl.behavioralname,
            bhl.behavioraltypeid,
            bhh.yeardiagnosed,
            bhh.treatmentplace,
            bhh.treatmentdate,
            bhh.isdeleted,
            ISNULL(bhh.id, 0) as id,
            coalesce(bhh.patientid, @PatientID, 0) as patientid,
            coalesce(bhh.assessmentid, @AssessmentID, 0) as assessmentid,
            ISNULL(bhh.behavioralhealthid, 0) as behavioralhealthid
        from mstbehavioralhealthlist as bhl
        left join
            trn_behavioralhealthhistorylog as bhh
            on
                bhl.id = bhh.behavioralhealthid
                and bhh.patientid = @PatientID
                and bhh.assessmentid = @AssessmentID
                and bhh.patientactivityid = @PatientActivityID
    end
end
