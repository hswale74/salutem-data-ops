--EXEC USP_GetMstBillingCodes 1,55
CREATE PROCEDURE dbo.usp_getmstbillingcodes
    (@IsFirstMonthService BIT, @Duration INT)
AS BEGIN
    SELECT
        id,
        isfirstmonthservice,
        activitytype,
        cptcode,
        cptfirstaddon,
        cptsecondaddon,
        startduration,
        endduration,
        hasonlyonesession,
        hasruralhealthpatient,
        insurancetype,
        dxcode
    FROM mstbillingcodes
    WHERE
        isfirstmonthservice = @IsFirstMonthService
        AND @Duration >= startduration
        AND @Duration <= endduration
END
