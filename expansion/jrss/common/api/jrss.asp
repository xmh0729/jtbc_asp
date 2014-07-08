<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const jrssngenre = "expansion"
Const jrssnsort = "jrss"

Function check_jrss_isxml(ByVal strers)
  If InStr(strers, "<?xml") Then
    check_jrss_isxml = True
  Else
    check_jrss_isxml = False
  End If
End Function

Function get_jrss_retimetype(ByVal strers)
  Dim tstrers: tstrers = get_num(strers, 0)
  Select Case tstrers
    Case 0
      get_jrss_retimetype = "n"
    Case 1
      get_jrss_retimetype = "h"
    Case 2
      get_jrss_retimetype = "d"
    Case Else
      get_jrss_retimetype = "d"
  End Select
End Function

Function jrss(ByVal strid, ByVal strtpl, ByVal strvars)
  On Error Resume Next
  Dim tstrid: tstrid = get_num(strid, 0)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(jrssngenre & "." & jrssnsort, "0")
  tidfield = cnidfield(jrssngenre & "." & jrssnsort, "0")
  tfpre = cnfpre(jrssngenre & "." & jrssnsort, "0")
  Dim trs, tsqlstr
  Set trs = server.CreateObject("adodb.recordset")
  tsqlstr = "select * from " & tdatabase & " where " & tidfield & "=" & tstrid
  trs.open tsqlstr, conn, 1, 3
  If not trs.EOF Then
    Dim txmlfile: txmlfile = "_xml/" & trs(tidfield) & ".xml"
    Dim tacxmlfile: tacxmlfile = get_actual_route(jrssngenre) & "/" & jrssnsort & "/" & txmlfile
    If Not isfileexists(tacxmlfile) Or DateDiff(get_jrss_retimetype(trs(cfnames(tfpre, "retimetype"))), get_date(trs(cfnames(tfpre, "retime"))), Now()) >= get_num(trs(cfnames(tfpre, "retimevalue")), 0) Then
      Dim txmldata: txmldata = bytestobstr(get_xmlhttp_data(trs(cfnames(tfpre, "url"))), trs(cfnames(tfpre, "encode")))
      If check_jrss_isxml(txmldata) Then
        If create_file_text(tacxmlfile, re_replace(txmldata, "<\?xml.*encoding=(.*)?>", "<?xml version=""1.0"" encoding=""" & ncharset & """?>", False, True)) Then
          trs(cfnames(tfpre, "retime")) = Now()
          trs.update
        End If
      End If
    End If
    jrss = irss(get_actual_route(jrssngenre) & "/" & jrssnsort & "/" & txmlfile, strtpl, strvars)
  End If
  Set trs = Nothing
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
