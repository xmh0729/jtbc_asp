<!--#include file="../common/incfiles/web.asp"-->
<!--#include file="../common/incfiles/admin.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<!--#include file="common/incfiles/main.asp"-->
<%
Call jtbc_cms_islogin()
Call jtbc_cms_web_head(admin_head)
Call jtbc_cms_manage()
Call jtbc_cms_web_foot(admin_foot)
Call jtbc_cms_close()
%>
