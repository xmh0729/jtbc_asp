<!--#include file="../../common/incfiles/web.asp"-->
<!--#include file="../../common/incfiles/admin.asp"-->
<!--#include file="../common/api/user.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<!--#include file="common/incfiles/manage_config.asp"-->
<%
Call jtbc_cms_islogin()
Call jtbc_cms_admin_manage_action()
Call jtbc_cms_web_head(admin_head)
Call jtbc_cms_admin_manage()
Call jtbc_cms_web_foot(admin_foot)
Call jtbc_cms_close()
%>
