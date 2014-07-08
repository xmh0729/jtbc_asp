<%
Call jtbc_cms_init("child")
ngenre = get_actual_genre(nuri, nroute)
npagesize = get_num(get_value(cvgenre(ngenre) & ".npagesize"), 0)
ndatabase = get_str(get_value(cvgenre(ngenre) & ".ndatabase"))
nidfield = get_str(get_value(cvgenre(ngenre) & ".nidfield"))
nfpre = get_str(get_value(cvgenre(ngenre) & ".nfpre"))
Const njspath = "common/js/"

Function js_encode2js(ByVal strers)
  If not check_null(strers) Then
    Dim tstrers: tstrers = get_str(strers)
    tstrers = encode_newline(tstrers)
    Dim tarys: tarys = split(tstrers, vbcrlf)
    Dim ti, tstr, tmpstr
    For ti = 0 to UBound(tarys)
      tstr = tarys(ti)
      If not check_null(tstr) Then
        tmpstr = tmpstr & "document.write(""" & encode_forscript(tstr) & """);" & vbcrlf
      End If
    Next
    js_encode2js = tmpstr
  End If
End Function

Function get_js_retimetype(ByVal strers)
  Dim tstrers: tstrers = get_num(strers, 0)
  Select Case tstrers
    Case 0
      get_js_retimetype = "n"
    Case 1
      get_js_retimetype = "h"
    Case 2
      get_js_retimetype = "d"
    Case Else
      get_js_retimetype = "d"
  End Select
End Function
%>
