-- EXEC USP_GetPatientLinkChildernDetails 2415, 0
create procedure dbo.usp_getpatientlinkchildrendetails
    (@SocialHistoryID int, @PatientActivityID int = 0)
as begin
    if @PatientActivityID = 0
        begin
            select
                id,
                socialhistoryid,
                childname,
                noofchildern,
                childrengenderid,
                childrenage,
                isdeleted
            from trn_linkchildren
            where socialhistoryid = @SocialHistoryID and isdeleted = 0
        end
    else
        begin
            select
                id,
                socialhistoryid,
                childname,
                noofchildern,
                childrengenderid,
                childrenage,
                isdeleted
            from trn_linkchildrenlog
            where patientactivityid = @PatientActivityID and isdeleted = 0
        end
end
