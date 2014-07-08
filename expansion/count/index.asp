<!--#include file="../../common/incfiles/web.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<%
Dim myid, mygenre
Dim mydatabase, myidfield, myfpre
myid = get_num(request.querystring("id"), 0)
mygenre = get_safecode(request.querystring("genre"))
mydatabase = cndatabase(cvgenre(mygenre), "0")
myidfield = cnidfield(cvgenre(mygenre), "0")
myfpre = cnfpre(cvgenre(mygenre), "0")
sqlstr = "select " & cfnames(myfpre, "count") & " from " & mydatabase & " where " & myidfield & "=" & myid
Set rs = server.CreateObject("adodb.recordset")
rs.open sqlstr, conn, 1, 3
If not rs.EOF Then
  rs(cfnames(myfpre, "count")) = rs(cfnames(myfpre, "count")) + 1
  rs.update
  response.write rs(0)
End If
Set rs = Nothing
Call jtbc_cms_close()
%>
