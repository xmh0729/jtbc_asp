<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Option Explicit
'On Error Resume Next
Server.scripttimeout = "50"
'Response.CodePage = 65001
Response.Charset = "utf-8"
Response.buffer = True
Const appname = "jtbc_"
Const adminfolder = "admin"
Const default_head = "default_head"
Const default_foot = "default_foot"
Const dbtype = 0 '0:Access,1:Sql Server
Const fso_object = "Scripting.FileSystemObject"
Const isapp = 1
Const ncharset = "utf-8"
Const navspstr = " &raquo; "
Const spa = "$:$"
Const spb = "$|$"
Const spstr = " - "
Const sysname = "JTBC"
Const userfolder = "passport"
Const xmltype = ".jtbc"
Const zcstr = "jtbc"
Dim starttime: starttime = Timer()
Dim default_skin: default_skin = "default"
Dim default_language: default_language = "chinese"
Dim default_template: default_template = "tpl_default"
Dim vbcrlf: vbcrlf = Chr(13) & Chr(10)
Dim jtbc_cinfo: jtbc_cinfo = "<!--jtbcrinfo-->"
Dim ECtype, ErrStr
Dim nroute, nskin, nlng, nurlpre, nclstype, nurl, nuri, nurs, ntitle
Dim nhead, nfoot
Dim ngenre, npopedom, npagesize, nlisttopx
Dim ndatabase, nidfield, nfpre, ncontrol, ncontrols
Dim nuserip, nusername, nuppath, nuptype, nupident, nvalidate
Dim nurltype, nbasehref, ncreatefolder, ncreatefiletype
Dim sort_database, sort_idfield, sort_fpre
Dim images_route, global_images_route
Dim rs, sqlstr, rsfields, rstfields
Dim connstr, conn, codic

Sub jtbc_cms_getting()
  nvalidate = get_num(get_value("common.nvalidate"), 0)
  sort_database = get_str(get_value("common.sort.ndatabase"))
  sort_idfield = get_str(get_value("common.sort.nidfield"))
  sort_fpre = get_str(get_value("common.sort.nfpre"))
  images_route = itake("global.tpl_config.images_route", "tpl")
  global_images_route = get_actual_route(images_route)
End Sub

Sub jtbc_cms_setting()
  If Not request.querystring("site_language") = "" Then
    response.cookies(appname & "config")("language") = request.querystring("site_language")
    response.cookies(appname & "config").expires = Date + 365
  End If
  If Not request.querystring("site_template") = "" Then
    response.cookies(appname & "config")("template") = request.querystring("site_template")
    response.cookies(appname & "config").expires = Date + 365
  End If
  If Not request.querystring("site_skin") = "" Then
    response.cookies(appname & "config")("skin") = request.querystring("site_skin")
    response.cookies(appname & "config").expires = Date + 365
  End If
End Sub

Sub jtbc_cms_init(ByVal route)
  On Error Resume Next
  Call jtbc_cms_setting
  nroute = route
  nuri = request.ServerVariables("URL")
  nurl = request.ServerVariables("URL")
  nurlpre = "http://" & request.ServerVariables("SERVER_NAME")
  nurs = request.ServerVariables("QUERY_STRING")
  If not check_null(nurs) Then nurl = nurl & "?" & nurs
  nlng = get_active_things("lng")
  nskin = get_active_things("skin")
  nuserip = request.servervariables("http_x_forwarded_for")
  If nuserip = "" then nuserip = request.servervariables("remote_addr")
  Select Case dbtype
  Case 0
    Dim datapath: datapath = get_actual_route("common/database/#db.asa")
    connstr = "provider=microsoft.jet.oledb.4.0;data source=" & server.mappath(datapath)
  Case 1
    Dim sql_databasename, sql_password, sql_username, sql_localname
    sql_localname = "127.0.0.1"
    sql_databasename = "db_jtbc1"
    sql_username = "sa"
    sql_password = ""
    connstr = "Provider = Sqloledb; User ID = " & sql_username & "; Password = " & sql_password & "; Initial Catalog = " & sql_databasename & "; Data Source = " & sql_localname & ";"
  End Select
  Set conn = server.CreateObject("ADODB.Connection")
  conn.open connstr
  If Err.Number <> 0 Then
    Call clear_show("Database.Error!",1)
  End If
  Set codic = New module_variable
  If Err.Number <> 0 Then
    Call clear_show("Module_Variable.Error!",1)
  End If
  Call jtbc_cms_getting
End Sub

Sub jtbc_cms_close()
  If IsObject(rs) Then Set rs = Nothing
  If IsObject(conn) Then Set conn = Nothing
  If IsObject(codic) Then Set codic = Nothing
End Sub
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
