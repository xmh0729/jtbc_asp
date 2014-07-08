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
Dim message_max: message_max = get_num(get_value(cvgenre(ngenre) & ".message_max"), 0)
%>
