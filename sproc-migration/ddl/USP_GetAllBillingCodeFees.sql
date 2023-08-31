Create Procedure USP_GETALLBILLINGCODEFEES As Begin
    Set Nocount On Begin Select
        ID,
        BILLINGCODE,
        FEES
    From MSTBILLINGCODEFEES End
End
