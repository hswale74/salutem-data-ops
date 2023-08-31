--- exec USP_GetSubstanceUseHistoryDetails 1025,'',3088 
create procedure dbo.usp_getsubstanceusehistorydetails
    (
        @AssessmentID int,
        @ClassInfo varchar(250) = '',
        @PatientActivityID int = 0
    )
as begin
    if @PatientActivityID = 0
        begin
            with distinctquestion as (
                select distinct
                    questiontext,
                    classinfo,
                    sequencenumber
                from dbo.mst_questions
                where
                    questionlinkid >= 601
                    and questionlinkid <= 674
                    and classinfo is not null
                    and (@ClassInfo = '' or classinfo = @ClassInfo)
            )

            select
                questiontext,
                q.classinfo,
                id,
                assessmentid,
                startedageusing,
                hasstoppedusing,
                stoppedusingage,
                iscurrentlyusing,
                frequency,
                quantity,
                route,
                isreceivedtreatmentforuse,
                isdetox,
                detoxcomment,
                isrehab,
                rehabcomment,
                isinpatient,
                inpatientcomment,
                isoutpatient,
                outpatientcomment,
                isstepprogram,
                stepprogramcomment,
                isother,
                othercomment
            from distinctquestion as q
            left join
                trnsubstanceusehistory as t
                on
                    q.classinfo = t.classinfo
                    and t.assessmentid = @AssessmentID
                    and t.isdeleted = 0
            order by sequencenumber
        end
    else begin
        with distinctquestion as (
            select distinct
                questiontext,
                classinfo,
                sequencenumber
            from dbo.mst_questions
            where
                questionlinkid >= 601
                and questionlinkid <= 674
                and classinfo is not null
                and (@ClassInfo = '' or classinfo = @ClassInfo)
        )

        select
            questiontext,
            q.classinfo,
            id,
            assessmentid,
            startedageusing,
            hasstoppedusing,
            stoppedusingage,
            iscurrentlyusing,
            frequency,
            quantity,
            route,
            isreceivedtreatmentforuse,
            isdetox,
            detoxcomment,
            isrehab,
            rehabcomment,
            isinpatient,
            inpatientcomment,
            isoutpatient,
            outpatientcomment,
            isstepprogram,
            stepprogramcomment,
            isother,
            othercomment
        from distinctquestion as q
        left join
            trnsubstanceusehistorylog as t
            on
                q.classinfo = t.classinfo
                and t.assessmentid = @AssessmentID
                and t.isdeleted = 0
                and t.patientactivityid = @PatientActivityID
        order by sequencenumber
    end
end
