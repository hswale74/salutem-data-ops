create procedure dbo.usp_getinpatientlogdetail (@Patient_ID int) as begin
    select
        p.patient_id,
        p.patient_mbi,
        p.account_id,
        p.account_name,
        p.patient_first_name,
        p.patient_middle_name,
        p.patient_last_name,
        p.patient_mrn,
        p.patient_dob,
        p.patient_ssn,
        p.patient_race,
        p.patient_gender,
        p.patient_languageid,
        ml.language_description,
        p.patient_low_income,
        p.patient_can_contact,
        p.patient_status,
        p.patient_notes,
        p.patient_createdat,
        p.patient_createdby,
        p.patient_updatedat,
        p.patient_updatedby,
        p.patient_contact_id,
        p.patient_contact_name,
        p.patient_relation_id,
        p.patient_contact_phone,
        p.patient_contact_email,
        p.patient_contact_add1,
        p.patient_contact_add2,
        p.patient_contact_add3,
        p.patient_contact_city,
        p.patient_contact_county,
        p.patient_contact_state,
        p.zipcode,
        ipl.inpatientlogid,
        ipl.enrollmentstatus as patient_enrollment_status,
        ipl.enrollmentdate,
        ipl.unitnumber,
        ipl.roomnumber,
        ipl.admissiondate,
        ipl.estimateddischargedate,
        ipl.daysinpatient,
        ipl.isreferral,
        p.cmrcompleted,
        p.cmroutcome,
        p.macscore,
        p.madscore,
        p.mahscore,
        p.supdscore,
        p.homevisittype
    from view_mst_patient as p
    left join mst_language as ml on p.patient_languageid = ml.language_id
    left join
        trn_inpatientlog as ipl
        on
            p.patient_id = ipl.patient_id
            and p.inpatientlogid = ipl.inpatientlogid
    where p.patient_id = @Patient_ID
end
