<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Dim slng: slng = get_safecode(request.querystring("slng"))
If check_null(slng) Then slng = nlng

Function manage_navigation(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    manage_navigation = tcls.manage_navigation
  End If
  Set tcls = Nothing
End Function

Sub jtbc_cms_admin_manage_list(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_list
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_edit(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_edit
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_transfer(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_transfer
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_delete(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_delete
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_update(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_update
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_adddisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_adddisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_editdisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_editdisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_deletedisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_deletedisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_orderdisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_orderdisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_transferdisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_transferdisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_updatedisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call tcls.manage_updatedisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_controldisp(ByVal strers)
  On Error Resume Next
  Dim tcls
  Set tcls = Eval("New manage_forum_" & strers)
  If Err.Number = 0 Then
    Call jtbc_cms_admin_controldisp
  End If
  Set tcls = Nothing
End Sub

Sub jtbc_cms_admin_manage_action()
  Select Case request.querystring("action")
    Case "add_sort"
      Call jtbc_cms_admin_manage_adddisp("sort")
    Case "edit_sort"
      Call jtbc_cms_admin_manage_editdisp("sort")
    Case "delete_sort"
      Call jtbc_cms_admin_manage_deletedisp("sort")
    Case "order_sort"
      Call jtbc_cms_admin_manage_orderdisp("sort")
    Case "control_sort"
      Call jtbc_cms_admin_manage_controldisp("sort")
    Case "transfer_dispose"
      Call jtbc_cms_admin_manage_transferdisp("dispose")
    Case "delete_dispose"
      Call jtbc_cms_admin_manage_deletedisp("dispose")
    Case "update_dispose"
      Call jtbc_cms_admin_manage_updatedisp("dispose")
  End Select
End Sub

Sub jtbc_cms_admin_manage()
  Select Case request.querystring("type")
    Case "edit_sort"
      Call jtbc_cms_admin_manage_edit("sort")
    Case "transfer_dispose"
      Call jtbc_cms_admin_manage_transfer("dispose")
    Case "delete_dispose"
      Call jtbc_cms_admin_manage_delete("dispose")
    Case "update_dispose"
      Call jtbc_cms_admin_manage_update("dispose")
    Case Else
      Call jtbc_cms_admin_manage_list("sort")
  End Select
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
