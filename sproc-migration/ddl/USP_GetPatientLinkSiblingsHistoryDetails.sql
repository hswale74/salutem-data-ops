-- EXEC USP_GetPatientLinkSiblingsHistoryDetails 2415, 0
create procedure dbo.usp_getpatientlinksiblingshistorydetails
    (@SocialHistoryID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                id,
                socialhistoryid,
                siblingsgenderid,
                siblingsage,
                siblingslifestatusid,
                siblingsrelationshipid,
                isdeleted,
                siblingname
            from trn_linksiblings
            where socialhistoryid = @SocialHistoryID and isdeleted = 0
        end
    else
        begin
            select
                id,
                socialhistoryid,
                siblingsgenderid,
                siblingsage,
                siblingslifestatusid,
                siblingsrelationshipid,
                isdeleted,
                siblingname
            from trn_linksiblingslog
            where patientactivityid = @PatientActivityID and isdeleted = 0
        end
end
