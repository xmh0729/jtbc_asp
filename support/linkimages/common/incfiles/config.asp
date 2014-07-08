<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
nuppath = get_str(get_value(cvgenre(ngenre) & ".nuppath"))
nuptype = get_str(get_value(cvgenre(ngenre) & ".nuptype"))
ndatabase = get_str(get_value(cvgenre(ngenre) & ".ndatabase"))
nidfield = get_str(get_value(cvgenre(ngenre) & ".nidfield"))
nfpre = get_str(get_value(cvgenre(ngenre) & ".nfpre"))
ncontrol = "select,delete"
%>
