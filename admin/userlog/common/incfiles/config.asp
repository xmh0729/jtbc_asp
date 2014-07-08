<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
ndatabase = get_str(get_value("common.adminlog.ndatabase"))
nidfield = get_str(get_value("common.adminlog.nidfield"))
nfpre = get_str(get_value("common.adminlog.nfpre"))
%>
