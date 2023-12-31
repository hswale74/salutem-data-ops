--Exec USP_Trn_Patient_Contact 16489
Create Procedure USP_TRN_PATIENT_CONTACT (@PatientId INT) As Begin Select
    TPC.PATIENT_CONTACT_ID,
    TPC.PATIENT_ID,
    TPC.PATIENT_CONTACT_TYPE,
    TPC.PATIENT_CONTACT_NAME,
    TPC.PATIENT_RELATION_ID,
    TPC.PATIENT_CONTACT_PHONE,
    TPC.PATIENT_CONTACT_EMAIL,
    TPC.PATIENT_CONTACT_ADD1,
    TPC.PATIENT_CONTACT_ADD2,
    TPC.PATIENT_CONTACT_ADD3,
    TPC.PATIENT_CONTACT_CITY,
    TPC.PATIENT_CONTACT_COUNTY,
    TPC.PATIENT_CONTACT_STATE,
    TPC.PATIENT_CONTACT_STATUS,
    TPC.PATIENT_CONTACT_CREATEDAT,
    TPC.PATIENT_CONTACT_CREATEDBY,
    TPC.PATIENT_CONTACT_UPDATEDAT,
    TPC.PATIENT_CONTACT_UPDATEDBY,
    TPC.ISPRIMARY,
    TPC.ZIPCODE,
    TPC.ISTEXTAVAILABLE,
    TPC.ADDRESSTYPEID,
    TPC.ISMOBILEPREFERENCE,
    TPC.ISEMAILPREFERENCE,
    TPC.ISSMSPREFERENCE,
    TPC.CONSENTTOVOICEMAIL,
    TPC.CONSENTTOTEXT
From TRN_PATIENT_CONTACT As TPC Where TPC.PATIENT_ID = @PatientId End
