<%
call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
npagesize = get_num(get_value(ngenre & ".npagesize"), 0)
ndatabase = get_str(get_value(ngenre & ".ndatabase"))
nidfield = get_str(get_value(ngenre & ".nidfield"))
nfpre = get_str(get_value(ngenre & ".nfpre"))
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
Dim face_width_max: face_width_max = get_num(get_value(ngenre & ".face_width_max"), 0)
Dim face_height_max: face_height_max = get_num(get_value(ngenre & ".face_height_max"), 0)

Function check_passport_register_close()
  If get_num(get_value(ngenre & ".register_close"), 0) = 1 Then
    check_passport_register_close = true
  Else
    check_passport_register_close = false
  End If
End Function

Function check_passport_lostpassword_close()
  If get_num(get_value(ngenre & ".lostpassword_close"), 0) = 1 Then
    check_passport_lostpassword_close = true
  Else
    check_passport_lostpassword_close = false
  End If
End Function

Sub check_passport_isregister_close()
  If check_passport_register_close Then Call imessage(itake("module.register_close", "lng"), -1)
End Sub

Sub check_passport_islostpassword_close()
  If check_passport_lostpassword_close Then Call imessage(itake("module.lostpassword_close", "lng"), -1)
End Sub
%>
