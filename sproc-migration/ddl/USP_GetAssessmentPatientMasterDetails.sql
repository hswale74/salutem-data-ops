-- EXEC USP_GetAssessmentPatientMasterDetails 19275
create procedure dbo.usp_getassessmentpatientmasterdetails
    (@Patient_ID int)
as begin
    select
        p.patient_id,
        p.account_id,
        p.patient_first_name,
        p.patient_middle_name,
        p.patient_last_name,
        p.patient_dob,
        p.mobile,
        p.email,
        mp.practicename,
        mphy.physicianname as referringphysicianname,
        p.preferredname,
        p.currentlocation,
        p.currentlocationaddress,
        p.assessmentid,
        p.patientstatusdate,
        p.patientstatusid,
        p.patientstatusothertext,
        p.patientstatusreasonid,
        p.patientstatusreasonoptionid,
        p.patientstatusreasonoptionothertext,
        p.mhinsuranceid,
        p.mhinsurancename,
        p.primaryguardianname,
        p.patient_gender,
        p.genderidentity,
        p.preferredpronouns
    from mst_patient as p
    left join mst_practice as mp on p.patientpracticeid = mp.id
    left join mst_physician as mphy on p.referringproviderid = mphy.id
    where p.patient_id = @Patient_ID
end
