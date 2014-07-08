<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_login()
  Dim tmpstr: tmpstr = ireplace("module.login", "tpl")
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  jtbc_cms_module_login = tmpstr
End Function

Function jtbc_cms_module_premise()
  Dim tmpstr: tmpstr = ireplace("module.premise", "tpl")
  jtbc_cms_module_premise = tmpstr
End Function

Function jtbc_cms_module_register()
  Dim tmpstr: tmpstr = ireplace("module.register", "tpl")
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  jtbc_cms_module_register = tmpstr
End Function

Function jtbc_cms_module_member()
  Dim tmpstr: tmpstr = itake("module.member", "tpl")
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  Dim tmpi, tmpfields, tmpfieldsvalue
  If Not rs.EOF Then
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
  End If
  Set rs = Nothing
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_member = tmpstr
End Function

Function jtbc_cms_module_member_information()
  Dim tmpstr: tmpstr = itake("module.member_information", "tpl")
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  Dim tmpi, tmpfields, tmpfieldsvalue
  If Not rs.EOF Then
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
  End If
  Set rs = Nothing
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_member_information = tmpstr
End Function

Function jtbc_cms_module_member_password()
  Dim tmpstr: tmpstr = ireplace("module.member_password", "tpl")
  jtbc_cms_module_member_password = tmpstr
End Function

Function jtbc_cms_module_member_userset()
  Dim tmpstr: tmpstr = itake("module.member_userset", "tpl")
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  Dim tmpi, tmpfields, tmpfieldsvalue
  If Not rs.EOF Then
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
  End If
  Set rs = Nothing
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_member_userset = tmpstr
End Function

Function jtbc_cms_module_user_detail()
  Dim tusername: tusername = get_safecode(request.querystring("username"))
  Dim tmpstr: tmpstr = itake("module.user_detail", "tpl")
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & tusername & "'"
  rs.open sqlstr, conn, 1, 3
  Dim tmpi, tmpfields, tmpfieldsvalue
  If Not rs.EOF Then
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpstr = Replace(tmpstr, "{$" & Replace(tmpfields, nfpre, "") & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
    tmpstr = creplace(tmpstr)
    jtbc_cms_module_user_detail = tmpstr
  Else
    Call imessage(itake("global.lng_public.not_exist", "lng"), -1)
  End If
  Set rs = Nothing
End Function

Function jtbc_cms_module_lostpassword()
  Dim tmpstr: tmpstr = ireplace("module.lostpassword", "tpl")
  jtbc_cms_module_lostpassword = tmpstr
End Function

Function jtbc_cms_module_manage()
  Select Case request.querystring("mtype")
    Case "member"
      jtbc_cms_module_manage = jtbc_cms_module_member
    Case "information"
      jtbc_cms_module_manage = jtbc_cms_module_member_information
    Case "password"
      jtbc_cms_module_manage = jtbc_cms_module_member_password
    Case "userset"
      jtbc_cms_module_manage = jtbc_cms_module_member_userset
    Case Else
      jtbc_cms_module_manage = jtbc_cms_module_member
  End Select
End Function

Function jtbc_cms_module()
  Select Case get_ctype(request.querystring("type"), ECtype)
    Case "login"
      jtbc_cms_module = jtbc_cms_module_login
    Case "register"
      Call check_passport_isregister_close
      jtbc_cms_module = jtbc_cms_module_register
    Case "manage"
      Call isuserlogin("0")
      jtbc_cms_module = jtbc_cms_module_manage
    Case "user_detail"
      jtbc_cms_module = jtbc_cms_module_user_detail
    Case "lostpassword"
      Call check_passport_islostpassword_close
      jtbc_cms_module = jtbc_cms_module_lostpassword
    Case Else
      jtbc_cms_module = jtbc_cms_module_premise
  End Select
End Function

Sub jtbc_cms_module_logindisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tbackurl) Then tbackurl = get_actual_route("./")
  Call check_valcode(tbackurl)
  Dim tuname, tpword, tautologin
  tuname = get_safecode(request.Form("username"))
  tpword = get_safecode(request.Form("password"))
  tpword = md5(tpword, "2")
  tautologin = get_num(request.Form("autologin"), 0)
  If check_uname(tuname, tpword) Then
    response.cookies(appname & "user")("uname") = tuname
    response.cookies(appname & "user")("pword") = tpword
    If tautologin = 1 Then response.cookies(appname & "user").expires = Date + 365
    session(appname & "uname") = tuname
    response.redirect tbackurl
  Else
    Call imessage(itake("global.lng_error.login", "lng"), tbackurl)
  End If
End Sub

Sub jtbc_cms_module_logoutdisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If check_null(tbackurl) Then tbackurl = get_actual_route("./")
  response.cookies(appname & "user")("uname") = ""
  response.cookies(appname & "user")("pword") = ""
  session(appname & "uname") = ""
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_registerdisp()
  ECtype = "register"
  If Not ck_valcode() Then ErrStr = ErrStr & itake("global.lng_error.valcode", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "username:" & itake("config.username", "lng") & ",password:" & itake("config.password", "lng") & ",email:" & itake("config.email", "lng") & ",city:" & itake("config.city", "lng") & ",sex:" & itake("config.sex", "lng") & ",old:" & itake("config.old", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  Dim reg_limit, ritem
  reg_limit = "&,',<,>,#,+,-,/,*,@,$,%,^," & Chr(32) & "," & Chr(9) & ",;"
  reg_limit = Split(reg_limit, ",")
  For Each ritem In reg_limit
    If InStr(get_str(request.Form("username")), ritem) > 0 Then
      ErrStr = ErrStr & itake("module.insert_limit", "lng") & spa
      Exit For
    End If
  Next
  Dim reguname: reguname = get_safecode(get_str(request.Form("username")))
  If strlength(reguname) < 2 Or strlength(reguname) > 16 Then ErrStr = ErrStr & itake("module.insert_length", "lng") & spa
  If get_str(request.Form("password")) <> get_str(request.Form("cpassword")) Then ErrStr = ErrStr & itake("module.insert_checkout", "lng") & spa
  If Not isvalidemail(get_str(request.Form("email"))) Then ErrStr = ErrStr & itake("module.insert_email", "lng") & spa
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & reguname & "'"
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    ErrStr = ErrStr & itake("module.insert_exist", "lng") & spa
  Else
    If check_null(ErrStr) Then
      rs.addnew
      rs(cfname("username")) = reguname
      rs(cfname("password")) = md5(request.Form("password"), "2")
      rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
      rs(cfname("city")) = Left_intercept(get_str(request.Form("city")), 50)
      rs(cfname("sex")) = get_num(request.Form("sex"), 0)
      rs(cfname("old")) = get_num(request.Form("old"), 0)
      rs(cfname("name")) = left_intercept(get_str(request.Form("name")), 50)
      rs(cfname("qq")) = get_num(request.Form("qq"), 0)
      rs(cfname("msn")) = left_intercept(get_str(request.Form("msn")), 50)
      rs(cfname("phone")) = left_intercept(get_str(request.Form("phone")), 50)
      rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 50)
      rs(cfname("code")) = get_num(request.Form("code"), 0)
      rs(cfname("address")) = left_intercept(get_str(request.Form("address")), 50)
      rs(cfname("time")) = Now()
      rs(cfname("lasttime")) = Now()
      rs(cfname("pretime")) = Now()
      rs.Update
      response.cookies(appname & "user")("uname") = reguname
      response.cookies(appname & "user")("pword") = md5(request.Form("password"), "2")
      session(appname & "uname") = reguname
      response.redirect get_actual_route("./")
    End If
  End If
End Sub

Sub jtbc_cms_module_member_informationdisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    rs(cfname("email")) = left_intercept(get_str(request.Form("email")), 50)
    rs(cfname("city")) = left_intercept(get_str(request.Form("city")), 50)
    rs(cfname("sex")) = get_num(request.Form("sex"), 0)
    rs(cfname("old")) = get_num(request.Form("old"), 0)
    rs(cfname("name")) = left_intercept(get_str(request.Form("name")), 50)
    rs(cfname("qq")) = get_num(request.Form("qq"), 0)
    rs(cfname("msn")) = left_intercept(get_str(request.Form("msn")), 50)
    rs(cfname("phone")) = left_intercept(get_str(request.Form("phone")), 50)
    rs(cfname("homepage")) = left_intercept(get_str(request.Form("homepage")), 50)
    rs(cfname("code")) = get_num(request.Form("code"), 0)
    rs(cfname("address")) = left_intercept(get_str(request.Form("address")), 50)
    rs.Update
    Call imessage(itake("global.lng_public.edit_succeed", "lng"), tbackurl)
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), tbackurl)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_module_member_passworddisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tpassword, tnpassword, tncpassword
  tpassword = md5(request.form("password"), "2")
  tnpassword = md5(request.form("npassword"), "2")
  tncpassword = md5(request.form("ncpassword"), "2")
  If not tnpassword = tncpassword Then Call imessage(itake("module.insert_checkout", "lng"), tbackurl)
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    If Not rs(cfname("password")) = tpassword Then Call imessage(itake("module.insert_password", "lng"), tbackurl)
    rs(cfname("password")) = tnpassword
    rs.Update
    response.cookies(appname & "user")("pword") = tnpassword
    Call imessage(itake("global.lng_public.edit_succeed", "lng"), tbackurl)
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), tbackurl)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_module_member_usersetdisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & cfname("username") & "='" & nusername & "'"
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Dim tface_width, tface_height
    tface_width = get_num(request.Form("face_width"), 0)
    tface_height = get_num(request.Form("face_height"), 0)
    If tface_width > face_width_max Then tface_width = face_width_max
    If tface_height > face_height_max Then tface_height = face_height_max
    rs(cfname("face")) = get_num(request.Form("face"), 0)
    rs(cfname("face_u")) = get_num(request.Form("face_u"), 0)
    rs(cfname("face_url")) = left_intercept(get_str(request.Form("face_url")), 255)
    rs(cfname("face_width")) = tface_width
    rs(cfname("face_height")) = tface_height
    rs(cfname("sign")) = left_intercept(get_str(request.Form("sign")), 100)
    rs.Update
    Call imessage(itake("global.lng_public.edit_succeed", "lng"), tbackurl)
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), tbackurl)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_module_managedisp()
  Select Case request.querystring("mtype")
    Case "information"
      Call jtbc_cms_module_member_informationdisp
    Case "password"
      Call jtbc_cms_module_member_passworddisp
    Case "userset"
      Call jtbc_cms_module_member_usersetdisp
  End Select
End Sub

Sub jtbc_cms_module_lostpassworddisp()
  Dim tusername, temail, tname
  tusername = get_safecode(request.form("username"))
  temail = get_safecode(request.form("email"))
  tname = get_safecode(request.form("name"))
  sqlstr = "select top 1 * from " & ndatabase & " where " & cfname("username") & "='" & tusername & "' and " & cfname("email") & "='" & temail & "' and " & cfname("name") & "='" & tname & "'"
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    Dim ttopic, tbody, tpassword, tmd5password
    tpassword = get_rndcode(8)
    tmd5password = md5(tpassword, "2")
    ttopic = itake("module.lostpassword_topic", "lng")
    ttopic = replace(ttopic, "[]", "[" & web_title("") & "]")
    tbody = itake("module.lostpassword_body", "lng")
    tbody = replace(tbody, "[name]", htmlencode(tname))
    tbody = replace(tbody, "[username]", htmlencode(tusername))
    tbody = replace(tbody, "[password]", tpassword)
    If email_send(temail, ttopic, tbody, "") Then
      rs(cfname("password")) = tmd5password
      rs.update
      Call imessage(itake("module.lostpassword_emailok", "lng"), "0")
    Else
      Call imessage(itake("module.lostpassword_emailerror", "lng"), "0")
    End If
  Else
    Call imessage(itake("module.lostpassword_infoerror", "lng"), -1)
  End If
  Set rs = Nothing
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "login"
      Call jtbc_cms_module_logindisp
    Case "logout"
      Call jtbc_cms_module_logoutdisp
    Case "register"
      Call check_passport_isregister_close
      Call jtbc_cms_module_registerdisp
    Case "manage"
      Call isuserlogin("0")
      Call jtbc_cms_module_managedisp
    Case "lostpassword"
      Call check_passport_islostpassword_close
      Call jtbc_cms_module_lostpassworddisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
