<%
Call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
nuppath = get_str(get_value(ngenre & ".nuppath"))
nuptype = get_str(get_value(ngenre & ".nuptype"))
npagesize = get_num(get_value(ngenre & ".npagesize"), 0)
nlisttopx = get_num(get_value(ngenre & ".nlisttopx"), 0)
ndatabase = get_str(get_value(ngenre & ".ndatabase"))
nidfield = get_str(get_value(ngenre & ".nidfield"))
nfpre = get_str(get_value(ngenre & ".nfpre"))
nurltype = get_num(get_value(ngenre & ".nurltype"), 0)
nclstype = get_num(get_value(ngenre & ".nclstype"), 0)
nbasehref = get_num(get_value(ngenre & ".nbasehref"), 0)
ncreatefolder = get_str(get_value(ngenre & ".ncreatefolder"))
ncreatefiletype = get_str(get_value(ngenre & ".ncreatefiletype"))
ntitle = itake("module.channel_title","lng")
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
%>
