<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
Dim JS_timeout: JS_timeout = get_num(get_value(cvgenre(ngenre) & ".timeout"), 0)
%>
