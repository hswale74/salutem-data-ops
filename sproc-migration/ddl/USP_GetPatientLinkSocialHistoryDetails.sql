-- EXEC USP_GetPatientLinkSocialHistoryDetails 34,3133
create procedure dbo.usp_getpatientlinksocialhistorydetails
    (@SocialHistoryID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                id,
                socialhistoryid,
                assessmentenumid,
                otherdetails,
                isdeleted
            from trn_linksocialhistory
            where socialhistoryid = @SocialHistoryID and isdeleted = 0
        end
    else
        begin
            select
                id,
                socialhistoryid,
                assessmentenumid,
                otherdetails,
                isdeleted
            from trn_linksocialhistorylog
            where patientactivityid = @PatientActivityID and isdeleted = 0
        end
end
