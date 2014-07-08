<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Sub jtbc_cms_admin_manage_index()
  Dim tmpstr
  tmpstr = ireplace("manage.index", "tpl")
  response.write tmpstr
End Sub

Sub jtbc_cms_admin_manage()
  Call jtbc_cms_admin_manage_index
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
