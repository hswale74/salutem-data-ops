--EXEC USP_GetPatientNotes 15708
Create Procedure dbo.usp_getpatientnotes (@PatientId INT) As Begin
    Select
        n.patient_note_id,
        n.patient_id,
        n.patient_note_description,
        n.patient_note_createdby,
        n.patient_note_createdat As createdat,
        n.patient_note_updatedat As updatedat,
        u.user_first_name + ' ' + u.user_last_name As createdby,
        us.user_first_name + ' ' + us.user_last_name As updatedby
    From trn_patient_notes As n
    Inner Join mst_user As u On n.patient_note_createdby = u.user_id
    Left Join mst_user As us On n.patient_note_updatedby = us.user_id
    Where n.patient_id = @PatientId
    Order By n.patient_note_id Desc
End
