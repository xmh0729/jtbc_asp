<%
Call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
nuppath = get_str(get_value(ngenre & ".nuppath"))
nuptype = get_str(get_value(ngenre & ".nuptype"))
npagesize = get_str(get_value(ngenre & ".npagesize"))
nlisttopx = get_num(get_value(ngenre & ".nlisttopx"), 0)
ndatabase = get_str(get_value(ngenre & ".ndatabase"))
nidfield = get_str(get_value(ngenre & ".nidfield"))
nfpre = get_str(get_value(ngenre & ".nfpre"))
nurltype = get_num(get_value(ngenre & ".nurltype"), 0)
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
%>