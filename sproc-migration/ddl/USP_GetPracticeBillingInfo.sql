--exec USP_GetPracticeBillingInfo 0
CREATE PROCEDURE dbo.usp_getpracticebillinginfo
    (@PracticeID int, @BillingCode varchar(200) = '')
AS BEGIN
    SELECT
        mb.id AS billingcodeid,
        mb.billingcode,
        tp.id,
        tp.practiceid,
        COALESCE(tp.fees, mb.fees) AS fees
    FROM mstbillingcodefees AS mb
    LEFT JOIN
        trnpracticebillingfeesinfo AS tp
        ON mb.id = tp.billingcodeid AND tp.practiceid = @PracticeID
    WHERE
        (mb.billingcode LIKE '%' + @BillingCode + '%' OR @BillingCode = '')
END
