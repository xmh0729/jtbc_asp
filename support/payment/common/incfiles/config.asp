<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(cvgenre(ngenre) & ".nhead"))
nfoot = get_str(get_value(cvgenre(ngenre) & ".nfoot"))
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
ndatabase = get_str(get_value(cvgenre(ngenre) & ".ndatabase"))
nidfield = get_str(get_value(cvgenre(ngenre) & ".nidfield"))
nfpre = get_str(get_value(cvgenre(ngenre) & ".nfpre"))
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot

Sub update_support_payment_information(ByVal strorderid, ByVal strpayorderid, ByVal strgenre, ByVal strpayid, ByVal strpaymoney)
  Dim trs, tsqlstr
  tsqlstr = "select * from " & ndatabase
  Set trs = server.CreateObject("adodb.recordset")
  trs.open tsqlstr, conn, 1, 3
  trs.addnew
  trs(cfname("orderid")) = get_str(strorderid)
  trs(cfname("payorderid")) = get_str(strpayorderid)
  trs(cfname("genre")) = get_str(strgenre)
  trs(cfname("payid")) = get_num(strpayid, 0)
  trs(cfname("paymoney")) = get_num(strpaymoney, 0)
  trs(cfname("time")) = Now()
  trs.update
  Set trs = Nothing
End Sub
%>
