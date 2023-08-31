create procedure dbo.usp_getpatientassessmentdetailsforprogressnote
    (@Patient_ID int, @PatientActivityID int = 0)
as begin
    select
        pa.assessmentid,
        pa.patientid,
        pa.consenttoprogram,
        pa.consenttoprogramreason,
        pa.consenttoprogramotherreason,
        pa.hasfollowupscheduled,
        pa.followupdate,
        pa.followuptime,
        pa.followupclinicianid,
        pa.followupnotext,
        pa.followuptype,
        pa.otherfollowuptype,
        pa.cliniciansname,
        pa.encountertitle,
        pa.encounterdate,
        pa.encounterstarttime,
        pa.encounterendtime,
        pa.hpipresentingconcerns,
        pa.sessionsummary,
        pa.grouptopic,
        pa.patientcontributionssession,
        pa.notetitle,
        pa.explanationofnote,
        pa.nextsteps,
        pa.notetype,
        pa.notetypeothertext,
        pa.attendance,
        pa.attendanceoption,
        pa.attendanceoptionreason
    from trnpatientassessmentlog as pa
    left join
        mstassessmentenum as mae
        on
            pa.consenttoprogramreason = mae.enumvalue
            and mae.enumtype = 'ConsentToProgramReason'
    where
        pa.patientid = @Patient_ID and pa.patientactivityid = @PatientActivityID
end
