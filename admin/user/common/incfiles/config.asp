<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
ndatabase = get_str(get_value("common.admin.ndatabase"))
nidfield = get_str(get_value("common.admin.nidfield"))
nfpre = get_str(get_value("common.admin.nfpre"))
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
%>
