<%
Call jtbc_cms_init("node")
ngenre = get_actual_genre(nuri, nroute)
nhead = get_str(get_value(ngenre & ".nhead"))
nfoot = get_str(get_value(ngenre & ".nfoot"))
npagesize = get_num(get_value(ngenre & ".npagesize"), 0)
ntitle = itake("module.channel_title","lng")
Dim nsearch_genre: nsearch_genre = get_str(get_value(ngenre & ".nsearch_genre"))
Dim nsearch_field: nsearch_field = get_str(get_value(ngenre & ".nsearch_field"))
If check_null(nhead) Then nhead = default_head
If check_null(nfoot) Then nfoot = default_foot
%>
