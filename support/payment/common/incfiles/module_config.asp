<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Function jtbc_cms_module_pay()
  Dim torderid, tpgenre, tmpstr
  torderid = get_safecode(request.querystring("orderid"))
  tpgenre = get_safecode(request.querystring("pgenre"))
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(tpgenre, "0")
  tidfield = cnidfield(tpgenre, "0")
  tfpre = cnfpre(tpgenre, "0")
  If check_null(tdatabase) Then Exit Function
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "state") & "<>-1 and " & cfnames(tfpre, "orderid") & "='" & torderid & "'"
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    If rs(cfnames(tfpre, "prepaid")) = 1 Then
      Call imessage(itake("module.prepaid", "lng"), -1)
    Else
      tmpstr = itake("module.pay", "tpl")
      tmpstr = replace(tmpstr, "{$orderid}", torderid)
      tmpstr = replace(tmpstr, "{$name}", htmlencode(get_str(rs(cfnames(tfpre, "name")))))
      tmpstr = replace(tmpstr, "{$address}", htmlencode(get_str(rs(cfnames(tfpre, "address")))))
      tmpstr = replace(tmpstr, "{$money}", get_num(rs(cfnames(tfpre, "allprice")), 0))
      tmpstr = replace(tmpstr, "{$pgenre}", htmlencode(tpgenre))
      tmpstr = creplace(tmpstr)
    End If
    jtbc_cms_module_pay = tmpstr
  Else
    Call imessage(itake("module.inexistence", "lng"), -1)
  End If
  Set rs = Nothing
End Function

Function jtbc_cms_module_receive()
  Dim torderid, tpgenre, tmpstr
  torderid = get_safecode(request.querystring("orderid"))
  tpgenre = get_str(request.querystring("pgenre"))
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(tpgenre, "0")
  tidfield = cnidfield(tpgenre, "0")
  tfpre = cnfpre(tpgenre, "0")
  If check_null(tdatabase) Then Exit Function
  Set rs = server.CreateObject("adodb.recordset")
  sqlstr = "select * from " & tdatabase & " where " & cfnames(tfpre, "orderid") & "='" & torderid & "'"
  rs.open sqlstr, conn, 1, 3
  If not rs.EOF Then
    If rs(cfnames(tfpre, "prepaid")) = 1 Then
      Call imessage(itake("module.prepaid", "lng"), 0)
    Else
      Dim tpaymoney: tpaymoney = ipay_receive
      Dim tpaystr
      If tpaymoney = -1 Then
        tpaystr = itake("module.payinfo1", "lng")
      ElseIf tpaymoney <> get_num(rs(cfnames(tfpre, "allprice")), 0) Then
        tpaystr = itake("module.payinfo2", "lng")
      Else
        tpaystr = itake("module.payinfo3", "lng")
        rs(cfnames(tfpre, "prepaid")) = 1
        rs(cfnames(tfpre, "payid")) = payid
        rs.update
        Call update_support_payment_information(torderid, payid, tpgenre, rs(tidfield), tpaymoney)
      End If
      tmpstr = itake("module.receive", "tpl")
      tmpstr = replace(tmpstr, "{$orderid}", htmlencode(torderid))
      tmpstr = replace(tmpstr, "{$paystr}", htmlencode(tpaystr))
      tmpstr = replace(tmpstr, "{$pgenre}", htmlencode(tpgenre))
      tmpstr = creplace(tmpstr)
    End If
    jtbc_cms_module_receive = tmpstr
  Else
    Call imessage(itake("module.inexistence", "lng"), 0)
  End If
  Set rs = Nothing
End Function

Function jtbc_cms_module
  Select Case request.querystring("type")
    Case "pay"
      jtbc_cms_module = jtbc_cms_module_pay
    Case "receive"
      jtbc_cms_module = jtbc_cms_module_receive
    Case Else
      jtbc_cms_module = jtbc_cms_module_pay
  End Select
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
