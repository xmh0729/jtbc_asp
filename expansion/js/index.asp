<!--#include file="../../common/incfiles/web.asp"-->
<!--#include file="../../common/incfiles/module.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<%
Dim turs: turs = get_lrstr(nurs, ".", "right")
turs = get_num(turs, 0)
If not turs = 0 Then
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & ndatabase & " where " & nidfield & "=" & turs
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    Dim tjspath: tjspath = njspath & rs(cfname("topic")) & "." & rs(nidfield) & ".js"
    If DateDiff(get_js_retimetype(rs(cfname("retimetype"))), get_date(rs(cfname("retime"))), Now()) >= get_num(rs(cfname("retimevalue")), 0) Then
      Dim tjscontent: tjscontent = creplace(rs(cfname("content")))
      tjscontent = js_encode2js(tjscontent)
      If save_file_text(tjspath, tjscontent) Then
        rs(cfname("retime")) = Now()
        rs.Update
      End If
    End If
  End If
  Set rs = Nothing
  Server.Transfer tjspath
End If
%>