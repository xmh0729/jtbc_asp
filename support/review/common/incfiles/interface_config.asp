<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Response.Expires = 0
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"

Sub jtbc_cms_interface_list()
  Dim tkey, tfid
  tkey = get_safecode(request.querystring("key"))
  tfid = get_num(request.querystring("fid"), 0)
  response.write review_output_note(tkey, tfid, 5)
End Sub

Sub jtbc_cms_interface
  Select Case request.querystring("type")
    Case "list"
      Call jtbc_cms_interface_list
  End select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
