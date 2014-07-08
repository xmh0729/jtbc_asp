<!--#include file="conn.asp"-->
<!--#include file="inc.asp"-->
<!--#include file="common.asp"-->
<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function web_title(ByVal strtitle)
  Dim tmptitle: tmptitle = itake("global.module.web_title", "lng")
  If Not check_null(strtitle) Then tmptitle = strtitle & spstr & tmptitle
  web_title = tmptitle
End Function

Function web_base()
  If nbasehref = 1 Then
    Dim tmpstr: tmpstr = ireplace("global.tpl_public.base", "tpl")
    web_base = tmpstr
  End If
End Function

Function web_head(ByVal head_key)
  Dim tpl_head: tpl_head = ireplace("global.tpl_public." & head_key, "tpl")
  web_head = tpl_head
End Function

Function web_foot(ByVal foot_key)
  Dim tpl_foot: tpl_foot = itake("global.tpl_public." & foot_key, "tpl")
  Dim tmpcopyright: tmpcopyright = itake("global.module.web_copyright", "lng")
  Dim enddtime: enddtime = Timer()
  Dim tmpspeed: tmpspeed = FormatNumber((enddtime - starttime) * 1000, 3)
  tmpcopyright = replace_template(tmpcopyright, "{$speed}", tmpspeed)
  tpl_foot = replace_template(tpl_foot, "{$copyright}", tmpcopyright)
  tpl_foot = creplace(tpl_foot)
  web_foot = tpl_foot & vbcrlf & "<!--JTBC(1.0), Processed in " & tmpspeed & " ms-->"
End Function

Sub jtbc_cms_web_head(ByVal head_key)
  response.write web_head(head_key)
End Sub

Sub jtbc_cms_web_foot(ByVal foot_key)
  response.write web_foot(foot_key)
End Sub

Sub jtbc_cms_web_message(ByVal strers, ByVal strurls)
  Dim tpl_web_message
  If cstr(strurls) = "0" Then
    tpl_web_message = ireplace("global.tpl_common.web_messages", "tpl")
    tpl_web_message = replace(tpl_web_message, "{$message}", strers)
  Else
    tpl_web_message = ireplace("global.tpl_common.web_message", "tpl")
    tpl_web_message = replace(tpl_web_message, "{$message}", strers)
    tpl_web_message = replace(tpl_web_message, "{$backurl}", strurls)
  End If
  response.write tpl_web_message
End Sub

Sub imessage(ByVal strers, ByVal strurls)
  response.clear
  Call jtbc_cms_web_head(default_head)
  Call jtbc_cms_web_message(strers, strurls)
  Call jtbc_cms_web_foot(default_foot)
  response.end
  Call jtbc_cms_close
End Sub

Sub jtbc_cms_web_noout()
  Dim server_v1, server_v2
  server_v1 = Cstr(Request.ServerVariables("HTTP_REFERER"))
  server_v2 = Cstr(Request.ServerVariables("SERVER_NAME"))
  If Not Mid(server_v1, 8, Len(server_v2)) = server_v2 Then
    Call imessage(itake("global.lng_common.noout", "lng"), -1)
  End If
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
