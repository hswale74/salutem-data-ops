CREATE PROCEDURE USP_GETPATIENTSDETAILS_HOSPITAL (@Patient_ID int) AS BEGIN
    SELECT
        P.PATIENT_ID,
        P.ACCOUNT_ID,
        P.ACCOUNT_NAME,
        P.PATIENT_MRN,
        P.PATIENT_FIRST_NAME,
        P.PATIENT_MIDDLE_NAME,
        P.PATIENT_LAST_NAME,
        P.PATIENT_DOB,
        P.PATIENT_CONTACT_ID,
        P.PATIENT_CONTACT_NAME,
        P.PATIENT_RELATION_ID,
        P.PATIENT_CONTACT_PHONE,
        P.PATIENT_CONTACT_EMAIL,
        P.PATIENT_CONTACT_ADD1,
        P.PATIENT_CONTACT_ADD2,
        P.PATIENT_CONTACT_ADD3,
        P.PATIENT_CONTACT_CITY,
        P.PATIENT_CONTACT_COUNTY,
        P.PATIENT_CONTACT_STATE,
        P.ZIPCODE,
        P.INPATIENTLOGID,
        P.EPISODEID,
        P.HOMEVISITTYPE
    FROM VIEW_MST_PATIENT AS P WHERE P.PATIENT_ID = @Patient_ID
END
