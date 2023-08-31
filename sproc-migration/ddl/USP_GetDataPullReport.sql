--EXEC USP_GetDataPullReport 0,999999
Create Procedure USP_GETDATAPULLREPORT
    (@StartFrom int = 0, @PageSize int = 999999999)
As Begin
    With MASTERPATIENT As (
        Select
            PP.PATIENT_ID,
            PATIENT_MRN,
            I.ADMISSIONDATE,
            I.DISCHARGEDATE,
            I.ISREFERRAL,
            I.FINNUMBER,
            PATIENT_FIRST_NAME + ' ' + PATIENT_LAST_NAME As PATIENTNAME
        From MST_PATIENT As PP
        Inner Join SALUTEM_TEMP.DBO.MEMBERMRN As MM On PP.PATIENT_MRN = MM.MRN
        Inner Join
            TRN_INPATIENTLOG As I
            On PP.PATIENT_ID = I.PATIENT_ID And MM.FIN = I.FINNUMBER
    ),

PATIENTCONTACT As (
        Select
            P.PATIENT_ID,
            P.PATIENT_MRN,
            P.PATIENTNAME,
            PATIENT_CONTACT_ADD1,
            PATIENT_CONTACT_ADD2,
            PATIENT_CONTACT_STATE,
            PATIENT_CONTACT_EMAIL,
            P.ADMISSIONDATE,
            P.DISCHARGEDATE,
            P.ISREFERRAL,
            P.FINNUMBER
        From MASTERPATIENT As P
        Left Join
            TRN_PATIENT_CONTACT As C
            On P.PATIENT_ID = C.PATIENT_ID And C.ISPRIMARY = 0
    ),

PATIENTPRIMARYCONTACT As (
        Select
            P.PATIENT_ID,
            C.ZIPCODE
        From MASTERPATIENT As P
        Left Join
            TRN_PATIENT_CONTACT As C
            On P.PATIENT_ID = C.PATIENT_ID And C.ISPRIMARY = 1
    ),

PATIENTCONTACTRESULT As (
        Select Distinct
            PATIENT_MRN,
            PATIENTNAME As PATIENT_NAME,
            FINNUMBER As FIN,
            PATIENT_CONTACT_STATE,
            PATIENT_CONTACT_EMAIL,
            ZIPCODE,
            ADMISSIONDATE,
            DISCHARGEDATE,
            ISREFERRAL,
            Coalesce(PATIENT_CONTACT_ADD1, '')
            + ' '
            + Coalesce(PATIENT_CONTACT_ADD2, '') As CONTACT_ADDRESS_2
        From PATIENTCONTACT As PC
        Inner Join
            PATIENTPRIMARYCONTACT As PPC
            On PC.PATIENT_ID = PPC.PATIENT_ID
    ),

ORDERBYRESULT As (Select
        *,
        Row_number() Over (Order By PATIENT_NAME) As ROWNUMBER
    From PATIENTCONTACTRESULT)

    Select
        *,
        (Select Count(PATIENT_NAME) From PATIENTCONTACTRESULT) As TOTALROWS
    From ORDERBYRESULT
    Where ROWNUMBER Between (@StartFrom + 1) And (@StartFrom + @pageSize)
End
