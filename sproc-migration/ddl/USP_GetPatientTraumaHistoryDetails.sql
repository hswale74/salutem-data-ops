-- EXEC USP_GetPatientTraumaHistoryDetails 2415, 0, 0
create procedure dbo.usp_getpatienttraumahistorydetails
    (@PatientID int, @AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                thl.id as mstthid,
                thl.traumaname,
                thl.traumahistorytypeid,
                tth.id as myid,
                tth.childhoodtraumacomment,
                tth.adulthoodtraumacomment,
                tth.ralationshiptopatient,
                tth.dateofdeath,
                tth.additionalcomment,
                tth.othertraumacomments,
                ISNULL(tth.id, 0) as id,
                coalesce(tth.patientid, @PatientID, 0) as patientid,
                coalesce(tth.assessmentid, @AssessmentID, 0) as assessmentid,
                ISNULL(tth.traumahistoryid, 0) as traumahistoryid,
                coalesce(tth.isdeleted, 0) as isdeleted
            from msttramahistorylist as thl
            left join
                trn_traumahistory as tth
                on
                    thl.id = tth.traumahistoryid
                    and tth.patientid = @PatientID
                    and tth.assessmentid = @AssessmentID
        end
    else begin
        select
            thl.id as mstthid,
            thl.traumaname,
            thl.traumahistorytypeid,
            tth.id as myid,
            tth.childhoodtraumacomment,
            tth.adulthoodtraumacomment,
            tth.ralationshiptopatient,
            tth.dateofdeath,
            tth.additionalcomment,
            tth.othertraumacomments,
            ISNULL(tth.id, 0) as id,
            coalesce(tth.patientid, @PatientID, 0) as patientid,
            coalesce(tth.assessmentid, @AssessmentID, 0) as assessmentid,
            ISNULL(tth.traumahistoryid, 0) as traumahistoryid,
            coalesce(tth.isdeleted, 0) as isdeleted
        from msttramahistorylist as thl
        left join
            trn_traumahistorylog as tth
            on
                thl.id = tth.traumahistoryid
                and tth.patientid = @PatientID
                and tth.assessmentid = @AssessmentID
                and tth.patientactivityid = @PatientActivityID
    end
end
