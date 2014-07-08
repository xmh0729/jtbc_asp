<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
%>
