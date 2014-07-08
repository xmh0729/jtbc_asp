<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Dim forum_isadmin

Function module_data_top()
  Dim tmpstr: tmpstr = ireplace("module.data_top", "tpl")
  module_data_top = tmpstr
End Function

Function module_data_foot()
  Dim tmpstr: tmpstr = ireplace("module.data_foot", "tpl")
  module_data_foot = tmpstr
End Function

Function module_data_manage_menu()
  Dim tmpstr, tsid
  tsid = get_num(request.querystring("sid"), 0)
  tmpstr = ireplace("module.data_manage_menu", "tpl")
  tmpstr = replace(tmpstr, "{$sid}", tsid)
  module_data_manage_menu = tmpstr
End Function

Function jtbc_cms_module_index()
  Call set_forum_ndatabase("sort")
  Dim tutype: tutype = get_userinfo("utype", nusername)
  Dim ttplstr, ttplastr, tmpstr, toutstr
  Dim tmpastr, tmprstr, tmptstr
  Dim trs, tsqlstr
  Dim tislock
  ttplstr = itake("module.index", "tpl")
  ttplastr = ctemplate(ttplstr, "{$recurrence_forum}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("fsid") & "=0 and " & cfname("hidden") & "=0 and " & cfname("lng") & "='" & nlng & "' order by " & cfname("order") & " asc"
  Set rs = conn.Execute(sqlstr)
  Dim tpl_image: tpl_image = itake("global.tpl_config.image", "tpl")
  Dim tforum_images
  Do While not rs.EOF
    tmpstr = ttplastr
    tmprstr = ""
    tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
    tsqlstr = "select * from " & ndatabase & " where " & cfname("fsid") & "=" & rs(nidfield) & " and " & cfname("hidden") & "=0 order by " & cfname("order") & " asc"
    Set trs = conn.Execute(tsqlstr)
    Do While not trs.EOF
      tislock = check_forum_islock(trs(cfname("popedom")), tutype, trs(cfname("type")), trs(cfname("attestation")), nusername)
      tforum_images = get_str(trs(cfname("images")))
      If Not check_null(tforum_images) Then tforum_images = replace(tpl_image, "{$value}", tforum_images)
      tmptstr = Replace(tmpastr, "{$sort}", get_str(trs(cfname("sort"))))
      tmptstr = Replace(tmptstr, "{$explain}", encode_article(get_str(trs(cfname("explain")))))
      tmptstr = Replace(tmptstr, "{$admin}", get_forum_admin(trs(cfname("admin"))))
      tmptstr = Replace(tmptstr, "{$pic}", get_forum_pic(tislock, trs(cfname("today_date"))))
      tmptstr = Replace(tmptstr, "{$forum_images}", tforum_images)
      tmptstr = Replace(tmptstr, "{$forum_info}", get_forum_info(trs(nidfield), tislock, trs(cfname("last_tid")), trs(cfname("last_topic")), trs(cfname("last_time")), trs(cfname("today_ntopic")), trs(cfname("today_date")), trs(cfname("ntopic")), trs(cfname("nnote"))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(trs(nidfield),0))
      tmprstr = tmprstr & tmptstr
      trs.movenext
    Loop
    Set trs = nothing
    tmpstr = Replace(tmpstr, "{$sort}", rs(cfname("sort")))
    tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
    rs.movenext
    toutstr = toutstr & tmpstr
  Loop
  Set rs = nothing
  toutstr = Replace(ttplstr, jtbc_cinfo, toutstr)
  toutstr = creplace(toutstr)
  jtbc_cms_module_index = toutstr
End Function

Function jtbc_cms_module_topic_list()
  Call set_forum_ndatabase("sort")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tutype: tutype = get_userinfo("utype", nusername)
  Dim tmpstr
  Dim tmpastr, tmprstr, tmptstr
  Dim trs, tsqlstr
  Dim tislock
  tmpstr = itake("module.topic_list", "tpl")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and not " & cfname("fsid") & "=0 and " & nidfield & "=" & tsid
  Set rs = conn.Execute(sqlstr)
  If not rs.EOF Then
    Call cntitle(rs(cfname("sort")))
    tislock = check_forum_islock(rs(cfname("popedom")), tutype, rs(cfname("type")), rs(cfname("attestation")), nusername)
    If tislock Then Call imessage(itake("module.popedom", "lng"), -1)
    tmprstr = ""
    tmpastr = ctemplate(tmpstr, "{$child_forum}")
    tsqlstr = "select * from " & ndatabase & " where " & cfname("fsid") & "=" & rs(nidfield) & " and " & cfname("hidden") & "=0 order by " & cfname("order") & " asc"
    Set trs = conn.Execute(tsqlstr)
    If Not trs.eof Then
      Dim tpl_image: tpl_image = itake("global.tpl_config.image", "tpl")
      Dim tforum_images
      Dim tmptstr2, tmpastr2, tmprstr2
      tmpastr2 = ctemplate(tmpastr, "{$recurrence_ida}")
      Do While not trs.EOF
        tislock = check_forum_islock(trs(cfname("popedom")), tutype, trs(cfname("type")), trs(cfname("attestation")), nusername)
        tforum_images = get_str(trs(cfname("images")))
        If Not check_null(tforum_images) Then tforum_images = replace(tpl_image, "{$value}", tforum_images)
        tmptstr2 = Replace(tmpastr2, "{$sort}", get_str(trs(cfname("sort"))))
        tmptstr2 = Replace(tmptstr2, "{$explain}", encode_article(get_str(trs(cfname("explain")))))
        tmptstr2 = Replace(tmptstr2, "{$admin}", get_forum_admin(trs(cfname("admin"))))
        tmptstr2 = Replace(tmptstr2, "{$pic}", get_forum_pic(tislock, trs(cfname("today_date"))))
        tmptstr2 = Replace(tmptstr2, "{$forum_images}", tforum_images)
        tmptstr2 = Replace(tmptstr2, "{$forum_info}", get_forum_info(trs(nidfield), tislock, trs(cfname("last_tid")), trs(cfname("last_topic")), trs(cfname("last_time")), trs(cfname("today_ntopic")), trs(cfname("today_date")), trs(cfname("ntopic")), trs(cfname("nnote"))))
        tmptstr2 = Replace(tmptstr2, "{$id}", get_num(trs(nidfield),0))
        tmprstr2 = tmprstr2 & tmptstr2
        trs.movenext
      loop
      tmpastr = Replace(tmpastr, jtbc_cinfo, tmprstr2)
      tmpstr = Replace(tmpstr, jtbc_cinfo, tmpastr)
    Else
      tmpstr = Replace(tmpstr, jtbc_cinfo, "")
    End If
    Set trs = nothing
    tmpstr = Replace(tmpstr, "{$forum_admin}", get_forum_admin(rs(cfname("admin"))))
    tmpstr = Replace(tmpstr, "{$sort}", get_str(rs(cfname("sort"))))
    tmpstr = Replace(tmpstr, "{$rule}", encode_article(get_str(rs(cfname("rule")))))
  Else
    Call imessage(itake("config.notexist", "lng"), -1)
  End If
  Set rs = nothing
  Call set_forum_ndatabase("topic")
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  sqlstr = "select top 5000 * from " & ndatabase & " where (" & cfname("htop") & "=1 or " & cfname("sid") & "=" & tsid & ") and " & cfname("fid") & "=0 and " & cfname("hidden") & "=0 order by " & cfname("htop") & " desc," & cfname("top") & " desc," & cfname("lasttime") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, tmptopicpic
  Dim tpicnew: tpicnew = ireplace("config.new", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = change_forum_topic(htmlencode(get_str(rs(cfname("topic")))), get_str(rs(cfname("color"))), get_str(rs(cfname("b"))))
      tmptopicpic = ""
      If DateDiff("h", rs(cfname("time")), Now()) < 24 Then tmptopicpic = tmptopicpic & tpicnew
      tmptstr = Replace(tmpastr, "{$ico}", get_forum_topic_pic(rs(cfname("htop")), rs(cfname("top")), rs(cfname("lock")), rs(cfname("elite")), rs(cfname("count"))))
      tmptstr = Replace(tmptstr, "{$icon}", get_num(rs(cfname("icon")), 0))
      tmptstr = Replace(tmptstr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicpic}", tmptopicpic)
      tmptstr = Replace(tmptstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$reply}", get_num(rs(cfname("reply")), 0))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")), 0))
      tmptstr = Replace(tmptstr, "{$lasttime}", format_date(rs(cfname("lasttime")), 11))
      tmptstr = Replace(tmptstr, "{$lastuser}", htmlencode(get_str(rs(cfname("lastuser")))))
      tmptstr = Replace(tmptstr, "{$tid}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = Replace(tmpstr, "{$userfolder}", get_actual_route(userfolder))
  tmpstr = Replace(tmpstr, "{$loadreply}", itake("module.loadreply", "lng"))
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_topic_list = tmpstr
End Function

Function jtbc_cms_module_topic_detail()
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim ttid: ttid = get_num(request.querystring("tid"), 0)
  Dim ttlock, ttopic
  If Not check_forum_popedom(tsid, 0) = 0 Then Call imessage(itake("module.popedom", "lng"), -1)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.topic_detail", "tpl")
  Dim tuser_ndatabase, tuser_nidfield, tuser_nfpre
  Dim tftopic_ndatabase, tftopic_nidfield, tftopic_nfpre
  Dim tfdata_ndatabase, tfdata_nidfield, tfdata_nfpre
  tuser_ndatabase = cndatabase(userfolder, "0")
  tuser_nidfield = cnidfield(userfolder, "0")
  tuser_nfpre = cnfpre(userfolder, "0")
  tftopic_ndatabase = cndatabase(ngenre, "topic")
  tftopic_nidfield = cnidfield(ngenre, "topic")
  tftopic_nfpre = cnfpre(ngenre, "topic")
  Dim tvoteid: tvoteid = 0
  sqlstr = "select * from " & tftopic_ndatabase & " where " & tftopic_nidfield & "=" & ttid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    If rs(cfnames(tftopic_nfpre, "hidden")) = 1 Then Call imessage(itake("module.topic_hidden", "lng"), -1)
    If not rs(cfnames(tftopic_nfpre, "sid")) = tsid and rs(cfnames(tftopic_nfpre, "htop")) = 0 Then Call imessage(itake("global.lng_public.sudd", "lng"), -1)
    tvoteid = get_num(rs(cfnames(tftopic_nfpre, "voteid")), 0)
    rs(cfnames(tftopic_nfpre, "count")) = rs(cfnames(tftopic_nfpre, "count")) + 1
    rs.update
  Else
    Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  End If
  Set rs = Nothing
  sqlstr = "select * from " & tuser_ndatabase & "," & tftopic_ndatabase & " where " & tuser_ndatabase & "." & cfnames(tuser_nfpre, "username") & "=" & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "author") & " and (" & tftopic_ndatabase & "." & tftopic_nidfield & "=" & ttid & " or " & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "fid") & "=" & ttid & " ) and " & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "hidden") & "=0 order by " & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "fid") & " asc," & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "time") & " asc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize_reply
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  If not tvoteid = 0 Then
    Dim tvote_ndatabase, tvote_nidfield, tvote_nfpre
    Dim tvote_data_ndatabase, tvote_data_nidfield, tvote_data_nfpre
    tvote_ndatabase = cndatabase(ngenre, "vote")
    tvote_nidfield = cnidfield(ngenre, "vote")
    tvote_nfpre = cnfpre(ngenre, "vote")
    tvote_data_ndatabase = cndatabase(ngenre, "vote_data")
    tvote_data_nidfield = cnidfield(ngenre, "vote_data")
    tvote_data_nfpre = cnfpre(ngenre, "vote_data")
    Dim tvi, tvtopic, tvtype, tvday, tendtime, trs, tsqlstrc
    tsqlstrc = "select * from " & tvote_ndatabase & "," & tvote_data_ndatabase & " where " & tvote_ndatabase & "." & tvote_nidfield & "=" & tvote_data_ndatabase & "." & cfnames(tvote_data_nfpre, "fid") & " and " & tvote_ndatabase & "." & tvote_nidfield & "=" & tvoteid
    Set trs = server.CreateObject("adodb.recordset")
    trs.open tsqlstrc, conn, 1, 3
    If not trs.EOF Then
      tvtopic = htmlencode(get_str(trs(cfnames(tvote_nfpre, "topic"))))
      tvtype = get_num(trs(cfnames(tvote_nfpre, "type")), 0)
      tvday = get_num(trs(cfnames(tvote_nfpre, "day")), -1)
      If tvday = -1 Then
        tendtime = itake("config.noexp", "lng")
      Else
        tendtime = DateAdd("d", get_date(trs(cfnames(tvote_nfpre, "day"))), tvday)
      End If
      Dim tvoteary, tvotecount
      tvi = 0: tvotecount = 0
      ReDim tvoteary(trs.recordcount - 1, 2)
      Do While not trs.EOF
        tvoteary(tvi, 0) = trs(tvote_data_nidfield)
        tvoteary(tvi, 1) = htmlencode(get_str(trs(cfnames(tvote_data_nfpre, "topic"))))
        tvoteary(tvi, 2) = get_num(trs(cfnames(tvote_data_nfpre, "count")), 0)
        tvotecount = tvotecount + get_num(trs(cfnames(tvote_data_nfpre, "count")), 0)
        trs.movenext
        tvi = tvi + 1
      Loop
      Dim tvotestr, tvoteastr, tvoterstr, tvotetstr
      tvotestr = ctemplate(tmpstr, "{$recurrence_vote}")
      tvoteastr = ctemplate(tvotestr, "{$recurrence_voa}")
      For tvi = 0 to UBound(tvoteary)
        tvotetstr = Replace(tvoteastr, "{$id}", tvoteary(tvi, 0))
        tvotetstr = Replace(tvotetstr, "{$topic}", tvoteary(tvi, 1))
        tvotetstr = Replace(tvotetstr, "{$type}", tvtype)
        tvotetstr = Replace(tvotetstr, "{$per}", cper(tvoteary(tvi, 2), tvotecount))
        tvoterstr = tvoterstr & tvotetstr
      Next
      tvotestr = Replace(tvotestr, jtbc_cinfo, tvoterstr)
      tvotestr = Replace(tvotestr, "{$topic}", tvtopic)
      tvotestr = Replace(tvotestr, "{$count}", tvotecount)
      tvotestr = Replace(tvotestr, "{$endtime}", tendtime)
      tvotestr = Replace(tvotestr, "{$id}", tvoteid)
      tmpstr = Replace(tmpstr, jtbc_cinfo, tvotestr)
    Else
      tmpstr = cvalhtml(tmpstr, 0, "{$recurrence_vote}")
    End If
    Set trs = Nothing
  Else
    tmpstr = cvalhtml(tmpstr, 0, "{$recurrence_vote}")
  End If
  Dim tcutnote: tcutnote = jcutpage.cutnote
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  For jcuti = 1 To npagesize_reply
    If Not rs.EOF Then
      If jcuti = 1 Then
        ttlock = get_num(rs(cfnames(tftopic_nfpre, "lock")), 0)
        ttopic = htmlencode(get_str(rs(cfnames(tftopic_nfpre, "topic"))))
        Call cntitle(ttopic)
      End If
      tmptstr = Replace(tmpastr, "{$username}", htmlencode(get_str(rs(cfnames(tuser_nfpre, "username")))))
      tmptstr = Replace(tmptstr, "{$utype}", get_num(rs(cfnames(tuser_nfpre, "utype")), 0))
      tmptstr = Replace(tmptstr, "{$face}", get_userface(get_num(rs(cfnames(tuser_nfpre, "face")), 0), get_num(rs(cfnames(tuser_nfpre, "face_u")), 0), get_str(rs(cfnames(tuser_nfpre, "face_url")))))
      tmptstr = Replace(tmptstr, "{$face_u}", get_num(rs(cfnames(tuser_nfpre, "face_u")), 0))
      tmptstr = Replace(tmptstr, "{$face_width}", get_num(rs(cfnames(tuser_nfpre, "face_width")), 0))
      tmptstr = Replace(tmptstr, "{$face_height}", get_num(rs(cfnames(tuser_nfpre, "face_height")), 0))
      tmptstr = Replace(tmptstr, "{$email}", htmlencode(get_str(rs(cfnames(tuser_nfpre, "email")))))
      tmptstr = Replace(tmptstr, "{$num_topic}", get_num(rs(cfnames(tuser_nfpre, "topic")), 0))
      tmptstr = Replace(tmptstr, "{$integral}", get_num(rs(cfnames(tuser_nfpre, "integral")), 0))
      tmptstr = Replace(tmptstr, "{$regtime}", format_date(rs(cfnames(tuser_nfpre, "time")), 1))
      tmptstr = Replace(tmptstr, "{$sign}", htmlencode(get_str(rs(cfnames(tuser_nfpre, "sign")))))
      tmptstr = Replace(tmptstr, "{$icon}", get_num(rs(cfnames(tftopic_nfpre, "icon")), 0))
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(rs(cfnames(tftopic_nfpre, "topic")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfnames(tftopic_nfpre, "time"))))
      tmptstr = Replace(tmptstr, "{$content}",encode_forum_content(get_str(get_forum_content(rs(cfnames(tftopic_nfpre, "content_database")) , get_num(rs(tftopic_nidfield), 0))), get_num(rs(cfnames(tftopic_nfpre, "ubb")), 0)))
      tmptstr = Replace(tmptstr, "{$floor}", tcutnote + jcuti)
      tmptstr = Replace(tmptstr, "{$tid}", get_num(rs(tftopic_nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$topic_reply}")
  Dim tmpary: tmpary = split(tmpastr, "{$$}")
  If ttlock = 0 Then
    tmprstr = tmpary(0)
  Else
    tmprstr = tmpary(1)
  End If
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  Dim str_topic: str_topic = itake("global.lng_noun.topic", "lng")
  Dim str_integral: str_integral = itake("global.lng_noun.integral", "lng")
  Dim str_regtime: str_regtime = itake("config.reg", "lng")
  Dim str_floor: str_floor = itake("global.lng_unit.floor", "lng")
  tmpstr = Replace(tmpstr, "{$str_topic}", str_topic)
  tmpstr = Replace(tmpstr, "{$str_integral}", str_integral)
  tmpstr = Replace(tmpstr, "{$str_regtime}", str_regtime)
  tmpstr = Replace(tmpstr, "{$str_floor}", str_floor)
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = Replace(tmpstr, "{$tid}", ttid)
  tmpstr = Replace(tmpstr, "{$userfolder}", get_actual_route(userfolder))
  tmpstr = creplace(tmpstr)
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  jtbc_cms_module_topic_detail = tmpstr
End Function

Function jtbc_cms_module_topic_release()
  Call isuserlogin("0")
  Dim tUserRegTime: tUserRegTime = get_date(get_userinfo("time", nusername))
  If DateDiff("s", tUserRegTime, Now()) <= new_user_release_timeout Then Call imessage(ireplace("module.new_user_release_timeout", "lng"), -1)
  Call set_forum_ndatabase("sort")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tvote: tvote = get_num(request.querystring("vote"), 0)
  Dim tforum_popedom: tforum_popedom = check_forum_popedom(tsid, 1)
  If tforum_popedom = 1 Then Call imessage(itake("module.pdm_type", "lng"), -1)
  If tforum_popedom = 2 Then Call imessage(itake("module.pdm_mode", "lng"), -1)
  If tforum_popedom = 3 Then Call imessage(itake("module.popedom", "lng"), -1)
  Dim tmpstr: tmpstr = ireplace("module.topic_release", "tpl")
  tmpstr = replace(tmpstr, "{$sid}", tsid)
  tmpstr = cvalhtml(tmpstr, tvote, "{$recurrence_vote}")
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  tmpstr = cvalhtml(tmpstr, user_upload, "{$recurrence_user_upload}")
  tmpstr = cvalhtml(tmpstr, user_upload, "{$recurrence_user_upload_script}")
  jtbc_cms_module_topic_release = tmpstr
End Function

Function jtbc_cms_module_topic_edit()
  Dim tid: tid = get_num(request.querystring("tid"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl")) 
  Call set_forum_ndatabase("topic")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  Dim tcontent_database
  If Not rs.EOF Then
    If Not rs(cfname("author")) = nusername Then Call imessage(itake("module.topicedit_error", "lng"), -1)
    Dim tmpstr, tmpi, tmpfields, tmpfieldsvalue
    tmpstr = itake("module.topic_edit", "tpl")
    Dim tfieldscount: tfieldscount = rs.fields.Count - 1
    ReDim rsfields(tfieldscount, 1)
    For tmpi = 0 To rs.fields.Count - 1
      tmpfields = rs.fields(tmpi).Name
      tmpfieldsvalue = get_str(rs(tmpfields))
      tmpfields = get_lrstr(tmpfields, "_", "rightr")
      rsfields(tmpi, 0) = tmpfields
      rsfields(tmpi, 1) = tmpfieldsvalue
      tmpstr = Replace(tmpstr, "{$" & tmpfields & "}", htmlencode(tmpfieldsvalue))
    Next
    tmpstr = Replace(tmpstr, "{$tid}", get_str(rs(nidfield)))
  End If
  Set rs = Nothing
  tmpstr = replace(tmpstr, "{$backurl}", urlencode(tbackurl))
  tmpstr = cvalhtml(tmpstr, nvalidate, "{$recurrence_valcode}")
  tmpstr = cvalhtml(tmpstr, user_upload, "{$recurrence_user_upload}")
  tmpstr = cvalhtml(tmpstr, user_upload, "{$recurrence_user_upload_script}")
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_topic_edit = tmpstr
End Function

Function jtbc_cms_module_search_list()
  Dim tkeyword, tauthor, tsid
  tkeyword = get_safecode(request.querystring("keyword"))
  tauthor = get_safecode(request.querystring("author"))
  tsid = get_num(request.querystring("sid"), 0)
  Call set_forum_ndatabase("topic")
  Dim font_red
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.search_list", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_idb}")
  sqlstr = "select top 200 * from " & ndatabase & " where " & cfname("fid") & "=0 and " & cfname("hidden") & "=0"
  If not check_null(tkeyword) Then
    font_red = itake("global.tpl_config.font_red", "tpl")
    sqlstr = sqlstr & " and " & cfname("topic") & " like '%" & tkeyword & "%'"
  End If
  If not check_null(tauthor) Then sqlstr = sqlstr & " and " & cfname("author") & " like '%" & tauthor & "%'"
  If not tsid = 0 Then sqlstr = sqlstr & " and " & cfname("sid") & "=" & tsid
  sqlstr = sqlstr & " order by " & cfname("htop") & " desc," & cfname("top") & " desc," & cfname("lasttime") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, tmptopicpic
  Dim tpicnew: tpicnew = ireplace("config.new", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = change_forum_topic(htmlencode(get_str(rs(cfname("topic")))), get_str(rs(cfname("color"))), get_str(rs(cfname("b"))))
      If Not check_null(font_red) Then font_red = Replace(font_red, "{$explain}", tkeyword): tmptopic = Replace(tmptopic, tkeyword, font_red)
      tmptopicpic = ""
      If DateDiff("h", rs(cfname("time")), Now()) < 24 Then tmptopicpic = tmptopicpic & tpicnew
      tmptstr = Replace(tmpastr, "{$ico}", get_forum_topic_pic(rs(cfname("htop")), rs(cfname("top")), rs(cfname("lock")), rs(cfname("elite")), rs(cfname("count"))))
      tmptstr = Replace(tmptstr, "{$icon}", get_num(rs(cfname("icon")), 0))
      tmptstr = Replace(tmptstr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicpic}", tmptopicpic)
      tmptstr = Replace(tmptstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$reply}", get_num(rs(cfname("reply")), 0))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")), 0))
      tmptstr = Replace(tmptstr, "{$lasttime}", format_date(rs(cfname("lasttime")), 11))
      tmptstr = Replace(tmptstr, "{$lastuser}", htmlencode(get_str(rs(cfname("lastuser")))))
      tmptstr = Replace(tmptstr, "{$sid}", get_num(rs(cfname("sid")), 0))
      tmptstr = Replace(tmptstr, "{$tid}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$userfolder}", get_actual_route(userfolder))
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = Replace(tmpstr, "{$keyword}", htmlencode(tkeyword))
  tmpstr = Replace(tmpstr, "{$author}", htmlencode(tauthor))
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_search_list = tmpstr
End Function

Function jtbc_cms_module_manage_topic()
  ncontrol = "select"
  If forum_isadmin = 1 Then ncontrol = ncontrol & ",htop"
  ncontrol = ncontrol & ",top,elite,lock,hidden"
  Dim tncontrol, tpl_select: tpl_select = itake("global.tpl_config.select", "tpl")
  tncontrol = show_xmlinfo_select("sel_color.all", "", "select")
  tncontrol = replace_template(tpl_select, "{$option}" & spa & "{$name}", tncontrol & spa & "color")
  ncontrols = tncontrol & " "
  tncontrol = show_xmlinfo_select("sel_b.all", "", "select")
  tncontrol = replace_template(tpl_select, "{$option}" & spa & "{$name}", tncontrol & spa & "b")
  ncontrols = ncontrols & tncontrol & " "
  Call set_forum_ndatabase("sort")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tmpstr
  Dim tmpastr, tmprstr, tmptstr
  Dim trs, tsqlstr
  tmpstr = itake("module.manage_topic", "tpl")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and not " & cfname("fsid") & "=0 and " & nidfield & "=" & tsid
  Set rs = conn.Execute(sqlstr)
  If rs.EOF Then Call imessage(itake("config.notexist", "lng"), -1)
  Set rs = nothing
  Call set_forum_ndatabase("topic")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("sid") & "=" & tsid & " and " & cfname("fid") & "=0"
  If trim(request.querystring("att")) = "elite" Then sqlstr = sqlstr & " and " & cfname("elite") & "=1"
  If trim(request.querystring("att")) = "lock" Then sqlstr = sqlstr & " and " & cfname("lock") & "=1"
  If trim(request.querystring("att")) = "top" Then sqlstr = sqlstr & " and " & cfname("top") & "=1"
  If trim(request.querystring("att")) = "htop" Then sqlstr = sqlstr & " and " & cfname("htop") & "=1"
  If trim(request.querystring("att")) = "hidden" Then sqlstr = sqlstr & " and " & cfname("hidden") & "=1"
  sqlstr = sqlstr & " order by " & cfname("htop") & " desc," & cfname("top") & " desc," & cfname("lasttime") & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tmptopic, tmptopicpic
  Dim tpicnew: tpicnew = ireplace("config.new", "tpl")
  Dim tpichtop: tpichtop = ireplace("config.htop", "tpl")
  Dim tpictop: tpictop = ireplace("config.top", "tpl")
  Dim tpicelite: tpicelite = ireplace("config.elite", "tpl")
  Dim tpiclock: tpiclock = ireplace("config.lock", "tpl")
  Dim tpichidden: tpichidden = ireplace("config.hidden", "tpl")
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptopic = change_forum_topic(htmlencode(get_str(rs(cfname("topic")))), get_str(rs(cfname("color"))), get_str(rs(cfname("b"))))
      tmptopicpic = ""
      If DateDiff("h", rs(cfname("time")), Now()) < 24 Then tmptopicpic = tmptopicpic & tpicnew
      If rs(cfname("htop")) = 1 Then tmptopicpic = tmptopicpic & tpichtop
      If rs(cfname("top")) = 1 Then tmptopicpic = tmptopicpic & tpictop
      If rs(cfname("elite")) = 1 Then tmptopicpic = tmptopicpic & tpicelite
      If rs(cfname("lock")) = 1 Then tmptopicpic = tmptopicpic & tpiclock
      If rs(cfname("hidden")) = 1 Then tmptopicpic = tmptopicpic & tpichidden
      tmptstr = Replace(tmpastr, "{$ico}", get_forum_topic_pic(rs(cfname("htop")), rs(cfname("top")), rs(cfname("lock")), rs(cfname("elite")), rs(cfname("count"))))
      tmptstr = Replace(tmptstr, "{$icon}", get_num(rs(cfname("icon")), 0))
      tmptstr = Replace(tmptstr, "{$topic}", tmptopic)
      tmptstr = Replace(tmptstr, "{$topicpic}", tmptopicpic)
      tmptstr = Replace(tmptstr, "{$author}", htmlencode(get_str(rs(cfname("author")))))
      tmptstr = Replace(tmptstr, "{$reply}", get_num(rs(cfname("reply")), 0))
      tmptstr = Replace(tmptstr, "{$count}", get_num(rs(cfname("count")), 0))
      tmptstr = Replace(tmptstr, "{$lasttime}", format_date(rs(cfname("lasttime")), 11))
      tmptstr = Replace(tmptstr, "{$lastuser}", htmlencode(get_str(rs(cfname("lastuser")))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = Replace(tmpstr, "{$userfolder}", get_actual_route(userfolder))
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_manage_topic = tmpstr
End Function

Function jtbc_cms_module_manage_detail()
  ncontrol = "select,hidden"
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim ttid: ttid = get_num(request.querystring("tid"), 0)
  Dim ttlock
  If Not check_forum_popedom(tsid, 0) = 0 Then Call imessage(itake("module.popedom", "lng"), -1)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = itake("module.manage_detail", "tpl")
  Dim tuser_ndatabase, tuser_nidfield, tuser_nfpre
  Dim tftopic_ndatabase, tftopic_nidfield, tftopic_nfpre
  tuser_ndatabase = cndatabase(userfolder, "0")
  tuser_nidfield = cnidfield(userfolder, "0")
  tuser_nfpre = cnfpre(userfolder, "0")
  tftopic_ndatabase = cndatabase(ngenre, "topic")
  tftopic_nidfield = cnidfield(ngenre, "topic")
  tftopic_nfpre = cnfpre(ngenre, "topic")
  sqlstr = "select * from " & tuser_ndatabase & "," & tftopic_ndatabase & " where " & tuser_ndatabase & "." & cfnames(tuser_nfpre, "username") & "=" & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "author") & " and (" & tftopic_ndatabase & "." & tftopic_nidfield & "=" & ttid & " or " & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "fid") & "=" & ttid & " ) order by " & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "fid") & " asc," & tftopic_ndatabase & "." & cfnames(tftopic_nfpre, "time") & " asc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize_reply
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  Dim tpichidden: tpichidden = ireplace("config.hidden", "tpl")
  If rs.EOF Then Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  If not rs(cfnames(tftopic_nfpre, "sid")) = tsid and rs(cfnames(tftopic_nfpre, "htop")) = 0 Then Call imessage(itake("global.lng_public.sudd", "lng"), -1)
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  For jcuti = 1 To npagesize_reply
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$username}", htmlencode(get_str(rs(cfnames(tuser_nfpre, "username")))))
      tmptstr = Replace(tmptstr, "{$face}", get_userface(get_num(rs(cfnames(tuser_nfpre, "face")), 0), get_num(rs(cfnames(tuser_nfpre, "face_u")), 0), get_str(rs(cfnames(tuser_nfpre, "face_url")))))
      tmptstr = Replace(tmptstr, "{$face_u}", get_num(rs(cfnames(tuser_nfpre, "face_u")), 0))
      tmptstr = Replace(tmptstr, "{$face_width}", get_num(rs(cfnames(tuser_nfpre, "face_width")), 0))
      tmptstr = Replace(tmptstr, "{$face_height}", get_num(rs(cfnames(tuser_nfpre, "face_height")), 0))
      tmptstr = Replace(tmptstr, "{$num_topic}", get_num(rs(cfnames(tuser_nfpre, "topic")), 0))
      tmptstr = Replace(tmptstr, "{$integral}", get_num(rs(cfnames(tuser_nfpre, "integral")), 0))
      tmptstr = Replace(tmptstr, "{$regtime}", format_date(rs(cfnames(tuser_nfpre, "time")), 1))
      tmptstr = Replace(tmptstr, "{$sign}", htmlencode(get_str(rs(cfnames(tuser_nfpre, "sign")))))
      tmptstr = Replace(tmptstr, "{$icon}", get_num(rs(cfnames(tftopic_nfpre, "icon")), 0))
      tmptstr = Replace(tmptstr, "{$topic}", htmlencode(get_str(rs(cfnames(tftopic_nfpre, "topic")))))
      tmptstr = Replace(tmptstr, "{$time}", get_date(rs(cfnames(tftopic_nfpre, "time"))))
      tmptstr = Replace(tmptstr, "{$content}",encode_forum_content(get_str(get_forum_content(rs(cfnames(tftopic_nfpre, "content_database")) , get_num(rs(tftopic_nidfield), 0))), get_num(rs(cfnames(tftopic_nfpre, "ubb")), 0)))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(tftopic_nidfield), 0))
      If rs(cfnames(tftopic_nfpre, "hidden")) = 1 Then
        tmptstr = Replace(tmptstr, "{$topicpic}", tpichidden)
      Else
        tmptstr = Replace(tmptstr, "{$topicpic}", "")
      End If
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  Dim str_topic: str_topic = itake("global.lng_noun.topic", "lng")
  Dim str_integral: str_integral = itake("global.lng_noun.integral", "lng")
  Dim str_regtime: str_regtime = itake("config.reg", "lng")
  tmpstr = Replace(tmpstr, "{$str_topic}", str_topic)
  tmpstr = Replace(tmpstr, "{$str_integral}", str_integral)
  tmpstr = Replace(tmpstr, "{$str_regtime}", str_regtime)
  tmpstr = Replace(tmpstr, "{$tid}", ttid)
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_manage_detail = tmpstr
End Function

Function jtbc_cms_module_manage_blacklist()
  ncontrol = "select,delete"
  Call set_forum_ndatabase("sort")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tmpstr
  Dim tmpastr, tmprstr, tmptstr
  Dim trs, tsqlstr
  tmpstr = itake("module.manage_blacklist", "tpl")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and not " & cfname("fsid") & "=0 and " & nidfield & "=" & tsid
  Set rs = conn.Execute(sqlstr)
  If rs.EOF Then Call imessage(itake("config.notexist", "lng"), -1)
  Set rs = nothing
  Call set_forum_ndatabase("blacklist")
  tmprstr = ""
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  sqlstr = "select * from " & ndatabase & " where " & cfname("sid") & "=" & tsid & " order by " & nidfield & " desc"
  Dim jcutpage, jcuti
  Set jcutpage = New jtbc_cutpage
  jcutpage.perpage = npagesize
  jcutpage.sqlstr = sqlstr
  jcutpage.cutpage
  Set rs = jcutpage.pagers
  For jcuti = 1 To npagesize
    If Not rs.EOF Then
      tmptstr = Replace(tmpastr, "{$username}", htmlencode(get_str(rs(cfname("username")))))
      tmptstr = Replace(tmptstr, "{$sid}", get_num(rs(cfname("sid")), 0))
      tmptstr = Replace(tmptstr, "{$admin}", htmlencode(get_str(rs(cfname("admin")))))
      tmptstr = Replace(tmptstr, "{$time}", get_str(rs(cfname("time"))))
      tmptstr = Replace(tmptstr, "{$remark}", htmlencode(get_str(rs(cfname("remark")))))
      tmptstr = Replace(tmptstr, "{$id}", get_num(rs(nidfield), 0))
      rs.movenext
      tmprstr = tmprstr & tmptstr
    End If
  Next
  tmpstr = Replace(tmpstr, "{$cpagestr}", jcutpage.pagestr)
  Set rs = Nothing
  Set jcutpage = Nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  tmpstr = Replace(tmpstr, "{$sid}", tsid)
  tmpstr = Replace(tmpstr, "{$userfolder}", get_actual_route(userfolder))
  tmpstr = creplace(tmpstr)
  jtbc_cms_module_manage_blacklist = tmpstr
End Function

Function jtbc_cms_module_manage()
  Call isuserlogin("0")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  forum_isadmin = check_forum_isadmin(tsid)
  If forum_isadmin = 0 Then Call imessage(itake("config.admininfo", "lng"), -1)
  Select Case request.querystring("mtype")
    Case "topic"
      jtbc_cms_module_manage = jtbc_cms_module_manage_topic
    Case "detail"
      jtbc_cms_module_manage = jtbc_cms_module_manage_detail
    Case "blacklist"
      jtbc_cms_module_manage = jtbc_cms_module_manage_blacklist
    Case Else
      jtbc_cms_module_manage = jtbc_cms_module_manage_topic
  End Select
End Function

Function jtbc_cms_module
  Select Case get_ctype(request.querystring("type"), ECtype)
    Case "manage"
      jtbc_cms_module = jtbc_cms_module_manage
    Case "list"
      jtbc_cms_module = jtbc_cms_module_topic_list
    Case "detail"
      jtbc_cms_module = jtbc_cms_module_topic_detail
    Case "release"
      jtbc_cms_module = jtbc_cms_module_topic_release
    Case "edit"
      jtbc_cms_module = jtbc_cms_module_topic_edit
    Case "search"
      jtbc_cms_module = jtbc_cms_module_search_list
    Case "upload"
      If user_upload = 1 Then Call upload_files_html("upload_html")
    Case Else
      jtbc_cms_module = jtbc_cms_module_index
  End select
End Function

Sub jtbc_cms_module_topic_releasedisp()
  ECtype = "release"
  Call isuserlogin(get_actual_route(ngenre))
  Dim tUserRegTime: tUserRegTime = get_date(get_userinfo("time", nusername))
  If DateDiff("s", tUserRegTime, Now()) <= new_user_release_timeout Then Call imessage(ireplace("module.new_user_release_timeout", "lng"), -1)
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  If Not ck_valcode() Then ErrStr = ErrStr & itake("global.lng_error.valcode", "lng") & spa
  Dim tforum_popedom: tforum_popedom = check_forum_popedom(tsid, 1)
  If tforum_popedom = 1 Then ErrStr = ErrStr & itake("module.pdm_type", "lng") & spa
  If tforum_popedom = 2 Then ErrStr = ErrStr & itake("module.pdm_mode", "lng") & spa
  If tforum_popedom = 3 Then ErrStr = ErrStr & itake("module.popedom", "lng") & spa
  If check_forum_blacklist(tsid) Then ErrStr = ErrStr & itake("module.inblacklist", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "topic:" & itake("config.topic", "lng") & ",content:" & itake("config.content", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  Dim tvoteid
  Dim tvote_type: tvote_type = get_num(request.form("vote_type"), 0)
  Dim tvote_day: tvote_day = get_num(request.form("vote_day"), -1)
  Dim tvote_content: tvote_content = get_str(request.form("vote_content"))
  If not check_null(tvote_content) Then
    Dim tvote_contentary: tvote_contentary = split(tvote_content, vbcrlf)
    Dim tvi, tvub, tvote_content2, tvote_contentary2
    tvub = UBound(tvote_contentary)
    For tvi = 0 to tvub
      If not check_null(tvote_contentary(tvi)) Then
        tvote_content2 = tvote_content2 & tvote_contentary(tvi) & vbcrlf
      End If
    Next
    tvote_contentary2 = split(tvote_content2, vbcrlf)
    If UBound(tvote_contentary2) > max_vote_option or UBound(tvote_contentary2) < 2 Then
      ErrStr = ErrStr & itake("config.voteerror", "lng") & spa
    End If
    If check_null(ErrStr) Then
      Call set_forum_ndatabase("vote")
      sqlstr = "select * from " & ndatabase
      Set rs = server.CreateObject("adodb.recordset")
      rs.open sqlstr, conn, 1, 3
      rs.addnew
      rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
      rs(cfname("type")) = tvote_type
      rs(cfname("time")) = Now()
      rs(cfname("day")) = tvote_day
      rs.update
      tvoteid = rs(nidfield)
      If get_num(tvoteid, 0) = 0 Then tvoteid = get_topid(ndatabase, nidfield)
      rs.close
      Set rs = Nothing
      Call set_forum_ndatabase("vote_data")
      sqlstr = "select * from " & ndatabase
      Set rs = server.CreateObject("adodb.recordset")
      rs.open sqlstr, conn, 1, 3
      For tvi = 0 to UBound(tvote_contentary2)
        If not check_null(tvote_contentary2(tvi)) Then
          rs.addnew
          rs(cfname("topic")) = left_intercept(tvote_contentary2(tvi), 50)
          rs(cfname("fid")) = tvoteid
          rs(cfname("vid")) = tvi
          rs.update
        End If
      Next
      rs.close
      Set rs = Nothing
    End If
  End If
  If check_null(ErrStr) Then
    Call set_forum_ndatabase("topic")
    Dim tid
    sqlstr = "select * from " & ndatabase
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("sid")) = tsid
    rs(cfname("fid")) = 0
    rs(cfname("icon")) = get_num(request.Form("icon"), 0)
    rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
    rs(cfname("author")) = nusername
    rs(cfname("authorip")) = nuserip
    rs(cfname("voteid")) = get_num(tvoteid, 0)
    rs(cfname("content_database")) = get_str(get_value(ngenre & ".ndatabase_data"))
    rs(cfname("ubb")) = get_num(request.Form("ubb"), 0)
    If tforum_popedom = 2.5 Then rs(cfname("hidden")) = 1
    rs(cfname("time")) = Now()
    rs(cfname("lasttime")) = Now()
    If user_upload = 1 Then
      Dim tcontent_files_list
      tcontent_files_list = left_intercept(get_str(request.Form("content_files_list")), 10000)
      rs(cfname("content_files_list")) = tcontent_files_list
    End If
    rs.update
    tid = rs(nidfield)
    If get_num(tid, 0) = 0 Then tid = get_topid(ndatabase, nidfield)
    rs.close
    If user_upload = 1 Then Call upload_update_database_note(ngenre, tcontent_files_list, "content_files", tid)
    Call set_forum_ndatabase("data")
    sqlstr = "select * from " & ndatabase
    rs.open sqlstr, conn, 1, 3
    rs.addnew
    rs(cfname("tid")) = tid
    rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
    rs.update
    rs.close
    Call set_forum_ndatabase("sort")
    sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tsid
    rs.open sqlstr, conn, 1, 3
    If Not rs.EOF Then
      rs(cfname("ntopic")) = rs(cfname("ntopic")) + 1
      rs(cfname("nnote")) = rs(cfname("nnote")) + 1
      rs(cfname("last_topic")) = left_intercept(get_str(request.Form("topic")), 50)
      rs(cfname("last_tid")) = tid
      rs(cfname("last_time")) = Now()
      If DateDiff("d", rs(cfname("today_date")), format_date(Now(), 1)) = 0 Then
        rs(cfname("today_ntopic")) = rs(cfname("today_ntopic")) + 1
      Else
        rs(cfname("today_date")) = format_date(Now(), 1)
        rs(cfname("today_ntopic")) = 1
      End If
      rs.update
    End If
    rs.close
    Set rs = nothing
    Call update_userproperty("topic", 1, 0, nusername)
    Call update_userproperty("integral", nint_topic, 0, nusername)
    If not tforum_popedom = 2.5 Then
      response.redirect "?type=list&sid=" & tsid
    Else
      Call client_alert(itake("module.newtopic_info1", "lng"), "?type=list&sid=" & tsid)
    End If
  End If
End Sub

Sub jtbc_cms_module_topic_votedisp()
  Dim tid: tid = get_num(request.querystring("id"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If get_num(request.cookies(appname & "forum_vote")(CStr(tid)), 0) = 1 Then Call client_alert(itake("vote.failed", "lng"), -1)
  Dim tvotes: tvotes = get_str(request.form("votes"))
  If check_null(tvotes) Then Call client_alert(itake("vote.error1", "lng"), -1)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(ngenre, "vote")
  tidfield = cnidfield(ngenre, "vote")
  tfpre = cnfpre(ngenre, "vote")
  sqlstr = "select * from " & tdatabase & " where " & tidfield & "=" & tid
  Set rs = conn.Execute(sqlstr)
  If not rs.EOF Then
    If not get_num(rs(cfnames(tfpre, "day")), 0) = -1 Then
      If DateDiff("d", get_date(rs(cfnames(tfpre, "time"))), Now()) > get_num(rs(cfnames(tfpre, "day")), 0) Then Call client_alert(itake("vote.error2", "lng"), -1)
    End If
    If rs(cfnames(tfpre, "type")) = 0 Then
      tvotes = get_num(tvotes, 0)
      If tvotes = 0 Then Call client_alert(itake("vote.error3", "lng"), -1)
    Else
      tvotes = format_checkbox(tvotes)
      If Not cidary(tvotes) Then Call client_alert(itake("vote.error3", "lng"), -1)
    End If
  Else
    Call client_alert(itake("vote.error4", "lng"), -1)
  End If
  Set rs = Nothing
  tdatabase = cndatabase(ngenre, "vote_voter")
  tidfield = cnidfield(ngenre, "vote_voter")
  tfpre = cnfpre(ngenre, "vote_voter")
  sqlstr = "select * from " & tdatabase & " where " &  cfnames(tfpre, "fid") & "=" & tid & " and " & cfnames(tfpre, "ip") & "='" & nuserip & "'"
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF Then
    Call client_alert(itake("vote.error5", "lng"), -1)
  Else
    rs.addnew
    rs(cfnames(tfpre, "fid")) = tid
    rs(cfnames(tfpre, "ip")) = nuserip
    rs(cfnames(tfpre, "username")) = nusername
    rs(cfnames(tfpre, "data")) = tvotes
    rs(cfnames(tfpre, "time")) = Now()
    rs.update
  End If
  Set rs = Nothing
  tdatabase = cndatabase(ngenre, "vote_data")
  tidfield = cnidfield(ngenre, "vote_data")
  tfpre = cnfpre(ngenre, "vote_data")
  sqlstr = "update " & tdatabase & " set " & cfnames(tfpre, "count") & "=" & cfnames(tfpre, "count") & "+1 where " & cfnames(tfpre, "fid") & "=" & tid & " and " & tidfield & " in (" & tvotes & ")"
  If run_sqlstr(sqlstr) Then
    response.cookies(appname & "forum_vote")(CStr(tid)) = "1"
    Call imessage(itake("vote.succeed", "lng"), tbackurl)
  Else
    Call imessage(itake("vote.error0", "lng"), tbackurl)
  End If
End Sub

Sub jtbc_cms_module_topic_editdisp()
  ECtype = "edit"
  Call isuserlogin(get_actual_route(ngenre))
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tid: tid = get_num(request.querystring("tid"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  If Not ck_valcode() Then ErrStr = ErrStr & itake("global.lng_error.valcode", "lng") & spa
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "content:" & itake("config.content", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      ErrStr = ErrStr & replace(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]") & spa
    End If
  Next
  If check_null(ErrStr) Then
    Call set_forum_ndatabase("topic")
    sqlstr = "select * from " & ndatabase & " where " & cfname("author") & "='" & nusername & "' and " & nidfield & "=" & tid
    Set rs = server.CreateObject("adodb.recordset")
    rs.open sqlstr, conn, 1, 3
    Dim tcontent_database
    If Not rs.EOF Then
      rs(cfname("icon")) = get_num(request.Form("icon"), 0)
      rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
      rs(cfname("ubb")) = get_num(request.Form("ubb"), 0)
      If user_upload = 1 Then
        Dim tcontent_files_list
        tcontent_files_list = left_intercept(get_str(request.Form("content_files_list")), 10000)
        rs(cfname("content_files_list")) = tcontent_files_list
      End If
      rs.update
      tid = rs(nidfield)
      tcontent_database = rs(cfname("content_database"))
      If user_upload = 1 Then Call upload_update_database_note(ngenre, tcontent_files_list, "content_files", tid)
      rs.close
      Call set_forum_ndatabase("data")
      ndatabase = tcontent_database
      sqlstr = "select * from " & ndatabase & " where " & cfname("tid") & "=" & tid
      rs.open sqlstr, conn, 1, 3
      If Not rs.EOF Then
        Dim tcontents: tcontents = left_intercept(get_str(request.Form("content")), 100000)
        tcontents = tcontents & vbcrlf & vbcrlf & ireplace("module.topicedit_info", "lng")
        rs(cfname("content")) = tcontents
        rs.update
      End If
      rs.close
      Set rs = Nothing
      Call imessage(itake("module.topicedit_succeed", "lng"), tbackurl)
    Else
      Call imessage(itake("module.topicedit_failed", "lng"), tbackurl)
    End If
  End If
End Sub

Sub jtbc_cms_module_topic_replydisp()
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Call isuserlogin(tbackurl)
  Dim tUserRegTime: tUserRegTime = get_date(get_userinfo("time", nusername))
  If DateDiff("s", tUserRegTime, Now()) <= new_user_release_timeout Then Call imessage(ireplace("module.new_user_release_timeout", "lng"), -1)
  Call check_valcode(-1)
  Dim ttid: ttid = get_num(request.querystring("tid"), 0)
  Dim tid, tsid
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "content:" & itake("config.replycontent", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      Call client_alert(replace_template(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]"), -1)
    End If
  Next
  Call set_forum_ndatabase("topic")
  sqlstr = "select * from " & ndatabase & " where " & cfname("hidden") & "=0 and " & nidfield & "=" & ttid
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  If rs.EOF Then Call imessage(itake("config.notexist", "lng"), tbackurl)
  tsid = rs(cfname("sid"))
  If rs(cfname("lock")) = 1 Then Call imessage(itake("config.lockinfo", "lng"), tbackurl)
  If Not check_forum_popedom(tsid, 0) = 0 Then Call imessage(itake("module.popedom", "lng"), -1)
  If check_forum_blacklist(tsid) Then Call imessage(itake("module.inblacklist", "lng"), -1)
  rs(cfname("reply")) = rs(cfname("reply")) + 1
  rs(cfname("lasttime")) = Now()
  rs(cfname("lastuser")) = nusername
  rs.update
  rs.close
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("sid")) = tsid
  rs(cfname("fid")) = ttid
  rs(cfname("icon")) = get_num(request.Form("icon"), 0)
  rs(cfname("topic")) = left_intercept(get_str(request.Form("topic")), 50)
  rs(cfname("author")) = nusername
  rs(cfname("authorip")) = nuserip
  rs(cfname("content_database")) = get_str(get_value(ngenre & ".ndatabase_data"))
  rs(cfname("ubb")) = get_num(request.Form("ubb"), 0)
  rs(cfname("time")) = Now()
  rs(cfname("lasttime")) = Now()
  rs.update
  tid = rs(nidfield)
  If get_num(tid, 0) = 0 Then tid = get_topid(ndatabase, nidfield)
  rs.close
  Call set_forum_ndatabase("data")
  sqlstr = "select * from " & ndatabase
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("tid")) = tid
  rs(cfname("content")) = left_intercept(get_str(request.Form("content")), 100000)
  rs.update
  rs.close
  Call set_forum_ndatabase("sort")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & tsid
  rs.open sqlstr, conn, 1, 3
  If Not rs.EOF then
    rs(cfname("nnote")) = rs(cfname("nnote")) + 1
    rs(cfname("last_time")) = Now()
    rs.update
  End If
  rs.close
  Set rs = nothing
  Call update_userproperty("topic", 1, 0, nusername)
  Call update_userproperty("integral", nint_reply, 0, nusername)
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_manage_topicdisp()
  ncontrol = "select"
  If forum_isadmin = 1 Then ncontrol = ncontrol & ",htop"
  ncontrol = ncontrol & ",top,elite,lock,hidden"
  Dim tsid, tcsid, tbackurl, totsql
  tsid = get_num(request.querystring("sid"), 0)
  totsql = " and " & cfname("sid") & "=" & tsid
  tbackurl = get_safecode(request.querystring("backurl"))
  tcsid = get_safecode(request.Form("sel_id"))
  Call set_forum_ndatabase("topic")
  Select Case request.Form("control")
    Case "htop"
      If cinstr(ncontrol, "htop", ",") Then Call dbase_switch(ndatabase, nfpre & "htop", nidfield, tcsid, totsql)
    Case "top"
      If cinstr(ncontrol, "top", ",") Then Call dbase_switch(ndatabase, nfpre & "top", nidfield, tcsid, totsql)
    Case "elite"
      If cinstr(ncontrol, "elite", ",") Then Call dbase_switch(ndatabase, nfpre & "elite", nidfield, tcsid, totsql)
    Case "lock"
      If cinstr(ncontrol, "lock", ",") Then Call dbase_switch(ndatabase, nfpre & "lock", nidfield, tcsid, totsql)
    Case "hidden"
      If cinstr(ncontrol, "hidden", ",") Then Call dbase_switch(ndatabase, nfpre & "hidden", nidfield, tcsid, totsql)
  End Select
  Call dbase_update(ndatabase, cfname("color"), htmlencode(request.Form("color")), nidfield, tcsid, totsql)
  Call dbase_update(ndatabase, cfname("b"), get_num(request.Form("b"), 0), nidfield, tcsid, totsql)
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_manage_detaildisp()
  Call set_forum_ndatabase("topic")
  ncontrol = "select,hidden"
  Dim tsid, tcsid, tbackurl, totsql
  tsid = get_num(request.querystring("sid"), 0)
  totsql = " and " & cfname("sid") & "=" & tsid
  tbackurl = get_safecode(request.querystring("backurl"))
  tcsid = get_safecode(request.Form("sel_id"))
  Call set_forum_ndatabase("topic")
  Select Case request.Form("control")
    Case "hidden"
      If cinstr(ncontrol, "hidden", ",") Then Call dbase_switch(ndatabase, nfpre & "hidden", nidfield, tcsid, totsql)
  End Select
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_manage_blacklistdisp()
  Call set_forum_ndatabase("blacklist")
  ncontrol = "select,delete"
  Dim tsid, tcsid, tbackurl, totsql
  tsid = get_num(request.querystring("sid"), 0)
  totsql = " and " & cfname("sid") & "=" & tsid
  tbackurl = get_safecode(request.querystring("backurl"))
  tcsid = get_safecode(request.Form("sel_id"))
  Select Case request.Form("control")
    Case "delete"
      If cinstr(ncontrol, "delete", ",") Then Call dbase_delete(ndatabase, nidfield, tcsid, totsql)
  End Select
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_manage_add_blacklistdisp()
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  Dim tbackurl: tbackurl = get_safecode(request.querystring("backurl"))
  Dim tmpchkstr, tmpcitem
  tmpchkstr = "username:" & itake("blacklist.username", "lng") & ",remark:" & itake("blacklist.remark", "lng")
  For Each tmpcitem In Split(tmpchkstr, ",")
    If check_null(request.Form(Split(tmpcitem, ":")(0))) Then
      Call client_alert(replace_template(itake("global.lng_error.insert_empty", "lng"), "[]", "[" & Split(tmpcitem, ":")(1) & "]"), -1)
    End If
  Next
  Call set_forum_ndatabase("blacklist")
  Dim tid
  sqlstr = "select * from " & ndatabase
  Set rs = server.CreateObject("adodb.recordset")
  rs.open sqlstr, conn, 1, 3
  rs.addnew
  rs(cfname("username")) = left_intercept(get_str(request.Form("username")), 50)
  rs(cfname("sid")) = tsid
  rs(cfname("admin")) = nusername
  rs(cfname("time")) = now()
  rs(cfname("remark")) = left_intercept(get_str(request.Form("remark")), 255)
  rs.update
  Set rs = nothing
  response.redirect tbackurl
End Sub

Sub jtbc_cms_module_managedisp()
  Call isuserlogin("0")
  Dim tsid: tsid = get_num(request.querystring("sid"), 0)
  forum_isadmin = check_forum_isadmin(tsid)
  If forum_isadmin = 0 Then Call imessage(itake("config.admininfo", "lng"), -1)
  Select Case request.querystring("mtype")
    Case "topic"
      Call jtbc_cms_module_manage_topicdisp
    Case "detail"
      Call jtbc_cms_module_manage_detaildisp
    Case "blacklist"
      Call jtbc_cms_module_manage_blacklistdisp
    Case "add_blacklist"
      Call jtbc_cms_module_manage_add_blacklistdisp
  End select
End Sub

Sub jtbc_cms_module_action()
  Select Case request.querystring("action")
    Case "manage"
      Call jtbc_cms_module_managedisp
    Case "release"
      Call jtbc_cms_module_topic_releasedisp
    Case "vote"
      Call jtbc_cms_module_topic_votedisp
    Case "edit"
      Call jtbc_cms_module_topic_editdisp
    Case "reply"
      Call jtbc_cms_module_topic_replydisp
    Case "upload"
      If user_upload = 1 Then Call upload_files
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
