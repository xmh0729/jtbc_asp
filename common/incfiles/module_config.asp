<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_index()
  Dim tmpstr: tmpstr = ireplace("module.index", "tpl")
  jtbc_cms_module_index = tmpstr
End Function

Function jtbc_cms_module()
  jtbc_cms_module = jtbc_cms_module_index
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
