create procedure dbo.usp_gettrnfamilyhistory
    (@AssessmentID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                fh.id,
                fh.assessmentid,
                fh.hasfamilypsychiatrichistory,
                fh.familypsychiatrichistorydetails,
                fh.hasfamilymedialhistory,
                fh.familymedialhistorydetails,
                fh.motherfamilypsychiatrichistorydetails,
                fh.fatherfamilypsychiatrichistorydetails,
                fh.siblingsfamilypsychiatrichistorydetails,
                fh.grandmothersfamilypsychiatrichistorydetails,
                fh.grandfathersfamilypsychiatrichistorydetails,
                fh.childrenfamilypsychiatrichistorydetails,
                fh.motherfamilymedialhistorydetails,
                fh.motherfamilymedialhistorymyocardialageevent,
                fh.motherfamilymedialhistorycerebrovascularageevent,
                fh.fatherfamilymedialhistorydetails,
                fh.fatherfamilymedialhistorymyocardialageevent,
                fh.fatherfamilymedialhistorycerebrovascularageevent,
                fh.siblingsfamilymedialhistorydetails,
                fh.siblingsfamilymedialhistorymyocardialageevent,
                fh.siblingsfamilymedialhistorycerebrovascularageevent,
                fh.grandmothersfamilymedialhistorydetails,
                fh.grandmothersfamilymedialhistorymyocardialageevent,
                fh.grandmothersfamilymedialhistorycerebrovascularageevent,
                fh.grandfathersfamilymedialhistorydetails,
                fh.grandfathersfamilymedialhistorymyocardialageevent,
                fh.grandfathersfamilymedialhistorycerebrovascularageevent,
                fh.childrenfamilymedialhistorydetails,
                fh.childrenfamilymedialhistorymyocardialageevent,
                fh.childrenfamilymedialhistorycerebrovascularageevent,
                fh.motherfamilymedialhistoryothertext,
                fh.fatherfamilymedialhistoryothertext,
                fh.siblingsfamilymedialhistoryothertext,
                fh.grandmothersfamilymedialhistoryothertext,
                fh.grandfathersfamilymedialhistoryothertext,
                fh.childrenfamilymedialhistoryothertext
            from dbo.trnfamilyhistory as fh
            where fh.assessmentid = @AssessmentID
        end
    else
        begin
            select
                fh.id,
                fh.assessmentid,
                fh.hasfamilypsychiatrichistory,
                fh.familypsychiatrichistorydetails,
                fh.hasfamilymedialhistory,
                fh.familymedialhistorydetails,
                fh.motherfamilypsychiatrichistorydetails,
                fh.fatherfamilypsychiatrichistorydetails,
                fh.siblingsfamilypsychiatrichistorydetails,
                fh.grandmothersfamilypsychiatrichistorydetails,
                fh.grandfathersfamilypsychiatrichistorydetails,
                fh.childrenfamilypsychiatrichistorydetails,
                fh.motherfamilymedialhistorydetails,
                fh.motherfamilymedialhistorymyocardialageevent,
                fh.motherfamilymedialhistorycerebrovascularageevent,
                fh.fatherfamilymedialhistorydetails,
                fh.fatherfamilymedialhistorymyocardialageevent,
                fh.fatherfamilymedialhistorycerebrovascularageevent,
                fh.siblingsfamilymedialhistorydetails,
                fh.siblingsfamilymedialhistorymyocardialageevent,
                fh.siblingsfamilymedialhistorycerebrovascularageevent,
                fh.grandmothersfamilymedialhistorydetails,
                fh.grandmothersfamilymedialhistorymyocardialageevent,
                fh.grandmothersfamilymedialhistorycerebrovascularageevent,
                fh.grandfathersfamilymedialhistorydetails,
                fh.grandfathersfamilymedialhistorymyocardialageevent,
                fh.grandfathersfamilymedialhistorycerebrovascularageevent,
                fh.childrenfamilymedialhistorydetails,
                fh.childrenfamilymedialhistorymyocardialageevent,
                fh.childrenfamilymedialhistorycerebrovascularageevent,
                fh.motherfamilymedialhistoryothertext,
                fh.fatherfamilymedialhistoryothertext,
                fh.siblingsfamilymedialhistoryothertext,
                fh.grandmothersfamilymedialhistoryothertext,
                fh.grandfathersfamilymedialhistoryothertext,
                fh.childrenfamilymedialhistoryothertext
            from dbo.trnfamilyhistorylog as fh
            where
                fh.assessmentid = @AssessmentID
                and fh.patientactivityid = @PatientActivityID
        end
end
