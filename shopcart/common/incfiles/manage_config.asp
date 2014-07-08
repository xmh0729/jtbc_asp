<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const nsearch = "name,orderid,id"
ncontrol = "select,delete"

Function manage_navigation()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation", "tpl")
  manage_navigation = tmpstr
End Function

Function manage_navigation_status()
  Dim tmpstr
  tmpstr = ireplace("manage.navigation_status", "tpl")
  manage_navigation_status = tmpstr
End Function

Sub jtbc_cms_admin_manage_list()
  Dim classid, search_field, search_keyword
  classid = get_num(request.querystring("classid"), 0)
  search_field = get_safecode(request.querystring("field"))
  search_keyword = get_safecode(request.querystring("keyword"))
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("manage.list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary
  tmpary = get_xinfo_ary("sel_state.all", "sel")
  If IsArray(tmpary) Then
    Dim tmpi, thspan, tstr0, tstr1
    For tmpi = 0 To UBound(tmpary)
      tstr0 = tmpary(tmpi, 0)
      tstr1 = tmpary(tmpi, 1)
      If Not tstr0 = "" Then
        thspan = "state" & tstr0
        tmptstr = Replace(tmpastr, "{$topic}", tstr1)
        tmptstr = Replace(tmptstr, "{$ahref}", "?keyword=" & tstr0 & "&field=state&hspan=" & thspan)
        tmptstr = Replace(tmptstr, "{$hspan}", thspan)
      End If
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & ">0"
  If search_field = "name" Then sqlstr = sqlstr & " and " & cfname("name") & " like '%" & search_keyword & "%'"
  If search_field = "orderid" Then sqlstr = sqlstr & " and " & cfname("orderid") & " like '%" & search_keyword & "%'"
  If search_field = "state" Then sqlstr = sqlstr & " and " & cfname("state") & "=" & get_num(search_keyword, 0)
  If search_field = "prepaid" Then sqlstr = sqlstr & " and " & cfname("prepaid") & "=" & get_num(search_keyword, 0)
  If search_field = "id" Then sqlstr = sqlstr & " and " & nidfield & "=" & get_num(search_keyword, 0)
  sqlstr = sqlstr & " order by " & cfname("time") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmpname, font_red
  If Not check_null(search_keyword) And search_field = "name" Then font_red = itake("global.tpl_config.font_red", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmpname = htmlencode(get_str(rs(cfname("name"))))
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", search_keyword): tmpname = Replace(tmpname, search_keyword, font_red)
      tmptstr = Replace(tmpastr, "{$name}", tmpname)
      tmptstr = Replace(tmptstr, "{$namestr}", urlencode(get_str(rs(cfname("name")))))
      tmptstr = Replace(tmptstr, "{$orderid}", htmlencode(get_str(rs(cfname("orderid")))))
      tmptstr = Replace(tmptstr, "{$paystate}", itake("sel_paystate." & get_num(rs(cfname("prepaid")), 0), "sel"))
      tmptstr = Replace(tmptstr, "{$state}", itake("sel_state." & get_num(rs(cfname("state")), 0), "sel"))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = creplace(tmpstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_edit()
  Dim tid, tbackurl, tprolist
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If Not rs.EOF Then
    Dim tmpstr, tmpi, tmpfields, tmpfieldsvalue
    tmpstr = itake("manage.edit", "tpl")
    tprolist = rs(cfname("fid"))
    If Not check_null(tprolist) Then
      Dim tdatabase, tidfield, tfpre
      tdatabase = cndatabase(nmerchandise, "0")
      tidfield = cnidfield(nmerchandise, "0")
      tfpre = cnfpre(nmerchandise, "0")
      Dim tmpastr, tmprstr, tmptstr
      tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
      Dim ti, titem, trs, tsqlstr
      Dim ttid, tnum, tprice, twprice, tallprice
      tallprice = 0
      Dim titem0, titem1
      titem = Split(tprolist, ",")
      For ti = 0 To UBound(titem)
        If InStr(titem(ti), ":") = 0 Then Exit For
        titem0 = Split(titem(ti), ":")(0)
        titem1 = Split(titem(ti), ":")(1)
        ttid = get_num(titem0, 0)
        If Not ttid = 0 Then
          tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "hidden") & "=0 and " & tidfield & "=" & ttid
          Set trs = conn.Execute(tsqlstr)
          If trs.EOF Then Exit For
          tnum = get_num(titem1, 0)
          tprice = FormatNumber(get_num(trs(cfnames(tfpre, "price")), 0), 2)
          twprice = FormatNumber(get_num(trs(cfnames(tfpre, "wprice")), 0), 2)
          tallprice = tallprice + (twprice * tnum)
          tmptstr = Replace(tmpastr, "{$id}", ttid)
          tmptstr = Replace(tmptstr, "{$num}", tnum)
          tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(trs(cfnames(tfpre, "topic")))))
          tmptstr = Replace(tmptstr, "{$price}", tprice)
          tmptstr = Replace(tmptstr, "{$wprice}", twprice)
          tmprstr = tmprstr & tmptstr
          Set trs = Nothing
        End If
      Next
      tmpstr = Replace(tmpstr, "{$tallprice}", FormatNumber(tallprice, 2))
      tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    Else
      Call jtbc_cms_admin_msg(itake("global.lng_public.sudd", "lng"), tbackurl, 1)
    End If
    Dim tfieldscount: tfieldscount = rs.fields.Count - 1
    ReDim rsfields(tfieldscount, 1)
    For tmpi = 0 To tfieldscount
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpfields = get_lrstr(tmpfields, "_", "rightr")
      rsfields(tmpi, 0) = tmpfields
      rsfields(tmpi, 1) = tmpfieldsvalue
      tmpstr = Replace(tmpstr, "{$" & tmpfields & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$id}", get_str(rs(nidfield)))
    tmpstr = creplace(tmpstr)
    response.write tmpstr
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 0)
  End If
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_status()
  Dim search_state: search_state = get_safecode(request.querystring("state"))
  Dim search_keyword: search_keyword = get_safecode(request.querystring("keyword"))
  Dim tstatus: tstatus = get_safecode(request.querystring("status"))
  Dim tunit
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = ireplace("manage.status", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Dim tmpary
  tmpary = get_xinfo_ary("sel_state.all", "sel")
  If IsArray(tmpary) Then
    Dim tmpi, thspan, tstr0, tstr1
    For tmpi = 0 To UBound(tmpary)
      tstr0 = tmpary(tmpi, 0)
      tstr1 = tmpary(tmpi, 1)
      If Not tstr0 = "" Then
        thspan = "state" & tstr0
        tmptstr = Replace(tmpastr, "{$topic}", tstr1)
        tmptstr = Replace(tmptstr, "{$ahref}", "?type=status&status=" & tstatus & "&keyword=" & urlencode(search_keyword) & "&state=" & tstr0 & "&hspan=" & thspan)
        tmptstr = Replace(tmptstr, "{$hspan}", thspan)
      End If
      tmprstr = tmprstr & tmptstr
    Next
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  Dim ti, tary(11)
  For ti = 0 To 11
    Select Case tstatus
      Case "money"
        sqlstr = "select sum(" & cfname("allprice") & ") from " & ndatabase & " where month(" & cfname("time") & ")=" & ti + 1
        tunit = itake("global.lng_unit.money","lng")
      Case Else
        sqlstr = "select count(" & nidfield & ") from " & ndatabase & " where month(" & cfname("time") & ")=" & ti + 1
        tunit = itake("global.lng_unit.ge","lng")
    End Select
    If Not check_null(search_keyword) Then sqlstr = sqlstr & " and year(" & cfname("time") & ")=" & get_num(search_keyword, 0)
    If Not check_null(search_state) Then sqlstr = sqlstr & " and " & cfname("state") & "=" & get_num(search_state, 0)
    Set rs = conn.Execute(sqlstr)
    tary(ti) = get_num(rs(0), 0)
    Set rs = Nothing
  Next
  Dim tmax: tmax = get_arymax(tary)
  Dim tcolor, ttotalize
  For ti = 0 To UBound(tary)
    tcolor = "#00FF00"
    ttotalize = ttotalize + tary(ti)
    If tary(ti) = tmax Then tcolor = "#FF0000"
    tmptstr = Replace(tmpastr, "{$month}", ti + 1)
    tmptstr = Replace(tmptstr, "{$sum}", tary(ti))
    tmptstr = Replace(tmptstr, "{$color}", tcolor)
    tmptstr = Replace(tmptstr, "{$width}", cper(tary(ti), tmax))
    tmprstr = tmprstr & tmptstr
  Next
  If Not check_null(search_keyword) Then
    tmpstr = Replace(tmpstr, "{$year}", "(" & get_num(search_keyword, 0) & ")")
  Else
    tmpstr = Replace(tmpstr, "{$year}", "")
  End If
  tmpstr = Replace(tmpstr, "{$totalize}", ttotalize)
  tmpstr = Replace(tmpstr, "{$status}", tstatus)
  tmpstr = Replace(tmpstr, "{$unit}", tunit)
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage_editdisp()
  Dim tid, tbackurl
  tid = get_num(request.querystring("id"), 0)
  tbackurl = get_safecode(request.querystring("backurl"))
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Dim tstates, tstate, ttraffic, ttrafficprice
    tstates = rs(cfname("state"))
    tstate = get_num(request.Form("state"), 0)
    ttraffic = get_num(request.form("traffic"), 0)
    ttrafficprice = itake("sel_traffic_fare." & ttraffic, "sel")
    rs(cfname("payment")) = get_num(request.Form("payment"), 0)
    rs(cfname("traffic")) = ttraffic
    rs(cfname("trafficprice")) = ttrafficprice
    rs(cfname("allprice")) = rs(cfname("merchandiseprice")) + ttrafficprice
    rs(cfname("state")) = tstate
    rs(cfname("prepaid")) = get_num(request.Form("prepaid"), 0)
    rs(cfname("dtime")) = Now()
    rs.Update
    If tstates <> -1 and tstate = -1 Then
      Dim tprolist: tprolist = get_str(rs(cfname("fid")))
      If Not check_null(tprolist) Then
        Dim trs, tsqlstr
        Dim tdatabase, tidfield, tfpre
        tdatabase = cndatabase(nmerchandise, "0")
        tidfield = cnidfield(nmerchandise, "0")
        tfpre = cnfpre(nmerchandise, "0")
        Dim ti, titem, titem0, titem1, ttid
        titem = Split(tprolist, ",")
        Set trs = server.CreateObject("adodb.recordset")
        For ti = 0 To UBound(titem)
          If InStr(titem(ti), ":") = 0 Then Exit For
          titem0 = Split(titem(ti), ":")(0)
          titem1 = Split(titem(ti), ":")(1)
          ttid = get_num(titem0, 0)
          If Not ttid = 0 Then
            tsqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "hidden") & "=0 and " & tidfield & "=" & ttid
            trs.open tsqlstr, conn, 1, 3
            If not trs.EOF Then
              trs(cfnames(tfpre, "limitnum")) = trs(cfnames(tfpre, "limitnum")) + get_num(titem1, 0)
              trs.update
              trs.close
            End If
          End If
        Next
        Set trs = Nothing
      End If
    End If
    Call jtbc_cms_admin_msg(itake("global.lng_public.edit_succeed", "lng"), tbackurl, 1)
  Else
    Call jtbc_cms_admin_msg(itake("global.lng_public.not_exist", "lng"), tbackurl, 1)
  End If
  rs.Close
  Set rs = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "edit"
      Call jtbc_cms_admin_manage_editdisp
    Case "delete"
      Call jtbc_cms_admin_deletedisp
    Case "control"
      Call jtbc_cms_admin_controldisp
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "edit"
      Call jtbc_cms_admin_manage_edit
    Case "status"
      Call jtbc_cms_admin_manage_status
    Case Else
      Call jtbc_cms_admin_manage_list
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
