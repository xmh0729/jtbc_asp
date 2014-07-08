<%
Const nmerchandise = "shop"
call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
npagesize = get_num(get_value(ngenre & ".npagesize"), 0)
ndatabase = get_str(get_value(ngenre & ".ndatabase"))
nidfield = get_str(get_value(ngenre & ".nidfield"))
nfpre = get_str(get_value(ngenre & ".nfpre"))
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
%>
