create procedure dbo.usp_getpatientassessmentdetails
    (@Patient_ID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                pa.assessmentid,
                pa.patientid,
                pa.consenttoprogram,
                pa.consenttoprogramreason,
                mae.discription as dispalyconsenttoprogramreason,
                pa.consenttoprogramotherreason,
                pa.hpipresentingconcerns,
                pa.smhcurrentconditions,
                pa.smhcurrentconditionsothertext,
                pa.smhhasallergies,
                pa.smhcurrentpainscale,
                pa.smhcurrentpainscaleothertext,
                pa.smhhasassistivedevices,
                pa.smhallergiesothertext,
                pa.smhassistivedevicesothertext,
                pa.hascurrentpsychotropicmedication,
                pa.hasotherpsychotropicmedication,
                pa.otherpsychotropicmedicationcomment,
                pa.planenumvalue,
                pa.otherplan,
                pa.declinesplanenumvalue,
                pa.declinesplanother,
                pa.plancomment,
                pa.sessionsummary,
                pa.patientgoals,
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
                pa.programtype,
                pa.grouptopic,
                pa.patientcontributionssession,
                pa.notetitle,
                pa.explanationofnote,
                pa.nextsteps,
                pa.reasonforpsychconsult,
                pa.casestatus,
                pa.casepriority,
                pa.psychconsultnotesummary,
                pa.psychconsultrecommendations,
                pa.psychconsultrationale,
                pa.notetype,
                pa.notetypeothertext,
                pa.guardianconsenttoprogram,
                pa.attendance,
                pa.attendanceoption,
                pa.attendanceoptionreason
            from trnpatientassessment as pa
            inner join
                mst_patient as p
                on
                    pa.patientid = p.patient_id
                    and pa.assessmentid = p.assessmentid
            left join
                mstassessmentenum as mae
                on
                    pa.consenttoprogramreason = mae.enumvalue
                    and mae.enumtype = 'ConsentToProgramReason'
            where pa.patientid = @Patient_ID
        end
    else begin
        select
            pa.assessmentid,
            pa.patientid,
            pa.consenttoprogram,
            pa.consenttoprogramreason,
            mae.discription as dispalyconsenttoprogramreason,
            pa.consenttoprogramotherreason,
            pa.hpipresentingconcerns,
            pa.smhcurrentconditions,
            pa.smhcurrentconditionsothertext,
            pa.smhhasallergies,
            pa.smhcurrentpainscale,
            pa.smhcurrentpainscaleothertext,
            pa.smhhasassistivedevices,
            pa.smhallergiesothertext,
            pa.smhassistivedevicesothertext,
            pa.hascurrentpsychotropicmedication,
            pa.hasotherpsychotropicmedication,
            pa.otherpsychotropicmedicationcomment,
            pa.planenumvalue,
            pa.otherplan,
            pa.declinesplanenumvalue,
            pa.declinesplanother,
            pa.plancomment,
            pa.sessionsummary,
            pa.patientgoals,
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
            pa.programtype,
            pa.grouptopic,
            pa.patientcontributionssession,
            pa.notetitle,
            pa.explanationofnote,
            pa.nextsteps,
            pa.reasonforpsychconsult,
            pa.casestatus,
            pa.casepriority,
            pa.psychconsultnotesummary,
            pa.psychconsultrecommendations,
            pa.psychconsultrationale,
            pa.notetype,
            pa.notetypeothertext,
            pa.guardianconsenttoprogram,
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
            pa.patientid = @Patient_ID
            and pa.patientactivityid = @PatientActivityID
    end
end
