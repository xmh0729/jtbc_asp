<!--#include file="ipaycls.asp"-->
<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const ispayops = 1
Const ispaycls = 1
Dim payobj, payid

Function ipay_form(ByVal stramount)
  If ispayops = 0 Then Exit Function
  Select Case ispaycls
    Case 1
      Set payobj = New chinabank
      ipay_form = payobj.ipay_form(stramount)
      Set payobj = Nothing
  End Select
End Function

Function ipay_receive()
  If ispayops = 0 Then Exit Function
  Select Case ispaycls
    Case 1
      Set payobj = New chinabank
      ipay_receive = payobj.ipay_receive
      Set payobj = Nothing
  End Select
End function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
