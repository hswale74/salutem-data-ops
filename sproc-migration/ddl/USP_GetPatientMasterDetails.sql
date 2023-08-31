-- EXEC USP_GetPatientMasterDetails 19278
create procedure dbo.usp_getpatientmasterdetails (@Patient_ID int) as begin
    select
        patient_id,
        account_id,
        patient_first_name,
        patient_middle_name,
        patient_last_name,
        patient_mrn,
        patient_dob,
        patient_gender,
        patient_status,
        patient_createdat,
        patient_createdby,
        patient_updatedat,
        patient_updatedby,
        patientpracticeid,
        referringproviderid,
        surveryscore,
        typeofreferral,
        reasonforreferral,
        areyoueligible,
        issud,
        isexport,
        isflagthispatient,
        salutation,
        noteligiblereason,
        noteligiblereasonnote,
        preferredname,
        currentlocation,
        currentlocationaddress,
        patientstatusid,
        patientstatusreasonid,
        patientstatusothertext,
        patientstatusdate,
        ps.statusname as dispalypatientstatus,
        tpa.programtype,
        mae.discription as dispalyprogramtype,
        p.assessmentid,
        p.patient_race,
        p.referraldate,
        p.mobile,
        p.email,
        p.preferredpronouns,
        p.assignedbcm,
        p.assignedbcmid,
        p.genderidentity,
        p.flagcomment,
        salutation
        + ' '
        + patient_first_name
        + ' '
        + patient_last_name as patientfullname
    from dbo.mst_patient as p
    left join mstpatientstatuses as ps on p.patientstatusid = ps.statusid
    left join
        trnpatientassessment as tpa
        on p.patient_id = tpa.patientid and p.assessmentid = tpa.assessmentid
    left join
        mstassessmentenum as mae
        on tpa.programtype = mae.enumvalue and mae.enumtype = 'ProgramTypes'
    where p.patient_id = @Patient_ID
end
