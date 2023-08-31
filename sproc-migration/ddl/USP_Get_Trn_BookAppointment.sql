create procedure USP_GET_TRN_BOOKAPPOINTMENT (@AppointmentId int = 0) as begin
    select
        TRN.APPOINTMENTID,
        TRN.DESCRIPTION,
        TRN.STARTDATE,
        TRN.STARTDATE,
        TRN.ENDTIME
    from TRN_BOOKAPPOINTMENT as TRN where TRN.APPOINTMENTID = @AppointmentId
end
