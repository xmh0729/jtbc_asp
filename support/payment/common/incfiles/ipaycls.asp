<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************

'以下为网银在线接口的代码
Class chinabank
  Private t_key
  Private t_mid

  Private Sub Class_Initialize()
    t_key = "732300000558b5e395f2c67134******" '用户填写
    t_mid = "34***" '用户填写
  End Sub

  Public Function ipay_form(ByVal stramount)
    Dim torderid: torderid = urlencode(request.querystring("orderid"))
    Dim tpgenre: tpgenre = urlencode(request.querystring("pgenre"))
    Dim t_amount, t_moneytype, t_style, t_url, t_remark1, t_remark2
    Dim t_curdate, t_oid, t_text, t_md5info
    t_amount = get_num(stramount, 0)
    t_moneytype = "0"
    t_style = "0"
    t_url = nurlpre & nuri & "?type=receive&pgenre=" & tpgenre & "&orderid=" & torderid 
    t_remark1 = ""
    t_remark2 = ""
    t_curdate = Now()
    t_oid = Year(t_curdate) & Month(t_curdate) & Day(t_curdate) & "-" & t_mid & "-" & Hour(t_curdate) & Minute(t_curdate) & Second(t_curdate)
    t_text = t_amount & t_moneytype & t_oid & t_mid & t_url & t_key
    t_md5info = Ucase(md5(t_text, "1"))
    Dim t_strs: t_strs = ""
    t_strs = t_strs & "<form method=""post"" action=""https://pay.chinabank.com.cn/select_bank"" target=""_blank"">" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_md5info"" value=""" & t_md5info & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_mid"" value=""" & t_mid & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_oid"" value=""" & t_oid & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_amount"" value=""" & t_amount & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_moneytype"" value=""" & t_moneytype & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""v_url"" value=""" & t_url & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""style"" value=""" & t_style & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""remark1"" value=""" & t_remark1 & """>" & vbcrlf
    t_strs = t_strs & "<input type=""hidden"" name=""remark2"" value=""" & t_remark2 & """>" & vbcrlf
    t_strs = t_strs & "<input type=""submit"" name=""v_action"" value=""" & itake("module.submit", "lng") & """ class=""button"">" & vbcrlf
    t_strs = t_strs & "</form>" & vbcrlf
    ipay_form = t_strs
  End Function

  Public Function ipay_receive()
    Dim t_oid, t_pmode, t_pstatus, t_pstring, t_amount, t_moneytype
    Dim t_remark1, t_remark2, t_md5str, t_text, t_md5text
    t_oid = request("v_oid")
    t_pmode = request("v_pmode")
    t_pstatus = request("v_pstatus")
    t_pstring = request("v_pstring")
    t_amount = request("v_amount")
    t_moneytype = request("v_moneytype")
    t_remark1 = request("remark1")
    t_remark2 = request("remark2")
    t_md5str = request("v_md5str")
    t_text = t_oid & t_pstatus & t_amount & t_moneytype & t_key
    t_md5text = Ucase(md5(t_text, "1"))
    If check_null(t_md5str) Then
      ipay_receive = -1
    Else
      If t_md5text <> t_md5str Then
        ipay_receive = -1
      Else
        If t_pstatus = 20 Then
          ipay_receive = get_num(t_amount, 0)
          payid = t_oid
        Else
          ipay_receive = -1
        End If
      End If
    End If
  End Function

  Private Sub Class_Terminate()
  End Sub
End Class
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
