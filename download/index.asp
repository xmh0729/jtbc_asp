<!--#include file="../common/incfiles/web.asp"-->
<!--#include file="../common/incfiles/ubbcode.asp"-->
<!--#include file="../common/incfiles/module.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<!--#include file="common/incfiles/module_config.asp"-->
<%
Call jtbc_cms_module_action()
Dim myhtml: myhtml = jtbc_cms_module
response.write myhtml
Call jtbc_cms_close()
%>