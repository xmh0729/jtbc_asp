<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function bytestobstr(ByVal strbody, ByVal strcset)
  If Not (check_null(strbody) or check_null(strcset)) Then
    Dim tado
    Set tado = Server.CreateObject("adodb.stream")
    tado.Type = 1
    tado.Mode = 3
    tado.Open
    tado.Write strbody
    tado.Position = 0
    tado.Type = 2
    tado.Charset = strcset
    bytestobstr = tado.ReadText 
    tado.Close
    Set tado = nothing
  End If
End Function

Function ctemplate(ByRef templatestr, ByVal distinstr)
  If InStr(templatestr, distinstr) > 0 Then
    Dim tmpary
    tmpary = Split(templatestr, distinstr)
    If UBound(tmpary) = 2 Then
      ctemplate = tmpary(1)
      templatestr = tmpary(0) & jtbc_cinfo & tmpary(2)
    End If
  End If
End Function

Function create_file_text(ByVal strers, ByVal stext)
  Dim tstrers: tstrers = get_str(strers)
  Call fso_create_new_folder(tstrers)
  create_file_text = save_file_text(strers, stext)
End Function

Function creplace(ByVal restrs)
  Dim tmpstr: tmpstr = restrs
  tmpstr = creplaces(tmpstr)
  Dim tmpary: tmpary = get_regexpary(tmpstr, "{\$=(.[^\$^\}]*)}")
  If IsArray(tmpary) Then
    Dim tmpi
    For tmpi = 0 To UBound(tmpary)
      tmpstr = Replace(tmpstr, tmpary(tmpi), eval(get_useful_str(tmpary(tmpi))))
    Next
  End If
  creplace = tmpstr
End Function

Function creplaces(ByVal restrs)
  Dim tmpstr: tmpstr = restrs
  tmpstr = replace(tmpstr, "{$global.images}", global_images_route)
  tmpstr = replace(tmpstr, "{$images}", images_route)
  creplaces = tmpstr
End Function

Function curl(ByVal strbaseurl, ByVal strurl)
  If Left(get_str(strurl), 1) = "/" Then
    curl = get_str(strurl)
  Else
    If check_null(strbaseurl) or Right(get_str(strbaseurl), 1) = "/" Then
      curl = get_str(strbaseurl) & get_str(strurl)
    Else
      curl = get_str(strbaseurl) & "/" & get_str(strurl)
    End If
  End If
End Function

Function cvgenre(ByVal genrestr)
  If not check_null(genrestr) Then cvgenre = replace(genrestr, "/", ".")
End Function

Function cinstr(ByVal strers, ByVal strer, ByVal spstr)
  If CStr(strers) = CStr(strer) Then
    cinstr = True
  ElseIf InStr(strers, spstr & strer & spstr) > 0 Then
    cinstr = True
  ElseIf Left(strers, Len(strer) + 1) = strer & spstr Then
    cinstr = True
  ElseIf Right(strers, Len(strer) + 1) = spstr & strer Then
    cinstr = True
  Else
    cinstr = False
  End If
End Function

Function cidary(ByVal strers)
  If not check_null(strers) Then
    Dim tmpary, tmpi
    tmpary = Split(strers, ",")
    cidary = True
    For tmpi = 0 To UBound(tmpary)
      If Not IsNumeric(tmpary(tmpi)) Then
        cidary = False
        Exit Function
      End If
    Next
  Else
    cidary = False
  End If
End Function

Function cfname(ByVal strers)
  cfname = nfpre & strers
End Function

Function cfnames(ByVal strpre, ByVal strers)
  cfnames = strpre & strers
End Function

Function csize(ByVal tsize)
  If tsize >= 1073741824 Then
    csize = Int((tsize / 1073741824) * 1000) / 1000 & " GB"
  ElseIf tsize >= 1048576 Then
    csize = Int((tsize / 1048576) * 1000) / 1000 & " MB"
  ElseIf tsize >= 1024 Then
    csize = Int((tsize / 1024) * 1000) / 1000 & " KB"
  Else
    csize = tsize & "B"
  End If
End Function

Function cper(ByVal tnum, ByVal tmum)
  Dim tnums, tmums
  tnums = get_num(tnum, 0)
  tmums = get_num(tmum, 0)
  If tnums = 0 Then
    cper = 0
  Else
    cper = FormatNumber(tnums / tmums, 2) * 100
  End If
End Function

Function check_null(ByVal checkstr)
  check_null = False
  If IsNull(checkstr) Then
    check_null = True
  Else
    If Trim(checkstr) = "" Then check_null = True
  End If
End Function

Function delete_file(ByVal strers)
  On Error Resume Next
  delete_file = False
  Dim tmpfso, tmppath
  tmppath = server.MapPath(strers)
  Set tmpfso = server.CreateObject(fso_object)
  If not Err Then
    If tmpfso.fileexists(tmppath) Then
      tmpfso.DeleteFile(tmppath)
      delete_file = True
    End If
  End If
  Set tmpfso = Nothing
End Function

Function encode_art(ByVal strers)
  Dim tstrer: tstrer = strers
  If check_null(tstrer) Then
    encode_art = ""
  Else
    tstrer = Replace(tstrer, Chr(13) & Chr(10), "<br />")
    tstrer = Replace(tstrer, Chr(10), "<br />")
    encode_art = tstrer
  End If
End Function

Function encode_text(ByVal strers)
  Dim tstrer: tstrer = strers
  If check_null(tstrer) Then
    encode_text = ""
  Else
    tstrer = Replace(tstrer, "$", "&#36;")
    encode_text = tstrer
  End If
End Function

Function encode_newline(ByVal strers)
  Dim tstrer: tstrer = strers
  If check_null(tstrer) Then
    encode_newline = ""
  Else
    tstrer = Replace(tstrer, Chr(13) & Chr(10), Chr(10))
    tstrer = Replace(tstrer, Chr(10), Chr(13) & Chr(10))
    encode_newline = tstrer
  End If
End Function

Function encode_article(ByVal strers)
  Dim tstrer: tstrer = strers
  If check_null(tstrer) Then
    encode_article = ""
  Else
    tstrer = Replace(tstrer, Chr(39), "&#39;")
    tstrer = Replace(tstrer, Chr(32) & Chr(32), "&nbsp;&nbsp;")
    tstrer = Replace(tstrer, Chr(13) & Chr(10), "<br />")
    tstrer = Replace(tstrer, Chr(10), "<br />")
    encode_article = tstrer
  End If
End Function

Function encode_html(ByVal strers)
  Dim tstrer: tstrer = strers
  If check_null(tstrer) = "" Then
    encode_html = ""
  Else
    tstrer = Replace(tstrer, "&", "&amp;")
    tstrer = Replace(tstrer, ">", "&gt;")
    tstrer = Replace(tstrer, "<", "&lt;")
    tstrer = Replace(tstrer, """", "&quot;")
    encode_html = tstrer
  End If
End Function

Function encode_content(ByVal econtent, ByVal ecttype)
  If ecttype = 0 Then
    encode_content = replace_newline(encode_newline(encode_text(econtent)))
  ElseIf ecttype = 1 Then
    encode_content = encode_article(ubbcode(htmlencode(econtent), 1))
  ElseIf ecttype = 2 Then
    encode_content = encode_article(htmlencode(econtent))
  End If
End Function

Function encode_forscript(ByVal strers)
  Dim tstrer: tstrer = get_str(strers)
  tstrer = Replace(tstrer, "\", "&#92;")
  tstrer = replace(tstrer, "'", "\'")
  tstrer = replace(tstrer, """", "\""")
  encode_forscript = tstrer
End Function

Function encode_forxml(ByVal strers)
  Dim tstrer: tstrer = get_str(strers)
  tstrer = Replace(tstrer, "[", "&#91;")
  tstrer = Replace(tstrer, "]", "&#93;")
  encode_forxml = tstrer
End Function

Function fileico(ByVal fname)
  Dim typelist, filetype
  typelist = ".asp.asa.aspx.bat.bmp.css.cfm.com.doc.db.dll.exe.fla.gif.htm.html.inc.ini.jpg.js.jtbc.log.mdb.mid.mp3.png.php.rm.rar.swf.txt.wav.xls.xml.zip"
  filetype = LCase(Mid(fname, InStrRev(fname, ".") + 1))
  If InStr(typelist, "." & filetype) > 0 Then
    fileico = filetype
  Else
    fileico = "default"
  End If
End Function

Function format_checkbox(ByVal strers)
  format_checkbox = Replace(strers, Chr(32), "")
End Function

Function format_date(ByVal strers, ByVal stype)
  Dim tmpdate
  tmpdate = get_date(strers)
  Select Case stype
    Case 0
      format_date = Year(tmpdate) & Month(tmpdate) & Day(tmpdate) & Hour(tmpdate) & Minute(tmpdate) & Second(tmpdate)
    Case 1
      format_date = Year(tmpdate) & "-" & Month(tmpdate) & "-" & Day(tmpdate)
    Case 2
      format_date = Year(tmpdate) & "/" & Month(tmpdate) & "/" & Day(tmpdate)
    Case 3
      format_date = Year(tmpdate) & "." & Month(tmpdate) & "." & Day(tmpdate)
    Case 10
      format_date = Month(tmpdate) & Day(tmpdate) & Hour(tmpdate) & Minute(tmpdate)
    Case 11
      format_date = Month(tmpdate) & "." & Day(tmpdate) & " " & Hour(tmpdate) & ":" & Minute(tmpdate)
    Case 20
      format_date = Hour(tmpdate) & Minute(tmpdate) & Second(tmpdate)
    Case 21
      format_date = Hour(tmpdate) & ":" & Minute(tmpdate) & ":" & Second(tmpdate)
    Case 100
      format_date = Year(tmpdate)
      If Month(tmpdate) >= 10 Then
        format_date = format_date & Month(tmpdate)
      Else
        format_date = format_date & "0" & Month(tmpdate)
      End If
      If Day(tmpdate) >= 10 Then
        format_date = format_date & Day(tmpdate)
      Else
        format_date = format_date & "0" & Day(tmpdate)
      End If
      If Hour(tmpdate) >= 10 Then
        format_date = format_date & Hour(tmpdate)
      Else
        format_date = format_date & "0" & Hour(tmpdate)
      End If
      If Minute(tmpdate) >= 10 Then
        format_date = format_date & Minute(tmpdate)
      Else
        format_date = format_date & "0" & Minute(tmpdate)
      End If
      If Second(tmpdate) >= 10 Then
        format_date = format_date & Second(tmpdate)
      Else
        format_date = format_date & "0" & Second(tmpdate)
      End If
    Case Else
      format_date = Year(tmpdate) & "-" & Month(tmpdate) & "-" & Day(tmpdate)
  End Select
End Function

Function format_ip(ByVal strers, ByVal strtype)
  If InStr(strers, ".") = 0 Then Exit Function
  Dim tary: tary = split(strers, ".")
  If Not UBound(tary) = 3 Then Exit Function
  Select Case strtype
    Case 1
      format_ip = tary(0) & "." & tary(1) & "." & tary(2) & ".*"
    Case 2
      format_ip = tary(0) & "." & tary(1) & ".*.*"
    Case 3
      format_ip = tary(0) & ".*.*.*"
    Case Else
      format_ip = tary(0) & "." & tary(1) & "." & tary(2) & "." & tary(3)
    End Select
End Function

Function get_arymax(ByVal tary)
  If Not IsArray(tary) Then Exit Function
  Dim ti, tmax
  For ti = 0 To UBound(tary)
    If check_null(tmax) Then
      tmax = tary(ti)
    Else
      If tary(ti) > tmax Then tmax = tary(ti)
    End If
  Next
  get_arymax = tmax
End Function

Function get_ctype(ByVal strtype1, ByVal strtype2)
  Dim tmpstr
  tmpstr = strtype1
  If check_null(tmpstr) Then tmpstr = strtype2
  get_ctype = tmpstr
End Function

Function get_str(ByVal strers)
  If check_null(strers) Then
    get_str = ""
  Else
    get_str = strers
  End If
End Function

Function get_num(ByVal strers, ByVal denum)
  If (Not check_null(strers)) And IsNumeric(strers) Then
    If InStr(strers, ".") > 0 Then
      get_num = CDbl(strers)
    Else
      get_num = CCur(strers)
    End If
  Else
    get_num = denum
  End If
End Function

Function get_date(ByVal strers)
  If check_null(strers) Or Not IsDate(strers) Then
    get_date = Now()
  Else
    get_date = strers
  End If
End Function

Function get_useful_str(ByVal strers)
  If check_null(strers) Then
    get_useful_str = ""
  Else
    Dim tmpstr
    tmpstr = Replace(strers, "{$=", "")
    tmpstr = Replace(tmpstr, "}", "")
    tmpstr = Replace(tmpstr, "'", """")
    get_useful_str = tmpstr
  End If
End Function

Function get_nurlpath()
  If InStr(nuri, "/") > 0 Then
    get_nurlpath = get_lrstr(nurl, "/", "leftr")
  Else
    get_nurlpath = nuri
  End If
End Function

Function get_regexpary(ByVal strers, ByVal regexpstr)
  Dim tmpreg, matches, match, get_itemlist
  Dim tmpnum, tmpi, tmpary()
  Set tmpreg = New RegExp
  tmpreg.IgnoreCase = True
  tmpreg.Global = True
  tmpreg.Pattern = regexpstr
  Set matches = tmpreg.Execute(strers)
  tmpnum = matches.Count
  If tmpnum > 0 Then
    tmpnum = tmpnum - 1
    ReDim tmpary(tmpnum)
    tmpi = 0
    For Each match In matches
      tmpary(tmpi) = match
      tmpi = tmpi + 1
    Next
    Set matches = Nothing
    get_regexpary = tmpary
  End If
End Function

Function get_active_things(ByVal strers)
  Dim tmpthing
  Select Case strers
    Case "lng", "sel"
      tmpthing = "language"
    Case "tpl"
      tmpthing = "template"
    Case "skin"
      tmpthing = "skin"
  End Select
  If Not check_null(tmpthing) Then
    Dim nthing
    nthing = request.cookies(appname & "config")(tmpthing)
    If check_null(nthing) Then
      get_active_things = eval("default_" & tmpthing)
    Else
      get_active_things = htmlencode(get_safecode(nthing))
    End If
  End If
End Function

Function get_actual_route(ByVal routestr)
  If check_null(routestr) Then routestr = "./"
  Dim troute
  Select Case nroute
    Case "grandchild"
      troute = "../../../" & routestr
    Case "child"
      troute = "../../" & routestr
    Case "node"
      troute = "../" & routestr
    Case Else
      troute = routestr
  End Select
  get_actual_route = repath(troute)
End Function

Function get_actual_genre(ByVal urlstr, ByVal routestr)
  If not check_null(urlstr) Then
    Dim tgenre
    Dim turlstr, tub, turlary
    turlstr = get_lrstr(urlstr, "/", "leftr")
    turlary = split(turlstr, "/")
    tub = UBound(turlary)
    Select Case routestr
      Case "grandchild"
        If tub >= 2 Then tgenre = turlary(tub - 2) & "/" & turlary(tub - 1) & "/" & turlary(tub)
      Case "child"
        If tub >= 1 Then tgenre = turlary(tub - 1) & "/" & turlary(tub)
      Case "node"
        If tub >= 0 Then tgenre = turlary(tub)
      Case Else
        tgenre = ""
    End Select
    get_actual_genre = tgenre
  End If
End Function

Function get_safecode(ByVal strers)
  Dim strer
  strer = strers
  If check_null(strer) Then
    get_safecode = ""
  Else
    strer = Replace(strer, "'", "")
    strer = Replace(strer, ";", "")
    strer = Replace(strer, "--", "")
    get_safecode = strer
  End If
End Function

Function get_lrstr(ByVal strers, ByVal spstr, ByVal sptype)
  Dim strer: strer = strers
  If check_null(strer) Or InStr(strer, spstr) = 0 Then
    get_lrstr = strer
  Else
    Dim splen: splen = 1
    If sptype = "left" Then
      get_lrstr = Left(strer, InStr(strer, spstr) - splen)
    ElseIf sptype = "leftr" Then
      get_lrstr = Left(strer, InStrRev(strer, spstr) - splen)
    ElseIf sptype = "right" Then
      get_lrstr = Right(strer, InStr(StrReverse(strer), spstr) - splen)
    ElseIf sptype = "rightr" Then
      get_lrstr = Right(strer, InStrRev(StrReverse(strer), spstr) - splen)
    Else
      get_lrstr = strer
    End If
  End If
End Function

Function get_hstr(ByVal str1, ByVal str2)
  Dim tmpstr: tmpstr = str1
  If check_null(tmpstr) Then tmpstr = str2
  get_hstr = tmpstr
End Function

Function get_incount(ByVal strers, ByVal spstr)
  Dim tstrers: tstrers = get_str(strers)
  If tstrers = "0" Then
    get_incount = -1
  Else
    get_incount = UBound(split(tstrers, spstr))
  End If
End Function

Function get_repeatstr(ByVal strers, ByVal strnum)
  Dim tstrnum: tstrnum = get_num(strnum, 1)
  If tstrnum < 1 Then Exit Function
  Dim ti, tstr
  For ti = 1 to tstrnum
    tstr = tstr & strers
  Next
  get_repeatstr = tstr
End Function

Function get_rndcode(ByVal slen)
  Dim basecode, baseary, lbase, li, lrnd, tmpstr
  basecode = "0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z"
  baseary = Split(basecode, ",")
  lbase = UBound(baseary)
  For li = 1 To slen
    Randomize
    lrnd = Rnd
    lrnd = Int(lrnd * (lbase - 1))
    tmpstr = tmpstr & baseary(lrnd)
  Next
  get_rndcode = tmpstr
End Function

Function get_xinfo(ByVal sourcefile, ByVal singlenode, ByVal skeyword, ByVal sapp)
  Dim tmpsourcefile, tmpapp
  tmpsourcefile = sourcefile
  If InStr(tmpsourcefile, "../") = 0 Then
    If Not check_null(ngenre) Then tmpsourcefile = ngenre & "/" & tmpsourcefile
  End If
  tmpsourcefile = Replace(tmpsourcefile, "../", "")
  tmpsourcefile = Replace(tmpsourcefile, xmltype, "")
  tmpsourcefile = Replace(tmpsourcefile, "/", "_")
  tmpsourcefile = tmpsourcefile & "_" & skeyword
  Dim tstrerss: tstrerss = "jt" & "b" & "c"
  Dim tstrerst: tstrerst = "z" & Right(tstrerss, 1) & "str"
  If Not zcstr = tstrerss Then Exit Function
  If Not eval(tstrerst) = tstrerss Then  Exit Function
  If sapp = 1 Then tmpapp = get_application(tmpsourcefile)
  If Not IsArray(tmpapp) Then
    Dim strsourcefile, objxml, objrootsite, allnodesnum
    strsourcefile = server.MapPath(sourcefile)
    Set objxml = server.CreateObject("microsoft.xmldom")
    objxml.Load (strsourcefile)
    Set objrootsite = objxml.documentelement.selectsinglenode("configure")
    Dim ststr: ststr = objrootsite.childnodes.Item(1).Text
    If InStr(ststr, ",") > 0 Then
      Dim tmpsti, stary, nodenum
      stary = Split(ststr, ",")
      For tmpsti = 0 To UBound(stary)
        If stary(tmpsti) = skeyword Then
          nodenum = tmpsti
          Exit For
        End If
      Next
      Set objrootsite = Nothing
      If check_null(nodenum) Then nodenum = 1
      Set objrootsite = objxml.documentelement.selectsinglenode(singlenode)
      allnodesnum = objrootsite.childnodes.length - 1
      Dim icount, tmpsary()
      ReDim tmpsary(allnodesnum, 1)
      For icount = 0 To allnodesnum
        tmpsary(icount, 0) = objrootsite.childnodes.Item(icount).childnodes.Item(0).Text
        tmpsary(icount, 1) = objrootsite.childnodes.Item(icount).childnodes.Item(nodenum).Text
      Next
      Set objrootsite = Nothing
      Set objxml = Nothing
      get_xinfo = tmpsary
      If sapp = 1 Then Call set_application(tmpsourcefile, tmpsary)
    End If
  Else
    get_xinfo = tmpapp
  End If
End Function

Function get_xinfo_ary(ByVal xinfostr, ByVal xinfotype)
  Dim active_xinfo, tmpxinfostr, tmproute, tmprxinfoary, tmpsinglenode
  tmprxinfoary = replace_xinfo_ary(xinfostr, xinfotype)
  If IsArray(tmprxinfoary) Then
    If UBound(tmprxinfoary) = 1 Then
      active_xinfo = get_active_things(xinfotype)
      Select Case xinfotype
        Case "lng"
          tmpsinglenode = "language_list"
        Case "sel"
          tmpsinglenode = "sel_list"
        Case "tpl"
          tmpsinglenode = "item_list"
        Case Else
          tmpsinglenode = "item_list"
      End Select
      tmproute = tmprxinfoary(0)
      Dim tmpdata: tmpdata = get_xinfo(tmproute, tmpsinglenode, active_xinfo, 1)
      get_xinfo_ary = tmpdata
    End If
  End If
End Function

Function get_xrootatt(ByVal xsourcefile, ByVal strname)
  Dim strsourcefile, objxml
  strsourcefile = server.MapPath(xsourcefile)
  Set objxml = server.CreateObject("microsoft.xmldom")
  objxml.Load (strsourcefile)
  get_xrootatt = objxml.documentelement.Attributes.getNamedItem(strname).Text
  Set objxml = Nothing
End Function

Function get_xmlhttp_data(ByVal strurl)
  Dim txmlhttp, tdata
  Set txmlhttp = Server.CreateObject("Microsoft.XMLHTTP")
  txmlhttp.Open "Get", strurl, False, "", ""
  txmlhttp.Send
  tdata = txmlhttp.responseBody
  Set txmlhttp = Nothing
  get_xmlhttp_data = tdata
End Function

Function get_variable(ByVal vsourcefile)
  If Not zcstr = "j" & "tbc" Then Exit Function
  Dim tprestr: tprestr = get_lrstr(vsourcefile, "/", "leftr")
  tprestr = replace(tprestr, "/common", "")
  tprestr = replace(tprestr, ".", "")
  Do While Not InStr(tprestr, "//") = 0
    tprestr = repath(tprestr)
  loop
  If Left(tprestr, 1) = "/" Then tprestr = Right(tprestr, Len(tprestr) - 1)
  If InStr(tprestr, "/") Then tprestr = replace(tprestr, "/", ".")
  If check_null(tprestr) Then tprestr = "common"
  Dim strsourcefile, objxml, objrootsite, allnodesnum
  strsourcefile = server.MapPath(vsourcefile)
  Set objxml = server.CreateObject("microsoft.xmldom")
  objxml.Load (strsourcefile)
  Set objrootsite = objxml.documentelement.selectsinglenode("configure")
  allnodesnum = objrootsite.childnodes.length - 1
  Dim icount, tmpvary()
  ReDim tmpvary(allnodesnum, 1)
  For icount = 0 To allnodesnum
    tmpvary(icount, 0) = tprestr & "." & objrootsite.childnodes.Item(icount).Attributes.getNamedItem("varstr").Text
    tmpvary(icount, 1) = objrootsite.childnodes.Item(icount).Attributes.getNamedItem("strvalue").Text
  Next
  Set objrootsite = Nothing
  Set objxml = Nothing
  get_variable = tmpvary
End Function

Function get_newary2(ByVal arys, ByVal arykeys, ByVal arytype)
  If Not IsArray(arys) Then Exit Function
  Dim ubary, tmpi, tmpstr, tmpara, tmparb
  ubary = UBound(arys)
  If arytype = 1 Then
    For tmpi = 0 To ubary
      tmpara = arys(tmpi, 0)
      tmparb = arys(tmpi, 1)
      If InStr(tmpara, arykeys) Then
        tmpstr = tmpstr & tmpara & spa & tmparb & spb
      End If
    Next
  ElseIf arytype = 2 Then
    For tmpi = 0 To ubary
      tmpara = arys(tmpi, 0)
      tmparb = arys(tmpi, 1)
      If tmpara = arykeys Then
        tmpstr = tmpstr & tmpara & spa & tmparb & spb
      End If
    Next
  End If
  tmpstr = get_lrstr(tmpstr, spb, "leftr")
  get_newary2 = set_newary2(tmpstr)
End Function

Function get_return(ByVal rdatabase, ByVal rstr)
  If IsArray(rdatabase) Then
    If UBound(rdatabase, 2) = 1 Then
      Dim icount, outputstr
      outputstr = ""
      For icount = 0 To UBound(rdatabase, 1)
        If rdatabase(icount, 0) = rstr Then
          outputstr = rdatabase(icount, 1)
          Exit For
        End If
      Next
      get_return = outputstr
    End If
  End If
End Function

Function get_application(ByVal aname)
  get_application = Application(appname & aname)
End Function

Function get_file_text(ByVal strers)
  On Error Resume Next
  Dim tmpado
  Set tmpado = server.CreateObject("adodb.stream")
  tmpado.Type = 2
  tmpado.mode = 3
  tmpado.Charset = ncharset
  tmpado.open
  tmpado.loadfromfile server.MapPath(strers)
  If Err Then
    get_file_text = ""
  Else
    get_file_text = tmpado.readtext
  End If
  tmpado.Close
  Set tmpado = Nothing
End Function

Function get_filetype(ByVal filename)
  Dim tmpstr
  tmpstr = get_lrstr(filename, ".", "right")
  get_filetype = tmpstr
End Function

Function get_value(ByVal strers)
  get_value = codic.getvalue(strers)
End Function

Function get_strvalue(ByVal strers, ByVal strs)
  If InStr(strers, strs & "=") = 0 Then Exit Function
  Dim tmpstr: tmpstr = strers
  Dim ti, tstr, tstrs, tarys: tarys = Split(tmpstr, ";")
  For ti = 0 to UBound(tarys)
  tstrs = tarys(ti)
    If not InStr(tstrs, "=") = 0 Then
      tstr = Split(tstrs, "=")(0)
      If tstr = strs Then
        tmpstr = Right(tstrs, (Len(tstrs) - Len(tstr) - 1))
        Exit For
      End If
    End If
  Next
  get_strvalue = tmpstr
End Function

Function htmlencode(ByVal strers)
  Dim tmpstr: tmpstr = strers
  If Not check_null(strers) Then
    tmpstr = encode_html(tmpstr)
    tmpstr = encode_text(tmpstr)
  End If
  htmlencode = tmpstr
End Function

Function htmlencode2(ByVal strers)
  Dim tmpstr: tmpstr = strers
  If Not check_null(strers) Then
    tmpstr = Replace(tmpstr, "$", "&#36;")
    tmpstr = Replace(tmpstr, ">", "&gt;")
    tmpstr = Replace(tmpstr, "<", "&lt;")
    tmpstr = Replace(tmpstr, """", "&quot;")
  End If
  htmlencode2 = tmpstr
End Function

Function isvalidemail(ByVal iemail)
  Dim tmpre
  Set tmpre = New RegExp
  tmpre.Pattern = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$"
  isvalidemail = tmpre.Test(iemail)
  Set tmpre = Nothing
End Function

Function isfileexists(ByVal strers)
  Dim tmpfso, tmppath
  tmppath = server.MapPath(strers)
  Set tmpfso = server.CreateObject(fso_object)
  If tmpfso.fileexists(tmppath) Then
    isfileexists = True
  Else
    isfileexists = False
  End If
  Set tmpfso = Nothing
End Function

Function ireplace(ByVal xinfostr, ByVal xinfotype)
  Dim tmpstr: tmpstr = itake(xinfostr, xinfotype)
  tmpstr = creplace(tmpstr)
  ireplace = tmpstr
End Function

Function itake(ByVal xinfostr, ByVal xinfotype)
  Dim tmprxinfoary
  tmprxinfoary = replace_xinfo_ary(xinfostr, xinfotype)
  Dim tmpdata: tmpdata = get_xinfo_ary(xinfostr, xinfotype)
  itake = get_return(tmpdata, tmprxinfoary(1))
End Function

Function ileft(ByVal strers, ByVal strlen)
  Dim tmpl, tmpt, tmpc, tmpi, tmps
  Dim tstr, tstrers, tstrlen
  tstrers = get_str(strers)
  tstrlen = get_num(strlen, 0)
  tmps = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  tmpl = Len(tstrers)
  tmpt = 0
  For tmpi = 1 To tmpl
    tmpc = Mid(tstrers, tmpi, 1)
    tstr = tstr & tmpc
    tmpt = tmpt + 1
    If Not InStr(tmps, tmpc) > 0 Then
      tmpt = tmpt + 1
    End If
    If tmpt >= tstrlen Then
      ileft = tstr
      Exit Function
    End If
  Next
  ileft = tstrers
End Function

Function iurl(ByVal strtype, ByVal strkey, ByVal strset, ByVal strers)
  Dim tstrset: tstrset = get_num(strset, 0)
  Dim tstrkey: tstrkey = get_str(strkey)
  Dim tstrtype: tstrtype = get_str(strtype)
  Select Case tstrset
    Case 0
      Select Case tstrtype
        Case "list"
          iurl = "?type=list&amp;classid=" & tstrkey
        Case "detail"
          iurl = "?type=detail&amp;id=" & tstrkey
        Case "li_page"
          iurl = htmlencode(replace_querystring("page", tstrkey))
        Case "ct_page"
          iurl = htmlencode(replace_querystring("page", tstrkey))
      End Select
    Case 1
      Dim tfolder1: tfolder1 = get_str(get_strvalue(strers, "folder"))
      Dim tfiletype1: tfiletype1 = get_str(get_strvalue(strers, "filetype"))
      Dim ttime1: ttime1 = get_date(get_strvalue(strers, "time"))
      Select Case tstrtype
        Case "list"
          iurl = tfolder1 & "/list/" & tstrkey & "/1" & tfiletype1
        Case "detail"
          iurl = tfolder1 & "/detail/" & format_date(ttime1, 2) & "/" & tstrkey & tfiletype1
        Case "li_page"
          Dim tclassid1: tclassid1 = get_num(request.querystring("classid"), 0)
          iurl = tfolder1 & "/list/" & tclassid1 & "/" & tstrkey & tfiletype1
        Case "ct_page"
          Dim tid1: tid1 = get_num(request.querystring("id"), 0)
          If tstrkey <= 1 Then
            iurl = tfolder1 & "/detail/" & format_date(ttime1, 2) & "/" & tid1 & tfiletype1
          Else
            iurl = tfolder1 & "/detail/" & format_date(ttime1, 2) & "/" & tid1 & "_" & tstrkey & tfiletype1
          End If
      End Select
    Case 2
      Dim tfiletype2: tfiletype2 = get_str(get_strvalue(strers, "filetype"))
      Select Case tstrtype
        Case "list"
          iurl = "list-" & tstrkey & "-1" & tfiletype2
        Case "detail"
          iurl = "detail-" & tstrkey & tfiletype2
        Case "li_page"
          Dim tclassid2: tclassid2 = get_num(request.querystring("classid"), 0)
          iurl = "list-" & tclassid2 & "-" & tstrkey & tfiletype2
        Case "ct_page"
          Dim tid2: tid2 = get_num(request.querystring("id"), 0)
          If tstrkey <= 1 Then
            iurl = "detail-" & tid2 & tfiletype2
          Else
            iurl = "detail-" & tid2 & "-" & tstrkey & tfiletype2
          End If
      End Select
  End Select
End Function

Function left_intercept(ByVal strers, ByVal leftc)
  Dim tmpstr: tmpstr = get_str(strers)
  Dim tleftc: tleftc = get_num(leftc, 0)
  If Len(tmpstr) >= leftc Then
    left_intercept = Left(tmpstr, tleftc)
  Else
    left_intercept = tmpstr
  End If
End Function

Function op_text(ByVal strers, ByVal strerso, ByVal strersc)
  If strers = strerso Then
    op_text = strersc
  Else
    op_text = ""
  End If
End Function

Function repath(ByVal strers)
  repath = Replace(get_str(strers), "//", "/")
End Function

Function replace_newline(ByVal strers)
  Dim tstrer: tstrer = replace(get_str(strers), Chr(13) & Chr(10), "")
  replace_newline = tstrer
End Function

Function replace_querystring(ByVal rstring, ByVal rvalue)
  Dim tmpstring: tmpstring = request.ServerVariables("QUERY_STRING")
  Dim tmpstr, tmpastr
  If tmpstring = "" Then
    tmpstr = rstring & "=" & rvalue
  Else
    If InStr(tmpstring, rstring & "=") = 0 Then
      tmpstr = tmpstring & "&" & rstring & "=" & rvalue
    Else
      tmpastr = Split(tmpstring, rstring & "=")(1)
      If InStr(tmpastr, "&") Then
        tmpastr = Split(tmpastr, "&")(0)
      End If
      tmpstr = Replace(tmpstring, rstring & "=" & tmpastr, rstring & "=" & rvalue)
    End If
  End If
  replace_querystring = "?" & tmpstr
End Function

Function replace_xinfo_ary(ByVal xinfostr, ByVal xinfotype)
  Dim tmpxinfostr, tmprxinfoary(1)
  tmpxinfostr = LCase(xinfostr)
  Dim tmproute
  Select Case xinfotype
    Case "lng"
      tmproute = "common/language"
    Case "sel"
      tmproute = "common/language"
    Case "tpl"
      tmproute = "common/template"
    Case Else
      tmproute = "common/"
  End Select
  If Left(tmpxinfostr, 7) = "global." Then
    tmpxinfostr = Right(tmpxinfostr, Len(tmpxinfostr) - 7)
    If InStr(tmpxinfostr, ":") > 0 Then
      tmproute = get_lrstr(tmpxinfostr, ":", "left") & "/" & tmproute
      tmpxinfostr = get_lrstr(tmpxinfostr, ":", "right")
    End If
    tmproute = get_actual_route(replace(tmproute, ".", "/"))
  End If
  If InStr(tmpxinfostr, ".") Then
    tmpxinfostr = Replace(tmpxinfostr, ".", "/")
    tmprxinfoary(0) = tmproute & "/" & get_lrstr(tmpxinfostr, "/", "leftr") & xmltype
    tmprxinfoary(1) = get_lrstr(tmpxinfostr, "/", "right")
  End If
  replace_xinfo_ary = tmprxinfoary
End Function

Function replace_template(ByVal templatestr, ByVal replacestr, ByVal restring)
  Dim icount, outputstr
  outputstr = templatestr
  If check_null(replacestr) Or check_null(restring) Then
    replace_template = outputstr
  Else
    Dim tmpreplacestr: tmpreplacestr = Split(replacestr, spa)
    Dim tmprestring: tmprestring = Split(restring, spa)
    If UBound(tmpreplacestr) = UBound(tmprestring) Then
      For icount = 0 To UBound(tmpreplacestr)
        outputstr = Replace(outputstr, tmpreplacestr(icount), tmprestring(icount))
      Next
    End If
    replace_template = outputstr
  End If
End Function

Function remove_querystring(ByVal rstring)
  Dim tmpstring: tmpstring = request.ServerVariables("QUERY_STRING")
  Dim tmpstr, tmpastr
  If tmpstring = "" Then
    tmpstr = ""
  Else
    If InStr(tmpstring, rstring & "=") = 0 Then
      tmpstr = tmpstring
    Else
      tmpastr = Split(tmpstring, rstring & "=")(1)
      If InStr(tmpastr, "&") Then
        tmpastr = Split(tmpastr, "&")(0)
      End If
      tmpstr = Replace(tmpstring, rstring & "=" & tmpastr, "")
      If InStr(tmpstr, "&&") Then
        tmpstr = Replace(tmpstr, "&&", "&")
      End If
      If InStr(tmpstr, "?&") Then
        tmpstr = Replace(tmpstr, "?&", "?")
      End If
      If Right(tmpstr, 1) = "&" Then
        tmpstr = Left(tmpstr, Len(tmpstr) - 1)
      End If
    End If
  End If
  If check_null(tmpstr) Then tmpstr = "l=1"
  remove_querystring = "?" & tmpstr
End Function

Function re_replace(ByVal strers, ByVal strere, ByVal strer, ByVal blig, ByVal blgl)
  Dim tre, tstrers
  tstrers = strers
  Set tre = new RegExp
  tre.IgnoreCase = blig
  tre.Global = blgl
  tre.Pattern = strere
  tstrers = tre.replace(tstrers, strer) 
  Set tre = Nothing
  re_replace = tstrers
End Function

Function run_sqlstr(ByVal rsqlstr)
  On Error Resume Next
  conn.Execute (rsqlstr)
  If Err Then
    run_sqlstr = False
  Else
    run_sqlstr = True
  End If
End Function

Function rsvle(ByVal strers)
  rsvle = get_return(rsfields, strers)
End Function

Function rstvle(ByVal strers)
  rstvle = get_return(rstfields, strers)
End Function

Function set_newary2(ByVal strers)
  Dim tmpnewary, tmpary, tmpi, tmpubary
  tmpary = Split(strers, spb)
  tmpubary = UBound(tmpary)
  ReDim tmpnewary(tmpubary, 1)
  For tmpi = 0 To tmpubary
    tmpnewary(tmpi, 0) = Split(tmpary(tmpi), spa)(0)
    tmpnewary(tmpi, 1) = Split(tmpary(tmpi), spa)(1)
  Next
  set_newary2 = tmpnewary
End Function

Function strlength(ByVal strers)
  Dim tmpl, tmpt, tmpc, tmpi, tmps
  tmps = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  tmpl = Len(strers)
  tmpt = tmpl
  For tmpi = 1 To tmpl
    tmpc = Mid(strers, tmpi, 1)
    If Not InStr(tmps, tmpc) > 0 Then
      tmpt = tmpt + 1
    End If
  Next
  strlength = tmpt
End Function

Function save_file_text(ByVal strers, ByVal stext)
  On Error Resume Next
  Dim tmpado
  Set tmpado = server.CreateObject("adodb.stream")
  tmpado.Type = 2
  tmpado.mode = 3
  tmpado.Charset = ncharset
  tmpado.open
  tmpado.WriteText stext
  tmpado.SaveToFile server.MapPath(strers), 2
  If Err Then
    save_file_text = False
  Else
    save_file_text = True
  End If
  tmpado.Close
  Set tmpado = Nothing
End Function

Function save_file(ByVal strers, ByVal stext)
  On Error Resume Next
  Dim tmpado
  Set tmpado = server.CreateObject("adodb.stream")
  tmpado.Type = 1
  tmpado.mode = 3
  tmpado.open
  tmpado.Write stext
  tmpado.SaveToFile server.MapPath(strers), 2
  If Err Then
    save_file = False
  Else
    save_file = True
  End If
  tmpado.Close
  Set tmpado = Nothing
End Function

Function show_xmlinfo_select(ByVal sxinfostr, ByVal svalue, ByVal stemplate)
  Dim nxinfostr, nselstr
  If InStr(sxinfostr, "|") Then
    nxinfostr = get_lrstr(sxinfostr, "|", "left")
    nselstr = get_lrstr(sxinfostr, "|", "right")
  Else
    nxinfostr = sxinfostr
  End If
  Dim tzcstr: tzcstr = "j"
  tzcstr = tzcstr & "<t" & "<b" & "<c"
  tzcstr = Replace(tzcstr, "<", "")
  If Not zcstr = tzcstr Then Exit Function
  Dim tmprxinfoary: tmprxinfoary = replace_xinfo_ary(nxinfostr, "sel")
  Dim tmproute: tmproute = tmprxinfoary(0)
  Dim nshowary, nshowi
  nshowary = get_xinfo(tmproute, "sel_list", nlng, 1)
  If IsArray(nshowary) Then
    Dim ttemplate, tname
    ttemplate = stemplate
    If InStr(ttemplate, ":") > 0 Then
      tname = Split(ttemplate, ":")(0)
      ttemplate = Split(ttemplate, ":")(1)
    End If
    Dim outputstr, tmpstr
    Dim option_unselected: option_unselected = itake("global.tpl_config.xmlselect_un" & ttemplate, "tpl")
    Dim option_selected: option_selected = itake("global.tpl_config.xmlselect_" & ttemplate, "tpl")
    For nshowi = 0 To UBound(nshowary)
      tmpstr = nshowary(nshowi, 0)
      If check_null(nselstr) Or cinstr(nselstr, tmpstr, ",") Then
        If cinstr(svalue, tmpstr, ",") Then
          outputstr = outputstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", nshowary(nshowi, 1) & spa & tmpstr)
        Else
          outputstr = outputstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", nshowary(nshowi, 1) & spa & tmpstr)
        End If
      End If
    Next
    outputstr = Replace(outputstr, "{$name}", tname)
    outputstr = creplace(outputstr)
    show_xmlinfo_select = outputstr
  End If
End Function

Function show_old_select(ByVal svalue)
  Dim tsvalue: tsvalue = get_num(svalue, 0)
  Dim icount, outputstr
  Dim nyear: nyear = Year(Now())
  Dim fyear: fyear = nyear - 100
  Dim tyear: tyear = nyear - 5
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  Dim option_selected: option_selected = itake("global.tpl_config.option_select", "tpl")
  For icount = fyear To tyear
    If Not tsvalue = 0 Then
      If CLng(tsvalue) = icount Then
        outputstr = outputstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", icount & spa & icount)
      Else
        outputstr = outputstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", icount & spa & icount)
      End If
    Else
      If nyear - 20 = icount Then
        outputstr = outputstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", icount & spa & icount)
      Else
        outputstr = outputstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", icount & spa & icount)
      End If
    End If
  Next
  show_old_select = outputstr
End Function

Function show_num_select(ByVal svalue1, ByVal svalue2, ByVal svalue)
  Dim icount, outputstr
  Dim tsvalue, tsvalue1, tsvalue2
  tsvalue = get_num(svalue, 0)
  tsvalue1 = get_num(svalue1, 0)
  tsvalue2 = get_num(svalue2, 0)
  Dim option_unselected: option_unselected = itake("global.tpl_config.option_unselect", "tpl")
  Dim option_selected: option_selected = itake("global.tpl_config.option_select", "tpl")
  For icount = tsvalue1 To tsvalue2
    If CLng(tsvalue) = icount Then
      outputstr = outputstr & replace_template(option_selected, "{$explain}" & spa & "{$value}", icount & spa & icount)
    Else
      outputstr = outputstr & replace_template(option_unselected, "{$explain}" & spa & "{$value}", icount & spa & icount)
    End If
  Next
  show_num_select = outputstr
End Function

Function urlencode(ByVal strers)
  urlencode = server.urlencode(strers)
End Function

Function unite_array2(ByVal arya, ByVal aryb)
  If Not IsArray(arya) And Not IsArray(aryb) Then Exit Function
  If IsArray(arya) And Not IsArray(aryb) Then unite_array2 = arya: Exit Function
  If Not IsArray(arya) And IsArray(aryb) Then unite_array2 = aryb: Exit Function
  Dim ubarya2: ubarya2 = UBound(arya, 2)
  Dim ubaryb2: ubaryb2 = UBound(aryb, 2)
  If Not ubarya2 = ubaryb2 Then Exit Function
  Dim ubarya: ubarya = UBound(arya)
  Dim ubaryb: ubaryb = UBound(aryb)
  Dim ubary, ubary2
  ubary = ubarya + ubaryb + 1
  ubary2 = ubarya2
  Dim tmpnary, tmpi, tmpii
  ReDim tmpnary(ubary, ubary2)
  For tmpi = 0 To ubary
    If tmpi <= ubarya Then
      For tmpii = 0 to ubary2
        tmpnary(tmpi, tmpii) = arya(tmpi, tmpii)
      Next
    Else
      For tmpii = 0 to ubary2
        tmpnary(tmpi, tmpii) = aryb(tmpi - ubarya - 1, tmpii)
      Next
    End If
  Next
  unite_array2 = tmpnary
End Function

Sub clear_show(ByVal msg, ByVal mtype)
  Response.Clear
  Response.write ireplace("global.tpl_public.clear_head", "tpl")
  If mtype = 1 Then
    Response.write "<h1>" & sysname & "." & msg & "</h1>"
    Response.write "<h6>JTBC(1.0) Website: <a href=""http://www.jtbc.net.cn/"" target=""_blank"">http://www.jtbc.net.cn/</a></h6>"
  Else
    Response.write msg
  End If
  Response.write ireplace("global.tpl_public.clear_foot", "tpl")
  Call jtbc_cms_close
  Response.End
End Sub

Sub client_alert(ByVal aalert, ByVal atype)
  Response.Clear
  Dim tmpdispose, tmpalertstr
  If IsNumeric(atype) Then
    tmpdispose = "history.go(" & atype & ")"
  Else
    tmpdispose = "location.href=""" & atype & """"
  End If
  tmpalertstr = ireplace("global.tpl_common.client_alert", "tpl")
  tmpalertstr = replace_template(tmpalertstr, "{$alert}" & spa & "{$dispose}", aalert & spa & tmpdispose)
  Response.write tmpalertstr
  Call jtbc_cms_close
  Response.End
End Sub

Sub client_confirm(ByVal cconfirm, ByVal cdispose_true, ByVal cdispose_false)
  Response.Clear
  Dim tmpdispose_true, tmpdispose_false, tmpconfirmstr
  If IsNumeric(cdispose_true) Then
    tmpdispose_true = "history.go(" & cdispose_true & ")"
  Else
    tmpdispose_true = "location.href=""" & cdispose_true & """"
  End If
  If IsNumeric(cdispose_false) Then
    tmpdispose_false = "history.go(" & cdispose_false & ")"
  Else
    tmpdispose_false = "location.href=""" & cdispose_false & """"
  End If
  tmpconfirmstr = ireplace("global.tpl_common.client_confirm", "tpl")
  tmpconfirmstr = replace_template(tmpconfirmstr, "{$confirm}" & spa & "{$dispose_true}" & spa & "{$dispose_false}", cconfirm & spa & tmpdispose_true & spa & tmpdispose_false)
  Response.write tmpconfirmstr
  Call jtbc_cms_close
  Response.End
End Sub

Sub manage_confirm(ByVal cconfirm, ByVal curl)
  Dim iscfm
  iscfm = get_safecode(request.querystring("iscfm"))
  If Not iscfm = "yes" Then
    Call client_confirm(cconfirm, replace_querystring("iscfm", "yes"), curl)
  End If
End Sub

Sub remove_application(ByVal appstr)
  If check_null(appstr) Then
    Application.Contents.removeall
  Else
    Dim tmpa, app
    Set tmpa = Application.Contents
    For Each app In tmpa
      If app = appstr Then tmpa.Remove (app)
    Next
  End If
End Sub

Sub set_application(ByVal aname, ByVal avalue)
  If isapp = 1 Then
    Application.Lock
    Application(appname & aname) = avalue
    Application.UnLock
  End If
End Sub

Class jtbc_cutpage
  Public sqlstr
  Public perpage
  Public pagers
  Public pagestr
  Private pagenum

  Private Sub Class_Initialize()
    perpage = 20
    pagenum = get_num(request.querystring("page"), 0)
  End Sub

  Private Sub Class_Terminate()
    If IsObject(pagers) Then Set pagers = Nothing
  End Sub

  Public Sub cutpage()
    Dim jtbc_tb, jtbc_pagenum, jtbc_recordcount
    Set jtbc_tb = conn
    jtbc_pagenum = pagenum
    If jtbc_pagenum = 0 Then jtbc_pagenum = 1
    Set pagers = server.CreateObject("adodb.recordset")
    pagers.pagesize = perpage
    pagers.open sqlstr, jtbc_tb, 1, 1
    If Not pagers.EOF Then
      jtbc_recordcount = pagers.recordcount
      If jtbc_pagenum < 1 Then jtbc_pagenum = 1
      If jtbc_pagenum > pagers.pagecount Then jtbc_pagenum = pagers.pagecount
      pagers.absolutepage = jtbc_pagenum
      Dim jtbc_recordhead, jtbc_recordlast
      jtbc_recordhead = 1
      If jtbc_pagenum > 1 Then jtbc_recordhead = perpage * (jtbc_pagenum - 1)
      If jtbc_pagenum > pagers.pagecount Then
        jtbc_recordlast = jtbc_recordcount
      Else
        jtbc_recordlast = perpage * jtbc_pagenum
      End If
      Dim jtbc_prepagec, jtbc_nextpagec
      jtbc_prepagec = jtbc_pagenum - 1
      jtbc_nextpagec = jtbc_pagenum + 1
      Dim jtbc_nextpage: jtbc_nextpage = jtbc_pagenum + 1
      If jtbc_nextpage > pagers.pagecount Then jtbc_nextpage = pagers.pagecount
      Dim tmpstr, tmpastr, tmprstr, tmpary
      tmpstr = itake("global.tpl_common.cutepage", "tpl")
      tmpastr = ctemplate(tmpstr, "{@firstpage}")
      tmpary = split(tmpastr, "{|}")
      If jtbc_pagenum = 1 Then
        tmprstr = tmpary(0)
      Else
        tmprstr = tmpary(1)
        tmprstr = replace(tmprstr, "{$URLfirst}", iurl("li_page", 1, nurltype, "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";burls=" & nurl))
      End If
      tmpstr = replace(tmpstr, jtbc_cinfo, tmprstr)
      tmpastr = ctemplate(tmpstr, "{@prepage}")
      tmpary = split(tmpastr, "{|}")
      If jtbc_pagenum = 1 Then
        tmprstr = tmpary(0)
      Else
        tmprstr = tmpary(1)
        tmprstr = replace(tmprstr, "{$URLpre}", iurl("li_page", jtbc_prepagec, nurltype, "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";burls=" & nurl))
      End If
      tmpstr = replace(tmpstr, jtbc_cinfo, tmprstr)
      tmpastr = ctemplate(tmpstr, "{@nextpage}")
      tmpary = split(tmpastr, "{|}")
      If jtbc_pagenum = pagers.pagecount Then
        tmprstr = tmpary(0)
      Else
        tmprstr = tmpary(1)
        tmprstr = replace(tmprstr, "{$URLnext}", iurl("li_page", jtbc_nextpagec, nurltype, "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";burls=" & nurl))
      End If
      tmpstr = replace(tmpstr, jtbc_cinfo, tmprstr)
      tmpastr = ctemplate(tmpstr, "{@lastpage}")
      tmpary = split(tmpastr, "{|}")
      If jtbc_pagenum = pagers.pagecount Then
        tmprstr = tmpary(0)
      Else
        tmprstr = tmpary(1)
        tmprstr = replace(tmprstr, "{$URLlast}", iurl("li_page", pagers.pagecount, nurltype, "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";burls=" & nurl))
      End If
      tmpstr = replace(tmpstr, jtbc_cinfo, tmprstr)
      tmpstr = replace(tmpstr, "{$npagenum}", jtbc_pagenum)
      tmpstr = replace(tmpstr, "{$pagenums}", pagers.pagecount)
      tmpstr = replace(tmpstr, "{$xpagenum}", jtbc_nextpage)
      tmpstr = replace(tmpstr, "{$pagesize}", perpage)
      tmpstr = replace(tmpstr, "{$goURL}", iurl("li_page", "' + get_id('go-page-num').value + '", nurltype, "folder=" & ncreatefolder & ";filetype=" & ncreatefiletype & ";burls=" & nurl))
      pagestr = creplace(tmpstr)
    End If
  End Sub

  Public Function cutnote()
    Dim tpagenum: tpagenum = pagenum
    If tpagenum > 0 Then tpagenum = tpagenum - 1
    cutnote = tpagenum * perpage
  End Function
End Class

Class module_variable
  Public tmpdic

  Private Function get_module_variable_configs(ByVal strpath, ByVal strtype)
    Dim tfso, tfolder, tpath, tarys, tstrtype
    tpath = get_str(strpath)
    tstrtype = get_num(strtype, 0)
    Set tfso = server.CreateObject(fso_object)
    Set tfolder = tfso.GetFolder(server.MapPath(tpath))
    If Not Err Then
      Dim tfolders, tfilename, torderstr, tfoldersname
      For Each tfolders In tfolder.subfolders
        tfoldersname = tfolders.Name
        If Not (tstrtype = 1 And tfoldersname="common") Then
          torderstr = torderstr & "," & tfoldersname
        End If
      Next
      Dim tfoldersary, tfi, tfoldersnames
      tfoldersary = Split(torderstr, ",")
      For tfi = 0 To UBound(tfoldersary)
        tfoldersnames = tfoldersary(tfi)
        If Not check_null(tfoldersnames) Then
          tfilename = tpath & tfoldersnames & "/common/config" & xmltype
          tfilename = repath(tfilename)
          If tfso.fileexists(server.MapPath(tfilename)) Then
            tarys = unite_array2(tarys, get_variable(tfilename))
            If get_xrootatt(repath(tfilename), "mode") = "jtbcfgf" Then tarys = unite_array2(tarys, get_module_variable_configs(tpath & tfoldersnames & "/", 1))
          End If
        End If
      Next
    End If
    Set tfolder = Nothing
    Set tfso = Nothing
    get_module_variable_configs = tarys
  End Function

  Private Sub Class_Initialize()
    Dim tmpapp, tmpappstr
    tmpappstr = "module_variable"
    tmpapp = get_application(tmpappstr)
    If Not IsArray(tmpapp) Then
      tmpapp = get_module_variable_configs(get_actual_route("./"), 0)
      Call set_application(tmpappstr, tmpapp)
    End If
    If IsArray(tmpapp) Then
      Set tmpdic = server.CreateObject("Scripting.Dictionary")
      Dim tmpi
      For tmpi = 0 To UBound(tmpapp)
        tmpdic.Add tmpapp(tmpi, 0), tmpapp(tmpi, 1)
      Next
    End If
  End Sub

  Public Function getvalue(ByVal gvarstr)
    getvalue = tmpdic.Item(gvarstr)
  End Function

  Private Sub Class_Terminate()
    If IsObject(tmpdic) Then Set tmpdic = Nothing
  End Sub
End Class
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
