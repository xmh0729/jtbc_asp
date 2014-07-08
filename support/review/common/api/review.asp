<%
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
Const rvwngenre = "support"
Const rvwnsort = "review"

Function review_output_note(ByVal strkeys, ByVal strfid, ByVal strtopx)
  Dim tstrkeys, tstrfid, tstrtopx
  tstrkeys = get_safecode(strkeys)
  tstrfid = get_num(strfid, 0)
  tstrtopx = get_num(strtopx, 0)
  Dim tdatabase, tidfield, tfpre
  tdatabase = cndatabase(rvwngenre & "." & rvwnsort, "0")
  tidfield = cnidfield(rvwngenre & "." & rvwnsort, "0")
  tfpre = cnfpre(rvwngenre & "." & rvwnsort, "0")
  Dim trs, tsqlstr
  tsqlstr = "select top " & tstrtopx & " * from " & tdatabase & " where " & cfnames(tfpre, "keyword") & "='" & tstrkeys & "' and " & cfnames(tfpre, "fid") & "=" & tstrfid & " order by " & cfnames(tfpre, "time") & " desc"
  Set trs = conn.Execute(tsqlstr)
  Dim tmpstr, tmpastr, tmprstr, tmptstr
  tmpstr = ireplace("global." & rvwngenre & "." & rvwnsort & ":api.output_note", "tpl")
  tmpastr = ctemplate(tmpstr, "{$recurrence_ida}")
  Do While not trs.EOF
    tmptstr = Replace(tmpastr, "{$author}", htmlencode(get_str(trs(cfnames(tfpre, "author")))))
    tmptstr = Replace(tmptstr, "{$authorip}", htmlencode(format_ip(get_str(trs(cfnames(tfpre, "authorip"))), 2)))
    tmptstr = Replace(tmptstr, "{$content}", encode_article(ubbcode(htmlencode(get_str(trs(cfnames(tfpre, "content")))), 0)))
    tmptstr = Replace(tmptstr, "{$time}",  get_date(trs(cfnames(tfpre, "time"))))
    tmptstr = Replace(tmptstr, "{$id}", get_num(trs(tidfield),0))
    trs.movenext
    tmprstr = tmprstr & tmptstr
  loop
  Set trs = nothing
  tmpstr = Replace(tmpstr, jtbc_cinfo, tmprstr)
  review_output_note = tmpstr
End Function

Function review_input_form(ByVal strkeys, ByVal strfid)
  Dim tstr: tstr = ireplace("global." & rvwngenre & "." & rvwnsort & ":api.input_form", "tpl")
  tstr = replace(tstr, "{$keyword}", urlencode(strkeys))
  tstr = replace(tstr, "{$fid}", urlencode(strfid))
  review_input_form = tstr
End Function
'****************************************************
' JTBC CMS Power by Jetiben.com
' Email: jetiben@hotmail.com
' Web: http://www.jtbc.net.cn/
'****************************************************
%>
