<!--#include file="../../common/incfiles/web.asp"-->
<!--#include file="../../common/incfiles/md5.asp"-->
<!--#include file="../../common/incfiles/module.asp"-->
<!--#include file="common/incfiles/config.asp"-->
<!--#include file="common/incfiles/ipay.asp"-->
<!--#include file="common/incfiles/module_config.asp"-->
<%
Dim myhtml: myhtml = jtbc_cms_module
response.write myhtml
Call jtbc_cms_close()
%>
