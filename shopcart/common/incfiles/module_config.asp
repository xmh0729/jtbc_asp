<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_list()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tcontinue: tcontinue = get_actual_route(nmerchandise)
  If not check_null(tbackurl) Then tcontinue = htmlencode(tbackurl)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(nmerchandise, "0")
  tidfield = cnidfield(nmerchandise, "0")
  tfpre = cnfpre(nmerchandise, "0")
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim titem, trs, tsqlstr
  Dim tid, tnum, tprice, twprice, tmerchandiseprice
  tmerchandiseprice = 0
  For each titem in request.cookies(ngenre)
    tid = get_num(titem, 0)
    If not tid = 0 Then
      tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "hidden") & "=0 and " & tidfield & "=" & tid
      Set trs = conn.Execute(tsqlstr)
      If trs.eof Then Exit For
      tnum = get_num(request.cookies(ngenre)(titem), 0)
      tprice = FormatNumber(get_num(trs(cfnames(tfpre, "price")), 0), 2)
      twprice = FormatNumber(get_num(trs(cfnames(tfpre, "wprice")), 0), 2)
      tmerchandiseprice = tmerchandiseprice + (twprice * tnum)
      tmptstr = Replace(tmpastr, "{$id}", tid)
      tmptstr = Replace(tmptstr, "{$num}", tnum)
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(trs(cfnames(tfpre, "topic")))))
      tmptstr = Replace(tmptstr, "{$price}", tprice)
      tmptstr = Replace(tmptstr, "{$wprice}", twprice)
      If get_num(trs(cfnames(tfpre, "limit")), 0) = 1 Then
        tmptstr = replace(tmptstr, "{$limitnum}", get_num(trs(cfnames(tfpre, "limitnum")), 0))
      Else
        tmptstr = replace(tmptstr, "{$limitnum}", -1)
      End If
      tmptstr = Replace(tmptstr, "{$limitnum}", get_num(trs(cfnames(tfpre, "limitnum")), 0))
      tmprstr = tmprstr & tmptstr
      Set trs = nothing
    End If
  Next
  tmpstr = Replace(tmpstr, "{$merchandiseprice}", FormatNumber(tmerchandiseprice, 2))
  tmpstr = Replace(tmpstr, "{$continue}", tcontinue)
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_list = tmpstr
End Function

Function jtbc_cms_module_succeed()
  Dim torderid: torderid = get_num(request.querystring("orderid"), 0)
  Dim trs, tsqlstr
  tsqlstr = "select * from " & ndatabase & " where " & cfname("orderid") & "='" & torderid & "'"
  Set trs = conn.Execute(tsqlstr)
  If not trs.eof Then
    Dim tmpstr
    tmpstr = itake("module.succeed", "tpl")
    tmpstr = replace(tmpstr, "{$orderid}", torderid)
    tmpstr = creplace(tmpstr)
    jtbc_cms_module_succeed = tmpstr
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), "./?type=list")
  End If
  Set trs = nothing
End Function

Function jtbc_cms_module
  Select Case request.querystring("type")
    Case "list"
      jtbc_cms_module = jtbc_cms_module_list
    Case "succeed"
      jtbc_cms_module = jtbc_cms_module_succeed
    Case Else
      jtbc_cms_module = jtbc_cms_module_list
  End Select
End Function

Sub jtbc_cms_module_adddisp()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tbuynum: tbuynum = get_num(request.form("buynum"), 1)
  If tbuynum < 1 Then tbuynum = 1
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If Not tid = 0 Then
    response.cookies(ngenre)(CStr(tid)) = CStr(tbuynum)
  End If
  response.redirect "./?type=list&backurl=" & urlencode(tbackurl)
End Sub

Sub jtbc_cms_module_editdisp()
  Dim tmpstr: tmpstr = format_checkbox(request.form("sel_id"))
  If Not cidary(tmpstr) Then Exit Sub
  Dim tary: tary = split(tmpstr, ",")
  Dim icount, tnum
  response.cookies(ngenre) = ""
  For icount = 0 to ubound(tary)
    tnum = clng(get_num(request.form("num_" & tary(icount)), 0))
    If not tnum = 0 Then response.cookies(ngenre)(CStr(tary(icount))) = CStr(tnum)
  Next
  response.redirect "./?type=list"
End Sub

Sub jtbc_cms_module_deletedisp()
  response.cookies(ngenre) = ""
  response.redirect "./?type=list"
End Sub

Sub jtbc_cms_module_addbuydisp()
  Dim tid, titem, titems, tsqlary
  Dim tdatabase, tidfield, tfpre
  Dim tis: tis = 0
  tdatabase = cndatabase(nmerchandise, "0")
  tidfield = cnidfield(nmerchandise, "0")
  tfpre = cnfpre(nmerchandise, "0")
  ReDim tsqlary(request.cookies(ngenre).count)
  For each titem in request.cookies(ngenre)
    tid = get_num(request.cookies(ngenre)(titem), 0)
    If not tid = 0 Then
      titems = titems & titem & ":" & tid & ","
      sqlstr = "select * from " & tdatabase & " where " & tidfield & "=" & get_num(titem, 0)
      Set rs = conn.Execute(sqlstr)
      If Not rs.EOF Then
        If get_num(rs(cfnames(tfpre, "limit")), 0) = 1 Then
          If get_num(rs(cfnames(tfpre, "limitnum")), 0) < tid Then
            Call imessage(replace(itake("module.addbuyerror1", "lng"), "[]", "[" & get_str(rs(cfnames(tfpre, "topic"))) & "]"), "./?type=list")
          End If
          tsqlary(tis) = "update " & tdatabase & " set " & cfnames(tfpre, "limitnum") & "=" & cfnames(tfpre, "limitnum") & "-" & tid & " where " & tidfield & "=" & get_num(titem, 0)
        End If
      Else
        Call imessage(itake("module.addbuyerror2", "lng"), "./?type=list")
      End If
      Set rs = Nothing
    End If
    tis = tis + 1
  Next
  For tis = 0 to UBound(tsqlary)
    If not check_null(tsqlary(tis)) Then conn.Execute(tsqlary(tis))
  Next
  If not check_null(titems) Then
    titems = get_lrstr(titems, ",", "leftr")
    Dim ttraffic, tmerchandiseprice, ttrafficprice
    ttraffic = get_num(request.form("traffic"), 0)
    tmerchandiseprice = get_num(request.form("merchandiseprice"), 0)
    ttrafficprice = itake("sel_traffic_fare." & ttraffic, "sel")
    Dim trs, tsqlstr, torderid
    tsqlstr = "select * from " & ndatabase
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstr, conn, 1, 3
    trs.addnew
    trs(cfname("fid")) = titems
    trs(cfname("merchandiseprice")) = tmerchandiseprice
    trs(cfname("trafficprice")) = ttrafficprice
    trs(cfname("allprice")) = tmerchandiseprice + ttrafficprice
    trs(cfname("name")) = left_intercept(get_str(request.form("name")), 50)
    trs(cfname("address")) = left_intercept(get_str(request.form("address")), 200)
    trs(cfname("phone")) = left_intercept(get_str(request.form("phone")), 50)
    trs(cfname("code")) = left_intercept(get_str(request.form("code")), 50)
    trs(cfname("email")) = left_intercept(get_str(request.form("email")), 50)
    trs(cfname("remark")) = left_intercept(get_str(request.form("remark")), 100000)
    trs(cfname("payment")) = get_num(request.form("payment"), 0)
    trs(cfname("traffic")) = get_num(request.form("traffic"), 0)
    trs(cfname("time")) = now()
    trs(cfname("dtime")) = now()
    trs.update
    tid = trs(nidfield)
    If get_num(tid, 0) = 0 Then tid = get_topid(ndatabase, nidfield)
    torderid = format_date(now(), 100) & (tid mod 10)
    Set trs = nothing
    tsqlstr = "update " & ndatabase & " set " & cfname("orderid") & "='" & torderid & "' where " & nidfield & "=" & tid
    If run_sqlstr(tsqlstr) Then
      response.redirect "./?type=succeed&orderid=" & torderid
    Else
      Call imessage(itake("global.lng_public.sudd", "lng"), "./?type=list")
    End If
  Else
    Call imessage(itake("module.payerror", "lng"), "./?type=list")
  End If
End Sub

Sub jtbc_cms_module_action
  Select Case request.querystring("action")
    Case "add"
      Call jtbc_cms_module_adddisp
    Case "edit"
      Call jtbc_cms_module_editdisp
    Case "delete"
      Call jtbc_cms_module_deletedisp
    Case "addbuy"
      Call jtbc_cms_module_addbuydisp
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
