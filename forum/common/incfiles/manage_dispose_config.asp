<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Class manage_forum_dispose
  Private Sub Class_Initialize()
    ndatabase = cndatabase(ngenre, "topic")
    nidfield = cnidfield(ngenre, "topic")
    nfpre = cnfpre(ngenre, "topic")
  End Sub

  Public Function manage_navigation()
    Dim tmpstr
    tmpstr = ireplace("manage.dispose_navigation", "tpl")
    manage_navigation = tmpstr
  End Function

  Public Sub manage_transfer()
    Dim tmpstr
    tmpstr = ireplace("manage.dispose_transfer", "tpl")
    response.write tmpstr
  End Sub

  Public Sub manage_delete()
    Dim tmpstr
    tmpstr = ireplace("manage.dispose_delete", "tpl")
    response.write tmpstr
  End Sub

  Public Sub manage_update()
    Dim tmpstr
    tmpstr = ireplace("manage.dispose_update", "tpl")
    response.write tmpstr
  End Sub

  Public Sub manage_transferdisp()
    Dim sort1, sort2, tcondition, tbackurl
    sort1 = get_num(request.Form("sort1"), 0)
    sort2 = get_num(request.Form("sort2"), 0)
    tcondition = get_safecode(request.Form("condition"))
    tcondition = format_checkbox(tcondition)
    Dim tstart_time, tend_time, tauthor
    tstart_time = get_safecode(request.Form("start_time"))
    tend_time = get_safecode(request.Form("end_time"))
    tbackurl = get_safecode(request.querystring("backurl"))
    tauthor = get_safecode(request.querystring("author"))
    If sort1 = 0 Or sort2 = 0 Or check_null(tcondition) Then
      Call jtbc_cms_admin_msg(itake("manage_dispose.transfer_failed", "lng"), tbackurl, 1)
    Else
      Dim tsqlstr
      sqlstr =  "select * from " & ndatabase & " where " & cfname("sid") & "=" & sort1
      If Not cinstr(tcondition, "all", ",") Then
        sqlstr = sqlstr & " and (" & nidfield & "=0"
        If cinstr(tcondition, "elite", ",") Then sqlstr = sqlstr & " or " & cfname("elite") & "=1"
        If cinstr(tcondition, "lock", ",") Then sqlstr = sqlstr & " or " & cfname("lock") & "=1"
        If cinstr(tcondition, "top", ",") Then sqlstr = sqlstr & " or " & cfname("top") & "=1"
        If cinstr(tcondition, "htop", ",") Then sqlstr = sqlstr & " or " & cfname("htop") & "=1"
        If cinstr(tcondition, "hidden", ",") Then sqlstr = sqlstr & " or " & cfname("hidden") & "=1"
        sqlstr = sqlstr & ")"
      End If
      Select Case dbtype
        Case 0
          If IsDate(tstart_time) Then sqlstr = sqlstr & " and datediff('d','" & tstart_time & "'," & cfname("time") & ")>=0"
          If IsDate(tend_time) Then sqlstr = sqlstr & " and datediff('d','" & tend_time & "'," & cfname("time") & ")<=0"
        Case 1
          If IsDate(tstart_time) Then sqlstr = sqlstr & " and datediff(day,'" & tstart_time & "'," & cfname("time") & ")>=0"
          If IsDate(tend_time) Then sqlstr = sqlstr & " and datediff(day,'" & tend_time & "'," & cfname("time") & ")<=0"
      End Select
      If Not check_null(tauthor) Then sqlstr = sqlstr & " and " & cfname("author") & "='" & tauthor & "'"
      Set rs = server.CreateObject("adodb.recordset")
      rs.open sqlstr, conn, 1, 3
      Do While Not rs.EOF
        rs(cfname("sid")) = sort2
        tsqlstr = "update " & ndatabase & " set " & cfname("sid") & "=" & sort2 & " where " & cfname("fid") & "=" & rs(nidfield)
        conn.Execute(tsqlstr)
        rs.movenext
      loop
      Set rs = nothing
      Call jtbc_cms_admin_msg(itake("manage_dispose.transfer_succeed", "lng"), tbackurl, 1)
    End If
  End Sub

  Public Sub manage_deletedisp()
    Dim tdata_ndatabase, tdata_nidfield, tdata_nfpre
    tdata_ndatabase = cndatabase(ngenre, "data")
    tdata_nidfield = cnidfield(ngenre, "data")
    tdata_nfpre = cnfpre(ngenre, "data")
    Dim tvote_ndatabase, tvote_nidfield, tvote_nfpre
    Dim tvote_data_ndatabase, tvote_data_nidfield, tvote_data_nfpre
    Dim tvote_voter_ndatabase, tvote_voter_nidfield, tvote_voter_nfpre
    tvote_ndatabase = cndatabase(ngenre, "vote")
    tvote_nidfield = cnidfield(ngenre, "vote")
    tvote_nfpre = cnfpre(ngenre, "vote")
    tvote_data_ndatabase = cndatabase(ngenre, "vote_data")
    tvote_data_nidfield = cnidfield(ngenre, "vote_data")
    tvote_data_nfpre = cnfpre(ngenre, "vote_data")
    tvote_voter_ndatabase = cndatabase(ngenre, "vote_voter")
    tvote_voter_nidfield = cnidfield(ngenre, "vote_voter")
    tvote_voter_nfpre = cnfpre(ngenre, "vote_voter")
    Dim tsort, tcondition, tbackurl
    tsort = get_num(request.Form("sort"), 0)
    tcondition = get_safecode(request.Form("condition"))
    tcondition = format_checkbox(tcondition)
    Dim tstart_time, tend_time, tauthor
    tstart_time = get_safecode(request.Form("start_time"))
    tend_time = get_safecode(request.Form("end_time"))
    tbackurl = get_safecode(request.querystring("backurl"))
    tauthor = get_safecode(request.querystring("author"))
    If tsort = 0 Or check_null(tcondition) Then
      Call jtbc_cms_admin_msg(itake("manage_dispose.delete_failed", "lng"), tbackurl, 1)
    Else
      Dim tsqlstr
      sqlstr =  "select * from " & ndatabase & " where " & cfname("fid") & "=0"
      If Not tsort = -1 Then sqlstr = sqlstr & " and " & cfname("sid") & "=" & tsort
      If Not cinstr(tcondition, "all", ",") Then
        sqlstr = sqlstr & " and (" & nidfield & "=0"
        If cinstr(tcondition, "elite", ",") Then sqlstr = sqlstr & " or " & cfname("elite") & "=1"
        If cinstr(tcondition, "lock", ",") Then sqlstr = sqlstr & " or " & cfname("lock") & "=1"
        If cinstr(tcondition, "top", ",") Then sqlstr = sqlstr & " or " & cfname("top") & "=1"
        If cinstr(tcondition, "htop", ",") Then sqlstr = sqlstr & " or " & cfname("htop") & "=1"
        If cinstr(tcondition, "hidden", ",") Then sqlstr = sqlstr & " or " & cfname("hidden") & "=1"
        sqlstr = sqlstr & ")"
      End If
      Select Case dbtype
        Case 0
          If IsDate(tstart_time) Then sqlstr = sqlstr & " and datediff('d','" & tstart_time & "'," & cfname("time") & ")>=0"
          If IsDate(tend_time) Then sqlstr = sqlstr & " and datediff('d','" & tend_time & "'," & cfname("time") & ")<=0"
        Case 1
          If IsDate(tstart_time) Then sqlstr = sqlstr & " and datediff(day,'" & tstart_time & "'," & cfname("time") & ")>=0"
          If IsDate(tend_time) Then sqlstr = sqlstr & " and datediff(day,'" & tend_time & "'," & cfname("time") & ")<=0"
      End Select
      If Not check_null(tauthor) Then sqlstr = sqlstr & " and " & cfname("author") & "='" & tauthor & "'"
      Set rs = server.CreateObject("adodb.recordset")
      rs.open sqlstr, conn, 1, 3
      Do While Not rs.EOF
        If not check_null(nuppath) Then Call upload_delete_database_note(ngenre, rs(nidfield))
        Call dbase_delete(ndatabase, cfname("fid"), rs(nidfield), "0")
        Call dbase_delete(tdata_ndatabase, cfnames(tdata_nfpre, "tid"), rs(nidfield), "0")
        Call dbase_delete(tvote_ndatabase, tvote_nidfield, rs(cfname("voteid")), "0")
        Call dbase_delete(tvote_data_ndatabase, cfnames(tvote_data_nfpre, "fid"), rs(cfname("voteid")), "0")
        Call dbase_delete(tvote_voter_ndatabase, cfnames(tvote_voter_nfpre, "fid"), rs(cfname("voteid")), "0")
        rs.delete
        rs.movenext
      loop
      Set rs = nothing
      Call jtbc_cms_admin_msg(itake("manage_dispose.delete_succeed", "lng"), tbackurl, 1)
    End If
  End Sub

  Public Sub manage_updatedisp()
    Dim tsort, tcondition, tbackurl
    tsort = get_num(request.Form("sort"), 0)
    tcondition = get_safecode(request.Form("condition"))
    tcondition = format_checkbox(tcondition)
    tbackurl = get_safecode(request.querystring("backurl"))
    If tsort = 0 Or check_null(tcondition) Then
      Call jtbc_cms_admin_msg(itake("manage_dispose.update_failed", "lng"), tbackurl, 1)
    Else
      Dim tdatabase, tidfield, tfpre
      tdatabase = cndatabase(ngenre, "sort")
      tidfield = cnidfield(ngenre, "sort")
      tfpre = cnfpre(ngenre, "sort")
      sqlstr =  "select * from " & tdatabase & " where " & tidfield & ">0"
      If Not tsort = -1 Then sqlstr = sqlstr & " and " & tidfield & "=" & tsort
      Set rs = server.CreateObject("adodb.recordset")
      rs.open sqlstr, conn, 1, 3
      Dim trs, tsqlstr
      Do While Not rs.EOF
        Dim tcount1, tcount2, tcount3
        tsqlstr = "select count(" & nidfield & ") from " & ndatabase & " where " & cfname("sid") & "=" & rs(tidfield)
        Set trs = conn.Execute(tsqlstr)
        tcount1 = trs(0)
        tsqlstr = "select count(" & nidfield & ") from " & ndatabase & " where " & cfname("fid") & "=0 and " & cfname("sid") & "=" & rs(tidfield)
        Set trs = conn.Execute(tsqlstr)
        tcount2 = trs(0)
        Select Case dbtype
          Case 0
            tsqlstr = "select count(" & nidfield & ") from " & ndatabase & " where " & cfname("fid") & "=0 and datediff('d'," & cfname("time") & ",now())=0 and " & cfname("sid") & "=" & rs(tidfield)
          Case 1
            tsqlstr = "select count(" & nidfield & ") from " & ndatabase & " where " & cfname("fid") & "=0 and datediff(day," & cfname("time") & ",getdate())=0 and " & cfname("sid") & "=" & rs(tidfield)
        End Select
        Set trs = conn.Execute(tsqlstr)
        tcount3 = trs(0)
        Set trs = Nothing
        Dim tsqlstr1, tsqlstr2, tsqlstr3
        If Not cinstr(tcondition, "all", ",") Then
          If cinstr(tcondition, "nnote", ",") Then rs(cfnames(tfpre, "nnote")) = tcount1
          If cinstr(tcondition, "ntopic", ",") Then rs(cfnames(tfpre, "ntopic")) = tcount2
          If cinstr(tcondition, "today_ntopic", ",") Then rs(cfnames(tfpre, "today_ntopic")) = tcount3
        Else
          rs(cfnames(tfpre, "nnote")) = tcount1
          rs(cfnames(tfpre, "ntopic")) = tcount2
          rs(cfnames(tfpre, "today_ntopic")) = tcount3
        End If
        rs.update
        rs.movenext
      loop
      Set rs = Nothing
      Call jtbc_cms_admin_msg(itake("manage_dispose.update_succeed", "lng"), tbackurl, 1)
    End If
  End Sub

  Private Sub Class_Terminate()
  End Sub
End Class
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
